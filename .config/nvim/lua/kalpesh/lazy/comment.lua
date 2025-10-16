return {
	"numToStr/Comment.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		local comment = require("Comment")

		comment.setup({
			pre_hook = function(ctx)
				local U = require("Comment.utils")
				local ts_utils = require("ts_context_commentstring.utils")
				local ts_internal = require("ts_context_commentstring.internal")

				-- Determine where to calculate commentstring
				local location = nil
				if ctx.ctype == U.ctype.block then
					location = ts_utils.get_cursor_location()
				elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
					location = ts_utils.get_visual_start_location()
				end

				-- Always use line comment style for Go
				if vim.bo.filetype == "go" then
					return "// %s"
				end

				-- Default for other filetypes
				return ts_internal.calculate_commentstring({
					key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
					location = location,
				})
			end,
		})
	end,
}
