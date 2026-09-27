-- ============================================================
-- Which-key shows available keymaps after pressing a prefix.
-- ============================================================
return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
        spec = {
            { '<leader>f', group = 'find' },
            { '<leader>g', group = 'git' },
            { '<leader>h', group = 'git hunk' },
        },
    },
}
