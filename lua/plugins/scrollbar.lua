return {
	"petertriho/nvim-scrollbar",
	dependencies = {
		"kevinhwang91/nvim-hlslens",
	},
	config = function()
		local group = vim.api.nvim_create_augroup("scrollbar_set_git_colors", {})
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*",
			callback = function()
				-- Use colorscheme defaults; remove hardcoded git colors
			end,
			group = group,
		})
		require("scrollbar.handlers.search").setup({})
		require("scrollbar.handlers.gitsigns").setup()
		require("scrollbar").setup({
			show = true,
			handle = {
				text = " ",
				-- color follows theme
				hide_if_all_visible = true,
			},
			marks = {
				Search = { color = "yellow" },
				Misc = { color = "purple" },
			},
			handlers = {
				cursor = false,
				diagnostic = true,
				gitsigns = true,
				handle = true,
				search = true,
			},
		})
	end,
}
