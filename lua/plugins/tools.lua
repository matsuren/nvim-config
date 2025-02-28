return {
    -- REST request tool
    -- (optional) go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
    {
        "mistweaverco/kulala.nvim",
        ft = { "http", "rest" },
        opts = {
            global_keymaps = false, -- Set keymap in autocmds,lua
        },
        opts = {},
    },
}
