return {
	"sphamba/smear-cursor.nvim",
	event = "VeryLazy",
	config = function()
		require("smear_cursor").setup({
			-- Smear cursor color. Defaults to Cursor GUI color if not set
			cursor_color = "#53676d",
			-- Background color. Defaults to Normal GUI background color if not set
			normal_bg = "#fbf3db",
			-- Smear cursor when switching buffers or windows
			smear_between_buffers = true,
			-- Smear cursor when moving within line or to neighbor lines
			smear_between_neighbor_lines = true,
			-- Set to `true` if GUI colors are not displaying properly
			legacy_computing_symbols_support = false,
		})
		-- 启用插件
		require("smear_cursor").enabled = true
	end,
}