-- ==============================================================
-- LSP configuration for Neovim using mason and mason-lspconfig.
-- ==============================================================
return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                {
                    path = "${3rd}/luv/library",
                    words = { "vim%.uv" },
                },
            },
        },
    },
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = function()
            local ensure_installed = { "lua_ls" }

            -- bash, css and JS/TS servers are npm packages
            if vim.fn.executable("npm") == 1 then
                vim.list_extend(ensure_installed, {
                    "bashls",
                    "cssls",
                    "ts_ls",
                })
            end

            if vim.fn.executable("go") == 1 then
                table.insert(ensure_installed, "gopls")
            end

            -- mason-lspconfig v2 enables installed servers via vim.lsp.enable()
            return {
                ensure_installed = ensure_installed,
            }
        end,
    },
}
