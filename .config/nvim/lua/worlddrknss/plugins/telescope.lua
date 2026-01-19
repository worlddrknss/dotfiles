-- ================================================================================
-- Telescope is a highly extendable fuzzy finder plugin for Neovim written in Lua.
-- ================================================================================
return {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.1',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    }
}