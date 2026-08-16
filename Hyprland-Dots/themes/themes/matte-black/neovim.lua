local M = {}

-- Read current theme from ~/.config/nvim/current_theme.txt
local function read_theme()
  local file = vim.fn.stdpath("config") .. "/current_theme.txt"
  if vim.fn.filereadable(file) == 1 then
    local content = vim.fn.readfile(file)
    if content and content[1] then
      return tostring(content[1]):gsub("%s+", "")
    end
  end
  return nil
end

function M.apply()
  local theme = read_theme()
  if not theme or theme == "" then
    vim.notify("No theme found in current_theme.txt", vim.log.levels.WARN)
    return
  end

  local ok, _ = pcall(vim.cmd, "colorscheme " .. theme)
  if not ok then
    vim.notify("Failed to load colorscheme: " .. theme, vim.log.levels.ERROR)
  end
end

return M
