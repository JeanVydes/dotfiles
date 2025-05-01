-- ~/.config/nvim/lua/plugins/rust.lua
return { -- LSP Configuration base
{"neovim/nvim-lspconfig"}, -- Utility library required by rust-tools and others
{
    "nvim-lua/plenary.nvim",
    lazy = true
}, -- Can be lazy loaded
-- Rust specific tooling and enhancements
{
    "simrat39/rust-tools.nvim",
    dependencies = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"},
    -- Configuration is passed directly to the setup function via 'opts'
    opts = function()
        local border_opts = {{"╭", "FloatBorder"}, {"─", "FloatBorder"}, {"╮", "FloatBorder"},
                             {"│", "FloatBorder"}, {"╯", "FloatBorder"}, {"─", "FloatBorder"},
                             {"╰", "FloatBorder"}, {"│", "FloatBorder"}}
        return {
            tools = {
                executor = require("rust-tools.executors").termopen,
                reload_workspace_from_cargo_toml = true,
                inlay_hints = {
                    auto = true,
                    only_current_line = false,
                    show_parameter_hints = true,
                    parameter_hints_prefix = "<- ",
                    other_hints_prefix = "=> ",
                    max_len_align = false,
                    max_len_align_padding = 1,
                    right_align = false,
                    right_align_padding = 7,
                    highlight = "Comment"
                },
                hover_actions = {
                    border = border_opts,
                    auto_focus = true
                }
            },
            server = {
                -- Use the on_attach defined in init.lua for base LSP mappings
            }
        }
    end,
    config = function(_, opts)
        -- Setup rust-tools using the options generated/returned above
        require("rust-tools").setup(opts)
        print("rust-tools configured via lazy.nvim!") -- Optional confirmation
    end
}}
