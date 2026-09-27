-- ============================================================
-- Lazygit opens the lazygit TUI in a floating window.
-- ============================================================
return {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit', 'LazyGitCurrentFile', 'LazyGitLog' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        { '<leader>gg', '<Cmd>LazyGit<CR>', desc = 'Lazygit' },
        { '<leader>gl', '<Cmd>LazyGitLog<CR>', desc = 'Lazygit log' },
    },
}
