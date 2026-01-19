-- ===============================================================
-- Neo-tree is a file explorer plugin for Neovim written in Lua.
-- ===============================================================
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    opts = {
        filesystem = {
            filtered_items = {
                visible = true, -- show filtered items (dotfiles/hidden)
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_hidden = false,
            },
        },
    },
    lazy = false, -- neo-tree will lazily load itself
  }
}