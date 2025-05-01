-- ~/.config/nvim/lua/plugins/copilots.lua
return {{
    "github/copilot.vim",
    event = {"InsertEnter", "VeryLazy"},
    config = function()
        -- Keep commented unless using nvim-cmp or similar
        -- vim.g.copilot_no_tab_map = true
        -- vim.g.copilot_assume_mapped = true

        -- Example: Disable copilot for certain filetypes
        -- vim.g.copilot_filetypes = {
        --   ["*"] = true, -- enable for all by default
        --   gitcommit = false,
        --   markdown = false,
        -- }

        vim.g.copilot_enabled = 1 -- Enable by default
        print("GitHub Copilot configured via lazy.nvim!") -- Optional confirmation
    end
}}
