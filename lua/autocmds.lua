require "nvchad.autocmds"

-- Define git statusline highlight groups
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "St_GitAdd", { fg = "#98c379" })
    vim.api.nvim_set_hl(0, "St_GitMod", { fg = "#e5c07b" })
    vim.api.nvim_set_hl(0, "St_GitDel", { fg = "#e06c75" })
    vim.api.nvim_set_hl(0, "St_DiffAdd", { fg = "#98c379" })
    vim.api.nvim_set_hl(0, "St_DiffMod", { fg = "#e5c07b" })
    vim.api.nvim_set_hl(0, "St_DiffDel", { fg = "#e06c75" })
  end,
})

-- Set highlights on startup
vim.api.nvim_set_hl(0, "St_GitAdd", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "St_GitMod", { fg = "#e5c07b" })
vim.api.nvim_set_hl(0, "St_GitDel", { fg = "#e06c75" })
vim.api.nvim_set_hl(0, "St_DiffAdd", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "St_DiffMod", { fg = "#e5c07b" })
vim.api.nvim_set_hl(0, "St_DiffDel", { fg = "#e06c75" })

-- Refresh statusline on git-related events
vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "BufEnter" }, {
  callback = function()
    vim.cmd("redrawstatus")
  end,
})
