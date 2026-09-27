-- ================================================================
-- Drknss: old-school black, greys, red and green.
-- Same palette as .config/wezterm/wezterm.lua and .config/starship.toml.
-- The editor background is transparent so WezTerm's blurred black
-- shows through; floats and menus get a solid near-black for legibility.
-- ================================================================
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.g.colors_name = "drknss"

local c = {
    none     = "NONE",
    black    = "#000000",
    float    = "#111111",
    surface  = "#1a1a1a",
    border   = "#2e2e2e",
    sel      = "#333333",
    linenr   = "#4d4d4d",
    muted    = "#6b6b6b",
    grey     = "#8c8c8c",
    subtle   = "#a3a3a3",
    fg       = "#d9d9d9",
    white    = "#ffffff",
    red      = "#e5332a",
    red_hi   = "#ff3b2f",
    green    = "#4dd44d",
    green_hi = "#7cff7c",
    olive    = "#b8b84a",
    sea      = "#52b788",
}

local groups = {
    -- Editor UI
    Normal           = { fg = c.fg, bg = c.none },
    NormalNC         = { fg = c.fg, bg = c.none },
    NormalFloat      = { fg = c.fg, bg = c.float },
    FloatBorder      = { fg = c.border, bg = c.float },
    FloatTitle       = { fg = c.green, bg = c.float, bold = true },
    SignColumn       = { bg = c.none },
    LineNr           = { fg = c.linenr },
    CursorLineNr     = { fg = c.green, bold = true },
    CursorLine       = { bg = c.surface },
    CursorColumn     = { bg = c.surface },
    ColorColumn      = { bg = c.surface },
    Visual           = { bg = c.sel },
    Search           = { fg = c.black, bg = c.olive },
    IncSearch        = { fg = c.black, bg = c.green },
    CurSearch        = { fg = c.black, bg = c.green },
    Substitute       = { fg = c.black, bg = c.red },
    MatchParen       = { fg = c.green_hi, bold = true, underline = true },
    WinSeparator     = { fg = c.border },
    VertSplit        = { fg = c.border },
    StatusLine       = { fg = c.subtle, bg = c.none },
    StatusLineNC     = { fg = c.muted, bg = c.none },
    TabLine          = { fg = c.muted, bg = c.none },
    TabLineSel       = { fg = c.green, bg = c.surface, bold = true },
    TabLineFill      = { bg = c.none },
    Pmenu            = { fg = c.fg, bg = c.float },
    PmenuSel         = { fg = c.green, bg = c.sel, bold = true },
    PmenuSbar        = { bg = c.surface },
    PmenuThumb       = { bg = c.border },
    Folded           = { fg = c.subtle, bg = c.surface },
    FoldColumn       = { fg = c.muted },
    NonText          = { fg = c.linenr },
    Whitespace       = { fg = c.border },
    EndOfBuffer      = { fg = c.black },
    Directory        = { fg = c.green },
    Title            = { fg = c.green, bold = true },
    ErrorMsg         = { fg = c.red, bold = true },
    WarningMsg       = { fg = c.olive },
    MoreMsg          = { fg = c.green },
    ModeMsg          = { fg = c.subtle },
    Question         = { fg = c.green },
    QuickFixLine     = { bg = c.sel },
    SpellBad         = { sp = c.red, undercurl = true },
    SpellCap         = { sp = c.olive, undercurl = true },
    WildMenu         = { fg = c.black, bg = c.green },

    -- Syntax
    Comment          = { fg = c.muted, italic = true },
    Constant         = { fg = c.red_hi },
    String           = { fg = c.sea },
    Character        = { fg = c.sea },
    Number           = { fg = c.red_hi },
    Boolean          = { fg = c.red_hi },
    Float            = { fg = c.red_hi },
    Identifier       = { fg = c.fg },
    Function         = { fg = c.white, bold = true },
    Statement        = { fg = c.green },
    Keyword          = { fg = c.green },
    Conditional      = { fg = c.green },
    Repeat           = { fg = c.green },
    Label            = { fg = c.green },
    Exception        = { fg = c.red },
    Operator         = { fg = c.subtle },
    PreProc          = { fg = c.red },
    Include          = { fg = c.red },
    Define           = { fg = c.red },
    Macro            = { fg = c.red },
    Type             = { fg = c.green_hi },
    StorageClass     = { fg = c.green },
    Structure        = { fg = c.green_hi },
    Typedef          = { fg = c.green_hi },
    Special          = { fg = c.olive },
    SpecialChar      = { fg = c.olive },
    Delimiter        = { fg = c.grey },
    SpecialComment   = { fg = c.grey, italic = true },
    Underlined       = { underline = true },
    Error            = { fg = c.red, bold = true },
    Todo             = { fg = c.black, bg = c.olive, bold = true },

    -- Treesitter
    ["@variable"]              = { fg = c.fg },
    ["@variable.builtin"]      = { fg = c.red },
    ["@variable.parameter"]    = { fg = c.fg, italic = true },
    ["@variable.member"]       = { fg = c.subtle },
    ["@property"]              = { fg = c.subtle },
    ["@constant.builtin"]      = { fg = c.red_hi },
    ["@module"]                = { fg = c.subtle },
    ["@function.builtin"]      = { fg = c.white },
    ["@function.method"]       = { link = "Function" },
    ["@constructor"]           = { fg = c.green_hi },
    ["@keyword.return"]        = { fg = c.green, bold = true },
    ["@keyword.import"]        = { link = "Include" },
    ["@punctuation"]           = { fg = c.grey },
    ["@punctuation.bracket"]   = { fg = c.grey },
    ["@punctuation.delimiter"] = { fg = c.grey },
    ["@string.escape"]         = { fg = c.olive },
    ["@string.special"]        = { fg = c.olive },
    ["@tag"]                   = { fg = c.green },
    ["@tag.attribute"]         = { fg = c.subtle },
    ["@tag.delimiter"]         = { fg = c.grey },
    ["@markup.heading"]        = { fg = c.green, bold = true },
    ["@markup.strong"]         = { bold = true },
    ["@markup.italic"]         = { italic = true },
    ["@markup.link"]           = { fg = c.sea, underline = true },
    ["@markup.raw"]            = { fg = c.sea },
    ["@markup.list"]           = { fg = c.green },

    -- Diagnostics
    DiagnosticError            = { fg = c.red },
    DiagnosticWarn             = { fg = c.olive },
    DiagnosticInfo             = { fg = c.subtle },
    DiagnosticHint             = { fg = c.sea },
    DiagnosticOk               = { fg = c.green },
    DiagnosticUnderlineError   = { sp = c.red, undercurl = true },
    DiagnosticUnderlineWarn    = { sp = c.olive, undercurl = true },
    DiagnosticUnderlineInfo    = { sp = c.subtle, undercurl = true },
    DiagnosticUnderlineHint    = { sp = c.sea, undercurl = true },
    DiagnosticVirtualTextError = { fg = c.red, italic = true },
    DiagnosticVirtualTextWarn  = { fg = c.olive, italic = true },
    DiagnosticVirtualTextInfo  = { fg = c.muted, italic = true },
    DiagnosticVirtualTextHint  = { fg = c.muted, italic = true },
    LspReferenceText           = { bg = c.sel },
    LspReferenceRead           = { bg = c.sel },
    LspReferenceWrite          = { bg = c.sel },
    LspInlayHint               = { fg = c.muted, italic = true },

    -- Diff / git
    DiffAdd          = { fg = c.green, bg = "#0f2410" },
    DiffDelete       = { fg = c.red, bg = "#2a0d0b" },
    DiffChange       = { bg = "#1f1f10" },
    DiffText         = { fg = c.olive, bg = "#33331a", bold = true },
    Added            = { fg = c.green },
    Removed          = { fg = c.red },
    Changed          = { fg = c.olive },
    GitSignsAdd      = { fg = c.green },
    GitSignsChange   = { fg = c.olive },
    GitSignsDelete   = { fg = c.red },

    -- Telescope
    TelescopeNormal         = { fg = c.fg, bg = c.float },
    TelescopeBorder         = { fg = c.border, bg = c.float },
    TelescopeTitle          = { fg = c.green, bold = true },
    TelescopePromptPrefix   = { fg = c.green },
    TelescopeSelection      = { fg = c.green, bg = c.sel, bold = true },
    TelescopeSelectionCaret = { fg = c.green, bg = c.sel },
    TelescopeMatching       = { fg = c.green_hi, bold = true },

    -- Neo-tree
    NeoTreeNormal          = { fg = c.fg, bg = c.none },
    NeoTreeNormalNC        = { fg = c.fg, bg = c.none },
    NeoTreeDirectoryName   = { fg = c.fg },
    NeoTreeDirectoryIcon   = { fg = c.grey },
    NeoTreeRootName        = { fg = c.green, bold = true },
    NeoTreeFileNameOpened  = { fg = c.green },
    NeoTreeDotfile         = { fg = c.muted },
    NeoTreeGitAdded        = { fg = c.green },
    NeoTreeGitModified     = { fg = c.olive },
    NeoTreeGitDeleted      = { fg = c.red },
    NeoTreeGitUntracked    = { fg = c.sea },
    NeoTreeIndentMarker    = { fg = c.border },
    NeoTreeWinSeparator    = { fg = c.border },

    -- Which-key
    WhichKey          = { fg = c.green },
    WhichKeyGroup     = { fg = c.sea },
    WhichKeyDesc      = { fg = c.fg },
    WhichKeySeparator = { fg = c.muted },
    WhichKeyNormal    = { bg = c.float },

    -- blink.cmp
    BlinkCmpMenu           = { link = "Pmenu" },
    BlinkCmpMenuBorder     = { link = "FloatBorder" },
    BlinkCmpMenuSelection  = { link = "PmenuSel" },
    BlinkCmpLabelMatch     = { fg = c.green_hi, bold = true },
    BlinkCmpKind           = { fg = c.subtle },
    BlinkCmpDoc            = { link = "NormalFloat" },
    BlinkCmpDocBorder      = { link = "FloatBorder" },

    -- Lazy / Mason
    LazyH1           = { fg = c.black, bg = c.green, bold = true },
    LazyButtonActive = { fg = c.black, bg = c.green },
    MasonHeader      = { fg = c.black, bg = c.green, bold = true },
    MasonHighlight   = { fg = c.green },
    MasonHighlightBlockBold = { fg = c.black, bg = c.green, bold = true },
}

for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
end

-- :terminal colors, matching WezTerm's ANSI palette
local term = {
    c.surface, c.red, c.green, c.olive, "#8c8c8c", "#a6a6a6", c.sea, "#c8c8c8",
    "#4d4d4d", c.red_hi, c.green_hi, "#d7d76a", "#b3b3b3", "#cccccc", "#74d6a4", c.white,
}
for i, color in ipairs(term) do
    vim.g["terminal_color_" .. (i - 1)] = color
end
