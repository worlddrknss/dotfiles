-- ============================================================
-- Lualine is a statusline plugin for Neovim written in Lua.
-- ============================================================
-- Drknss statusline: mode block in the palette's green/olive/grey/red,
-- the rest transparent so the terminal background shows through.
local c = {
    black = '#000000', surface = '#1a1a1a', muted = '#6b6b6b', subtle = '#a3a3a3',
    fg = '#d9d9d9', green = '#4dd44d', olive = '#b8b84a', red = '#e5332a', sea = '#52b788',
}
local function mode(color)
    return {
        a = { fg = c.black, bg = color, gui = 'bold' },
        b = { fg = c.fg, bg = c.surface },
        c = { fg = c.subtle, bg = 'NONE' },
    }
end
local drknss = {
    normal = mode(c.green),
    insert = mode(c.olive),
    visual = mode(c.subtle),
    replace = mode(c.red),
    command = mode(c.sea),
    terminal = mode(c.sea),
    inactive = {
        a = { fg = c.muted, bg = 'NONE' },
        b = { fg = c.muted, bg = 'NONE' },
        c = { fg = c.muted, bg = 'NONE' },
    },
}

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = { theme = drknss },
    },
}
