-- =================================================================
-- Treesitter is a syntax parser plugin for Neovim written in Lua.
-- =================================================================
-- On the `main` branch, setup() no longer takes ensure_installed/highlight/
-- indent: parsers are installed with install() and highlighting is started
-- per buffer with vim.treesitter.start().
local parsers = {
    'bash',
    'go',
    'javascript',
    'typescript',
    'tsx',
    'lua',
    'html',
    'css',
    'dart',
    'json',
    'yaml',
    'markdown',
    'markdown_inline',
    'vim',
    'vimdoc',
    'regex',
    'dockerfile',
}

return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local ts = require('nvim-treesitter')
        -- Building parsers needs the tree-sitter CLI (brew install tree-sitter-cli)
        local can_build = vim.fn.executable('tree-sitter') == 1
        if can_build then
            ts.install(parsers)
        end

        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('worlddrknss_treesitter', { clear = true }),
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang then
                    return
                end
                if pcall(vim.treesitter.start, args.buf, lang) then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                elseif can_build and vim.tbl_contains(ts.get_available(), lang) then
                    -- No parser yet: install it; highlighting starts next time the file opens
                    ts.install(lang)
                end
            end,
        })
    end,
}
