-- ~/.config/nvim/lua/config/lazy.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
-- It will automatically load all files under lua/plugins/
require("lazy").setup("plugins", {
  -- Configure lazy.nvim options here if needed
  checker = {
    enabled = true, -- Check for plugin updates automatically
    notify = false, -- Don't automatically notify, use :Lazy check
  },
  change_detection = {
    notify = false, -- Don't notify about detected changes, rely on :Lazy sync
  },
  -- You can add other lazy.nvim config options here
  -- performance = { ... }
  -- ui = { ... }
})