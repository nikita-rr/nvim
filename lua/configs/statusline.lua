local M = {}

-- Cache for git status to avoid frequent shell calls
local git_status_cache = {
  data = nil,
  last_update = 0,
  update_interval = 2000, -- ms
}

-- Get git file status counts (new, modified, deleted)
local function get_git_file_status()
  local now = vim.loop.now()
  if git_status_cache.data and (now - git_status_cache.last_update) < git_status_cache.update_interval then
    return git_status_cache.data
  end

  local result = { added = 0, modified = 0, deleted = 0 }

  -- Check if we're in a git repo
  local git_dir = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
  if git_dir == "" then
    git_status_cache.data = result
    git_status_cache.last_update = now
    return result
  end

  -- Get git status --porcelain output
  local handle = io.popen("git status --porcelain 2>/dev/null")
  if not handle then
    return result
  end

  local output = handle:read("*a")
  handle:close()

  for line in output:gmatch("[^\r\n]+") do
    local status = line:sub(1, 2)
    -- New/Added files (A, ??)
    if status:match("^A") or status == "??" then
      result.added = result.added + 1
    -- Deleted files (D)
    elseif status:match("D") then
      result.deleted = result.deleted + 1
    -- Modified files (M, R, C, U)
    elseif status:match("[MRCU]") or status:match("^%s*M") then
      result.modified = result.modified + 1
    end
  end

  git_status_cache.data = result
  git_status_cache.last_update = now
  return result
end

-- Git file status module for statusline
function M.git_file_status()
  local status = get_git_file_status()
  local result = ""

  if status.added > 0 then
    result = result .. "%#St_GitAdd# ● " .. status.added
  end
  if status.modified > 0 then
    result = result .. "%#St_GitMod#  ● " .. status.modified
  end
  if status.deleted > 0 then
    result = result .. "%#St_GitDel#  ● " .. status.deleted
  end

  if result ~= "" then
    result = result .. " "
  end

  return result
end

-- Git diff stats (lines added/deleted) for current file
function M.git_diff_stats()
  local signs = vim.b.gitsigns_status_dict
  if not signs then
    return ""
  end

  local added = signs.added or 0
  local changed = signs.changed or 0
  local removed = signs.removed or 0
  local result = ""

  if added > 0 then
    result = result .. "%#St_DiffAdd#+" .. added
  end
  if changed > 0 then
    result = result .. "%#St_DiffMod#~" .. changed
  end
  if removed > 0 then
    result = result .. "%#St_DiffDel#-" .. removed
  end

  if result ~= "" then
    result = " " .. result .. " "
  end

  return result
end

return M
