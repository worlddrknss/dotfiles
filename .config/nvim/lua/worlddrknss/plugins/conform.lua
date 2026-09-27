-- ============================================================
-- Conform formats buffers on save, falling back to the LSP.
-- ============================================================
local prettier = { 'prettier' }

return {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    opts = {
        formatters_by_ft = {
            go = { 'gofmt' },
            sh = { 'shfmt' },
            bash = { 'shfmt' },
            javascript = prettier,
            javascriptreact = prettier,
            typescript = prettier,
            typescriptreact = prettier,
            css = prettier,
            json = prettier,
        },
        default_format_opts = { lsp_format = 'fallback' },
        format_on_save = function(bufnr)
            -- Leave Lua alone so saving this config doesn't reformat it
            if vim.bo[bufnr].filetype == 'lua' then
                return nil
            end
            -- prettier can take >1s on a cold start
            return { timeout_ms = 3000 }
        end,
    },
}
