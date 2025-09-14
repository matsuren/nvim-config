return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_open_to_the_world = 1 -- access from other devices
        end,
        ft = { "markdown" },
    },
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            default = {
                dir_path = "attachments",
                prompt_for_file_name = false,
                relative_to_current_file = true,
                copy_images = true,
                insert_mode_after_paste = false,
            },
        },
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        -- ft = "markdown",
        event = {
            "BufReadPre " .. vim.fn.expand("~/vaults") .. "/**.md",
            "BufNewFile " .. vim.fn.expand("~/vaults") .. "/**.md",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "default",
                    path = "~/vaults",
                },
                {
                    name = "no-vault",
                    path = function()
                        -- alternatively use the CWD:
                        -- return assert(vim.fn.getcwd())
                        return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
                    end,
                    overrides = {
                        notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
                        new_notes_location = "current_dir",
                        templates = {
                            folder = vim.NIL,
                        },
                        disable_frontmatter = true,
                    },
                },
            },
            notes_subdir = "notes",
            log_level = vim.log.levels.INFO,
            daily_notes = {
                folder = "notes/dailies",
                -- Optional, if you want to change the date format for the ID of daily notes.
                date_format = "%Y-%m-%d",
                -- Optional, default tags to add to each new daily note created.
                default_tags = { "daily-notes" },
                -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
                template = nil,
            },
            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },
            new_notes_location = "current_dir",
            preferred_link_style = "markdown",
            ui = { enable = false },
        },
    },
}
