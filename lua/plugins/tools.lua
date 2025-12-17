return {
    -- REST request tool
    -- (optional) go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
    {
        "mistweaverco/kulala.nvim",
        version = "4.*",
        ft = { "http", "rest" },
        opts = {
            global_keymaps = false, -- Set keymap in autocmds,lua
        },
    },
}
