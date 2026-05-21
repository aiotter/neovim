local M = {}

local function current_file_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    vim.notify("No file name for current buffer", vim.log.levels.WARN)
    return nil
  end

  if name:match("^[%w+.-]+://") then
    return name
  end

  return vim.fn.fnamemodify(name, ":p")
end

local function send_to_clipboard(content)
  local ok, err = pcall(vim.fn.setreg, "+", content)
  if not ok then
    vim.notify(("Failed to copy to clipboard: %s"):format(err), vim.log.levels.ERROR)
  end
end

local function format_reference(path, start_line, end_line)
  if start_line == end_line then
    return ("%s:%d"):format(path, start_line)
  end

  return ("%s#L%d-L%d"):format(path, start_line, end_line)
end

local function copy_line_references(start_line, end_line)
  local path = current_file_path()
  if path == nil then return end

  send_to_clipboard(format_reference(path, start_line, end_line))
end

function M.copy_to_clipboard()
  local line = vim.fn.line(".")
  copy_line_references(line, line)
end

function M.copy_selection_to_clipboard()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  copy_line_references(start_line, end_line)
end

return M
