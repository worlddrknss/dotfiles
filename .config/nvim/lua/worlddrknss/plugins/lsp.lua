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
                "tsserver",
                "html",
                "cssls",
                "angularls",
                "dartls"
            },
            automatic_installation = true
        },
        dependencies = {{
            "mason-org/mason.nvim",
            opts = {}
        }, "neovim/nvim-lspconfig"}
    }
}
