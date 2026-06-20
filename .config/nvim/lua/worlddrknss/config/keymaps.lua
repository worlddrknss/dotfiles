local function telescope_action(action)
	return function()
		local ok, builtin = pcall(require, 'telescope.builtin')
		if not ok then
			vim.notify('telescope.nvim is not available', vim.log.levels.WARN)
			return
		end

		builtin[action]()
	end
end

vim.keymap.set('n', '<leader>ff', telescope_action('find_files'), { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope_action('live_grep'), { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope_action('buffers'), { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope_action('help_tags'), { desc = 'Telescope help tags' })

vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>')