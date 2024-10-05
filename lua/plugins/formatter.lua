return {
    -- {
    --     "nvimtools/none-ls.nvim",
    --     config = function()
    --         local null_ls = require("null-ls")
    --         null_ls.setup({
    --             sources = {
    --                 null_ls.builtins.formatting.stylua,
    --             },
    --         })
    --     end,
    -- },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                lua = { "stylua" },
                python = function(bufnr)
                    if require("conform").get_formatter_info("ruff_format", bufnr).available then
                        return { "ruff_format" }
                    else
                        return { "isort", "black" }
                    end
                end,
                json = { "jq" },
                xml = { "xmlformat" },
                yaml = { "yq" },
                markdown = { "prettier" },
                graphql = { "prettier" },
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
