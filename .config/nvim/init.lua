-- ~/.config/nvim/init.lua

-- Load lazy.nvim plugin manager configuration first
require("config.lazy")

-- Lua module locals
local vim = vim
local opt = vim.opt
local g = vim.g

-- -----------------------------------------------------------------------------
-- Options
-- -----------------------------------------------------------------------------
local indent = 4

-- General Editor Settings
g.mapleader = " " -- Set leader key to space
opt.termguicolors = true -- Enable true color support
opt.mouse = "a" -- Enable mouse support in all modes
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.showcmd = true -- Show command in the last line
opt.autochdir = false -- IMPORTANT: Set to false if using neo-tree's root finding, true otherwise

-- Indentation Settings
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = indent -- Size of an indent
opt.tabstop = indent -- Number of spaces a <Tab> counts for
opt.softtabstop = indent -- Number of spaces <Tab> counts for in editing operations
opt.autoindent = true -- Copy indent from current line when starting a new line
opt.smartindent = true -- Be smart about indentation

-- Search Settings
opt.hlsearch = true -- Highlight search results
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true -- Override ignorecase if search pattern has uppercase letters
opt.wildmenu = true -- Enable Vim's command-line completion menu
opt.wildignore:append({ "*/node_modules/*", "*/.git/*", "*/vendor/*" }) -- Files to ignore for completion

-- UI Settings
opt.number = true -- Show line numbers
opt.list = true -- Show invisible characters (tabs, trailing whitespace)
-- opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣' } -- Optional: Customize list characters
opt.signcolumn = "yes" -- Always show the sign column

-- Performance Settings
opt.redrawtime = 1500
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.updatetime = 250
opt.completeopt = { "menu", "menuone", "noselect" } -- Autocomplete options
opt.shortmess:append({ c = true }) -- Don't show redundant messages from completion

-- Enable syntax highlighting
vim.cmd("syntax enable")

-- -----------------------------------------------------------------------------
-- Keymaps (General - Plugin keymaps should be in their respective plugin files)
-- -----------------------------------------------------------------------------
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Basic Mappings
map("n", "<leader>z", ":undo<CR>", { desc = "Undo" })
map("n", "<leader>w", ":w<CR>", { desc = "Write (Save)" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>qa", ":qa<CR>", { desc = "Quit All" })
map("n", "<leader>}", ":bnext<CR>", { desc = "Next Buffer" })      -- Using standard :bnext
map("n", "<leader>{", ":bprevious<CR>", { desc = "Previous Buffer" }) -- Using standard :bprevious

-- Terminal Mappings
map("n", "<leader>t", ":terminal<CR>", { desc = "Open Terminal" })
map("n", "<leader>th", ":split | terminal<CR>", { desc = "Open Terminal (Horizontal)" })
map("n", "<leader>tv", ":vsplit | terminal<CR>", { desc = "Open Terminal (Vertical)" })

-- -----------------------------------------------------------------------------
-- LSP (Base Configuration - rust-tools config is now in its plugin file)
-- -----------------------------------------------------------------------------
local lspconfig = require("lspconfig")

-- Helper function to check if a command exists
local function is_executable(command)
    return vim.fn.executable(command) == 1
end

-- Default LSP attach function (shared keymaps for LSP features)
local on_attach = function(client, bufnr)
    -- Standard LSP keymaps
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "LSP Go To Declaration" }))
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "LSP Go To Definition" }))
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "LSP Hover" }))
    map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, { desc = "LSP Go To Implementation" }))
    map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", bufopts, { desc = "LSP Signature Help" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "LSP Rename" }))
    map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "LSP Code Action" }))
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "LSP Go To References" }))

    -- Enable completion triggered by <c-x><c-o> (if not using a completion plugin like nvim-cmp)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

-- Setup rust-analyzer via lspconfig (if available)
-- rust-tools will attach to this server setup
if is_executable("rust-analyzer") then
    lspconfig.rust_analyzer.setup({
        on_attach = on_attach, -- Use the common on_attach function
        -- Settings passed directly to rust-analyzer
        settings = {
            ["rust-analyzer"] = {
                -- Add any specific rust-analyzer settings here if needed
                -- Example:
                -- checkOnSave = { command = "clippy" }
            },
        },
    })
end

-- NOTE: rust-tools setup is now handled by lazy.nvim in lua/plugins/rust.lua


-- -----------------------------------------------------------------------------
-- Diagnostics Configuration (Error/Warning highlighting)
-- -----------------------------------------------------------------------------
local signs = { Error = "", Warn = "", Hint = "", Info = "" } -- Nerd Font Icons
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
    virtual_text = false, -- Disable virtual text diagnostics (inline errors)
    signs = true, -- Enable signs in the sign column
    underline = true, -- Enable underlining diagnostics
    update_in_insert = false, -- Don't update diagnostics in insert mode (performance)
    severity_sort = true, -- Sort diagnostics by severity
    float = { -- Configure diagnostic floating windows
        border = "rounded",
        source = "always", -- Show the source of the diagnostic (e.g., 'rustc')
        header = "",
        prefix = "",
    },
})

-- Show diagnostics automatically in floating window when cursor hovers
vim.cmd([[ autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false }) ]])

-- Confirmation message (optional)
print("init.lua loaded successfully!")