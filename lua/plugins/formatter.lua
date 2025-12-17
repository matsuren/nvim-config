return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format" },
                xml = { "xmlformat" },
                yaml = { "yamlfmt" },
                markdown = { "prettier" },
                json = { "biome" },
                css = { "biome" },
                graphql = { "biome" },
                javascript = { "biome" },
                javascriptreact = { "biome" },
                typescript = { "biome" },
                typescriptreact = { "biome" },
                go = { "gofumpt" },
                html = { "prettier" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            formatters = {
                injected = { options = { ignore_errors = true } },
            },
        },
        init = function()
            -- If you want the formatexpr, here is the place to set it
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
}
