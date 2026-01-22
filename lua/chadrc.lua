-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "onedark",

	hl_add = {
		-- Git file status colors (for file counts)
		St_GitAdd = { fg = "#98c379" },  -- Green for new files
		St_GitMod = { fg = "#e5c07b" },  -- Orange for modified files
		St_GitDel = { fg = "#e06c75" },  -- Red for deleted files
		-- Git diff stats colors (for line changes)
		St_DiffAdd = { fg = "#98c379" }, -- Green for added lines
		St_DiffMod = { fg = "#e5c07b" }, -- Orange for changed lines
		St_DiffDel = { fg = "#e06c75" }, -- Red for removed lines
	},
}

M.ui = {
	statusline = {
		theme = "default",
		order = { "mode", "file", "git", "git_file_status", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cursor", "cwd" },
		modules = {
			git_file_status = function()
				return require("configs.statusline").git_file_status()
			end,
		},
	},
}

return M
