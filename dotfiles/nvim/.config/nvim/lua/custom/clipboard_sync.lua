-- Clipboard two-way sync (async, no blocking)
local M = {}

local function system_clipboard_cmd()
  if vim.fn.executable 'wl-paste' == 1 then
    return { 'wl-paste', '--no-newline' } -- Wayland
  elseif vim.fn.executable 'xclip' == 1 then
    return { 'xclip', '-selection', 'clipboard', '-out' } -- X11 xclip
  elseif vim.fn.executable 'xsel' == 1 then
    return { 'xsel', '--clipboard', '--output' } -- X11 xsel
  else
    return nil
  end
end

-- Read system clipboard asynchronously and call cb(text)
local function read_system_clipboard_async(cb)
  local cmd = system_clipboard_cmd()
  if not cmd then
    return nil, 'no clipboard helper found (wl-paste/xclip/xsel)'
  end

  -- Use jobstart with stdout_buffered to get whole data at once
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      -- data is an array of lines (without trailing newlines)
      if not data or vim.tbl_isempty(data) then
        if cb then
          cb ''
        end
        return
      end
      -- reassemble exactly (join with '\n')
      local text = table.concat(data, '\n')
      if cb then
        cb(text)
      end
    end,
    on_stderr = function(_, err)
      if err and not vim.tbl_isempty(err) then
        vim.schedule(function()
          -- vim.notify('Clipboard read stderr: ' .. table.concat(err, '\n'), vim.log.levels.DEBUG)
        end)
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        -- caller may ignore; log debug
        vim.schedule(function()
          -- vim.notify('Clipboard read exited with code ' .. tostring(code), vim.log.levels.DEBUG)
        end)
      end
    end,
  })
  return true
end

-- Set registers safely (unnamed " and +). We preserve simple behavior:
-- if content ends with newline we treat it as linewise for convenience.
local function set_clipboard_registers(text)
  if text == nil or text == '' then
    return
  end

  -- Determine whether the text ends with newline -> treat as linewise
  local is_linewise = (text:sub(-1) == '\n')

  -- If linewise, set as list of lines (so paste with p behaves as linewise)
  if is_linewise then
    -- split keeps empty trailing item; we want each original line without final empty trailing after split
    local lines = vim.split(text, '\n', { plain = true })
    -- If text ended with newline, split produces an extra empty final element; remove it
    if lines[#lines] == '' then
      table.remove(lines, #lines)
    end

    -- schedule to run in main loop
    vim.schedule(function()
      vim.fn.setreg('"', lines, 'l') -- unnamed register as linewise
      vim.fn.setreg('+', lines, 'l') -- system clipboard register
    end)
  else
    -- characterwise/string content
    vim.schedule(function()
      vim.fn.setreg('"', text, 'c') -- unnamed register charwise
      vim.fn.setreg('+', text, 'c') -- plus register charwise
    end)
  end
end

-- Public: sync system -> neovim registers once (async)
function M.sync_system_to_nvim()
  local ok, err = read_system_clipboard_async(function(text)
    if not text or text == '' then
      -- nothing to do
      return
    end
    set_clipboard_registers(text)
  end)
  if not ok then
    vim.notify('No system clipboard helper found: ' .. tostring(err), vim.log.levels.DEBUG)
  end
end

function M.setup(opts)
  opts = opts or {}
  -- Auto-sync hooks: VimEnter and FocusGained
  vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained' }, {
    callback = function()
      -- Fire-and-forget async sync
      M.sync_system_to_nvim()
    end,
  })

  -- Optional: sync on CursorHold (when idle) if you'd like polling while focused
  -- Uncomment if you want periodic checks while editing (use sparingly)
  -- vim.api.nvim_create_autocmd('CursorHold', {
  --   callback = function() M.sync_system_to_nvim() end,
  -- })

  -- Optional helper mapping to force sync manually:
  vim.keymap.set('n', '<Leader>cs', function()
    M.sync_system_to_nvim()
    vim.notify('Requested system -> nvim clipboard sync', vim.log.levels.INFO)
  end, { desc = 'Sync system clipboard to Neovim' })
end

return M
