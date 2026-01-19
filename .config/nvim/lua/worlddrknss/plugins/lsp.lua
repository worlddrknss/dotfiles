-- ==============================================================
-- LSP configuration for Neovim using mason and mason-lspconfig.
-- ==============================================================
return {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
        library = {{
            path = '${3rd}/luv/library',
            words = {'vim%.uv'}
        }}
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "lua_ls",
                "bashls",
                "gopls",
                "html",
                "cssls",
                "angularls"
            },
            automatic_installation = true
        },
        dependencies = {{
            "mason-org/mason.nvim",
            opts = {}
        }, "neovim/nvim-lspconfig"}
    }
}
