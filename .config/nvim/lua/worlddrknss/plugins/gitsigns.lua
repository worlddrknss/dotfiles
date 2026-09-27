-- ============================================================
-- Gitsigns shows added/changed/deleted lines in the sign column.
-- ============================================================
return {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        on_attach = function(bufnr)
            local gs = require('gitsigns')
            local function map(lhs, rhs, desc)
                vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
            end
            map(']h', function() gs.nav_hunk('next') end, 'Next git hunk')
            map('[h', function() gs.nav_hunk('prev') end, 'Previous git hunk')
            map('<leader>hp', gs.preview_hunk, 'Preview hunk')
            map('<leader>hr', gs.reset_hunk, 'Reset hunk')
            map('<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
        end,
    },
}
