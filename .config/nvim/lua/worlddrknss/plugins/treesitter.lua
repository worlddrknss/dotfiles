return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    -- main = 'nvim-treesitter.configs',
    opts = {
        ensure_installed = {'bash', 'go', 'javascript', 'typescript', 'lua'},
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false
        },
        indent = {
            enable = true
        }
    }
}
