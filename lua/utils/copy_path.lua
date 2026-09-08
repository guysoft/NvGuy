-- Copy the current buffer's file path to the system clipboard.
--
-- Uses OSC 52 so it works uniformly across:
--   * macOS + local tmux
--   * Linux (native)
--   * macOS -> SSH -> Linux + tmux
--
-- OSC 52 asks the terminal (iTerm2 / Ghostty / kitty / Terminal.app / WezTerm
-- / Alacritty ...) to set the system clipboard. When $TMUX is set we wrap the
-- sequence in a `\ePtmux;...\e\\` DCS passthrough so tmux forwards it even
-- when `set-clipboard` / `allow-passthrough` are off. We also set the local
-- `+ * "` registers so `p` inside Neovim pastes the same value.

local M = {}

local function osc52(text)
  local b64 = vim.base64.encode(text)
  local seq = "\027]52;c;" .. b64 .. "\027\\"
  if vim.env.TMUX then
    seq = "\027Ptmux;\027\027]52;c;" .. b64 .. "\027\027\\\027\\"
  end
  io.stdout:write(seq)
end

-- Path of the git repo containing `abs`, or nil if not in a repo.
local function git_root(abs)
  local dir = vim.fn.fnamemodify(abs, ":h")
  local found = vim.fs.find({ ".git" }, { path = dir, upward = true })[1]
  if not found then
    return nil
  end
  return vim.fn.fnamemodify(found, ":h")
end

--- Copy the current buffer's path to the clipboard.
--- @param mode string "full" for absolute path, anything else for repo-relative
function M.copy(mode)
  local abs = vim.fn.expand("%:p")
  if abs == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  local path
  if mode == "full" then
    path = abs
  else
    local root = git_root(abs)
    if root then
      path = abs:sub(#root + 2) -- strip root + leading "/"
    else
      path = vim.fn.fnamemodify(abs, ":.")
      vim.notify("Not in a git repo — copied path relative to cwd", vim.log.levels.INFO)
    end
  end

  vim.fn.setreg("+", path)
  vim.fn.setreg("*", path)
  vim.fn.setreg('"', path)
  osc52(path)
  vim.notify("Copied: " .. path)
end

return M
