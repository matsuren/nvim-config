# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Launch a Jupyter console shared by Neovim slime and a browser.

Neovim passes ``--language``, ``--project``, and ``--kernel-env``. Python also
receives the interpreter selected by ``venv-selector.nvim`` through ``--python``.
Julia prepares IJulia in the Neovim data directory; Python asks before adding
missing ``ipykernel`` to the selected environment. SymPy and Matplotlib remain
project dependencies and are never installed here.

The launcher creates a temporary, token-protected JupyterLab server, opens a
console workspace, and starts ``jupyter console`` against the same kernel.
Closing the terminal stops the server and kernel.
"""

import argparse
import json
import os
import secrets
import shutil
import signal
import subprocess
import sys
import tempfile
import time
import webbrowser
from pathlib import Path
from urllib.error import URLError
from urllib.request import Request, urlopen


def _request(
    url: str, token: str, method: str = "GET", data: dict | None = None
) -> dict:
    request = Request(
        url,
        data=None if data is None else json.dumps(data).encode(),
        headers={"Authorization": f"token {token}", "Content-Type": "application/json"},
        method=method,
    )
    with urlopen(request, timeout=5) as response:
        body = response.read()
        return json.loads(body) if body else {}


def _stop(process: subprocess.Popen) -> None:
    if process.poll() is not None:
        return
    process.terminate()
    try:
        process.wait(timeout=10)
    except subprocess.TimeoutExpired:
        process.kill()
        process.wait()


def _jupyter() -> str:
    tool_bin = subprocess.check_output(
        ["uv", "tool", "dir", "--bin"], text=True
    ).strip()
    os.environ["PATH"] = tool_bin + os.pathsep + os.environ.get("PATH", "")
    jupyter = shutil.which("jupyter")
    if jupyter is None or any(
        subprocess.run(
            [jupyter, command, "--version"], capture_output=True, check=False
        ).returncode
        != 0
        for command in ("lab", "console")
    ):
        raise SystemExit(
            "Install Jupyter first by running:\n"
            "  uv tool install --with jupyterlab --with jupyter-console jupyter-core\n"
            "Then retry the Jupyter launcher."
        )
    return jupyter


def _setup_julia(julia: str, kernel_env: Path, jupyter: str) -> None:
    print(
        "Preparing IJulia environment (first launch may take a few minutes)…",
        flush=True,
    )
    env = os.environ.copy()
    env.update({"JUPYTER": jupyter, "IJULIA_NODEFAULTKERNEL": "1"})
    subprocess.run(
        [
            julia,
            "--startup-file=no",
            f"--project={kernel_env}",
            "-e",
            'using Pkg; if !isfile(Base.active_project()); Pkg.add(PackageSpec(name="IJulia", version="1")); else; Pkg.instantiate(); end; using IJulia',
        ],
        env=env,
        check=True,
    )


def _ensure_ipykernel(python: Path) -> None:
    check = subprocess.run(
        [str(python), "-c", "import ipykernel"],
        capture_output=True,
        check=False,
    )
    if check.returncode == 0:
        return
    answer = (
        input(
            f"The selected environment lacks ipykernel. Install it in {python}? [y/N] "
        )
        .strip()
        .lower()
    )
    if answer not in {"y", "yes"}:
        raise SystemExit("Jupyter launcher stopped; ipykernel was not installed.")
    subprocess.run(
        ["uv", "pip", "install", "--python", str(python), "ipykernel"],
        check=True,
    )
    check = subprocess.run(
        [str(python), "-c", "import ipykernel"],
        capture_output=True,
        check=False,
    )
    if check.returncode:
        raise SystemExit("ipykernel installation did not complete successfully.")


def _julia_kernel(julia: str, kernel_env: Path, jupyter: str) -> list[str]:
    _setup_julia(julia=julia, kernel_env=kernel_env, jupyter=jupyter)
    return [
        julia,
        "--startup-file=no",
        "--color=yes",
        f"--project={kernel_env}",
        "-e",
        'push!(LOAD_PATH, Base.active_project()); using IJulia; import Pkg; Pkg.activate(ENV["NVIM_JULIA_PROJECT"]); IJulia.run_kernel()',
        "{connection_file}",
    ]


def _python_kernel(python: Path) -> list[str]:
    if not python.is_file():
        raise SystemExit(f"Selected Python interpreter does not exist: {python}")
    _ensure_ipykernel(python)
    return [
        str(python),
        "-m",
        "ipykernel_launcher",
        "--matplotlib=inline",
        "-f",
        "{connection_file}",
    ]


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Shared Julia/Python terminal and browser console"
    )
    parser.add_argument("--language", choices=("julia", "python"), default="julia")
    parser.add_argument("--project", type=Path, required=True)
    parser.add_argument("--kernel-env", type=Path, required=True)
    parser.add_argument("--python", type=Path)
    args = parser.parse_args()
    project = args.project.resolve()
    kernel_env = args.kernel_env.resolve()
    if not project.is_dir():
        parser.error(f"Project directory does not exist: {project}")
    jupyter = _jupyter()
    language = args.language
    label = language.title()
    if language == "julia":
        julia = shutil.which("julia")
        if julia is None:
            parser.error("julia is not on PATH")
        kernel_argv = _julia_kernel(julia=julia, kernel_env=kernel_env, jupyter=jupyter)
    else:
        if args.python is None:
            raise SystemExit(
                "Select a Python environment with :VenvSelect, then retry the Jupyter launcher."
            )
        kernel_argv = _python_kernel(python=args.python.absolute())

    with tempfile.TemporaryDirectory(prefix="nvim-jupyter-") as temporary:
        root = Path(temporary)
        token = secrets.token_urlsafe(32)
        env = os.environ.copy()
        env.update(
            {
                "JUPYTER_RUNTIME_DIR": str(root / "runtime"),
                "JUPYTER_DATA_DIR": str(root / "data"),
                "JUPYTER_CONFIG_DIR": str(root / "config"),
                "JUPYTERLAB_SETTINGS_DIR": str(root / "settings"),
                "JUPYTERLAB_WORKSPACES_DIR": str(root / "workspaces"),
                "NVIM_JULIA_PROJECT": str(project),
            }
        )
        kernel_dir = root / "data/kernels/nvim-jupyter"
        kernel_dir.mkdir(parents=True)
        (kernel_dir / "kernel.json").write_text(
            json.dumps(
                {
                    "argv": kernel_argv,
                    "display_name": f"{label} — {project.name}",
                    "language": language,
                }
            )
        )
        settings = root / "settings/@jupyterlab/console-extension"
        settings.mkdir(parents=True)
        (settings / "tracker.jupyterlab-settings").write_text(
            json.dumps({"showAllKernelActivity": True})
        )
        config = root / "config/jupyter_server_config.json"
        config.parent.mkdir(parents=True)
        config.write_text(
            json.dumps(
                {
                    "IdentityProvider": {"token": token},
                    "ServerApp": {
                        "ip": "127.0.0.1",
                        "port": 0,
                        "open_browser": False,
                        "root_dir": str(project),
                    },
                }
            )
        )
        console = None
        with (root / "server.log").open("w+") as log:
            server = subprocess.Popen(
                [jupyter, "lab", "--no-browser"],
                env=env,
                cwd=project,
                stdout=log,
                stderr=subprocess.STDOUT,
            )

            def interrupted(_signum: int, _frame: object) -> None:
                raise KeyboardInterrupt

            signal.signal(signal.SIGTERM, interrupted)
            signal.signal(signal.SIGHUP, interrupted)
            try:
                print(f"Starting {label} + JupyterLab…", flush=True)
                deadline = time.monotonic() + 90
                while time.monotonic() < deadline:
                    if server.poll() is not None:
                        raise RuntimeError("JupyterLab exited during startup")
                    server_files = list((root / "runtime").glob("jpserver-*.json"))
                    if server_files:
                        info = json.loads(server_files[0].read_text())
                        base = info["url"].rstrip("/")
                        try:
                            _request(base + "/api/status", token)
                            break
                        except (URLError, TimeoutError):
                            pass
                    time.sleep(0.2)
                else:
                    raise TimeoutError("JupyterLab did not become ready in 90 seconds")
                session = _request(
                    base + "/api/sessions",
                    token,
                    "POST",
                    {
                        "path": "nvim-jupyter-console",
                        "name": f"Neovim {label}",
                        "type": "console",
                        "kernel": {"name": "nvim-jupyter"},
                    },
                )
                kernel_id = session["kernel"]["id"]
                widget = "console:nvim-jupyter-console"
                workspace = {
                    "metadata": {"id": "nvim-jupyter"},
                    "data": {
                        widget: {
                            "data": {
                                "path": session["path"],
                                "name": f"Neovim {label}",
                                "kernelPreference": {
                                    "id": kernel_id,
                                    "shouldStart": False,
                                },
                            }
                        },
                        "layout-restorer:data": {
                            "main": {
                                "dock": {
                                    "type": "tab-area",
                                    "currentIndex": 0,
                                    "widgets": [widget],
                                },
                                "current": widget,
                            }
                        },
                    },
                }
                _request(
                    base + "/lab/api/workspaces/nvim-jupyter", token, "PUT", workspace
                )
                url = base + "/lab/workspaces/nvim-jupyter?token=" + token
                connection = root / "runtime" / f"kernel-{kernel_id}.json"
                webbrowser.open(url)
                print(
                    "Browser console connected. Send code with your configured slime mappings.",
                    flush=True,
                )
                console = subprocess.Popen(
                    [jupyter, "console", "--existing", str(connection)],
                    env=env,
                    cwd=project,
                )
                if console.wait() != 0:
                    raise RuntimeError("Jupyter console exited with an error")
            except KeyboardInterrupt:
                pass
            except Exception:
                log.flush()
                log.seek(0)
                print("Jupyter viewer failed; server diagnostics:", file=sys.stderr)
                print(log.read().replace(token, "<redacted>"), file=sys.stderr)
                raise
            finally:
                if console is not None:
                    _stop(console)
                _stop(server)


if __name__ == "__main__":
    main()
