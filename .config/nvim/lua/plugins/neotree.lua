-- ~/.config/nvim/lua/plugins/neotree.lua

-- Require the utility module we created
local project_utils = require("utils.project")

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x", -- Recommended: pin to major version branch
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- For file icons (ensure Nerd Font is installed and set in terminal)
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree", -- Command to lazy-load the plugin
        keys = {
            -- Toggle NeoTree (basic toggle)
            {
                "<leader>n",
                function()
                    require("neo-tree.command").execute({ toggle = true })
                end,
                desc = "Explorer NeoTree (Toggle)",
            },
             -- Focus NeoTree window
             {
                "<leader>nf",
                function()
                    require("neo-tree.command").execute({ focus = true })
                end,
                desc = "Explorer NeoTree (Focus)",
            },
            -- Toggle NeoTree, attempting to start at Project Root (using our util function)
            {
                "<leader>fe",
                function()
                    -- Correctly calls the function via the required module
                    require("neo-tree.command").execute({ toggle = true, dir = project_utils.find_project_root() })
                end,
                desc = "Explorer NeoTree (Root Dir)",
            },
            -- Toggle NeoTree, forcing Current Working Directory
            {
                "<leader>fE",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            -- Remaps for convenience
            { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
            { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
            -- Git Status source toggle
            {
                "<leader>ge",
                function()
                    require("neo-tree.command").execute({ source = "git_status", toggle = true })
                end,
                desc = "Git Explorer",
            },
            -- Buffers source toggle
            {
                "<leader>be",
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end,
                desc = "Buffer Explorer",
            },
        },
        -- Close NeoTree when Neovim quits (optional)
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        -- Optional: Attempt to open NeoTree if Neovim starts in a directory
        init = function()
            if vim.fn.argc() == 1 then
                local stat = vim.uv.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                     vim.api.nvim_create_autocmd("BufEnter", {
                        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
                        desc = "Open Neo-tree automatically when started in a directory",
                        once = true,
                        callback = function()
                            require("neo-tree").open(vim.fn.argv(0))
                        end,
                    })
                end
            end
        end,
        -- Plugin options
        opts = {
            sources = { "filesystem", "buffers", "git_status" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = { enabled = true, leave_dirs_open = false },
                use_libuv_file_watcher = true,
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_by_name = { -- Add filenames/patterns to hide
                        -- ".git",
                        -- ".DS_Store",
                        -- "thumbs.db",
                    },
                    never_show = {},
                },
            },
            window = {
                position = "left",
                width = 30,
                mappings = {
                    ["<cr>"] = "open",
                    ["l"] = "open",
                    ["h"] = "close_node",
                    ["<space>"] = "none",
                    ["P"] = { "toggle_preview", config = { use_float = false } },
                    ["Y"] = { -- Yank path
                        function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.fn.setreg("+", path, "c")
                            vim.notify("Copied path: " .. path)
                        end,
                        desc = "Copy Path to Clipboard",
                    },
                    ["O"] = { -- Open with system default
                        function(state)
                            pcall(function()
                                require("lazy.util").open(state.tree:get_node().path, { system = true })
                            end)
                        end,
                        desc = "Open with System Application",
                    },
                    ["a"] = { "add", config = { show_path = "relative" } },
                    ["d"] = "delete",
                    ["r"] = "rename",
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true,
                    expander_collapsed = "", -- Nerd Font icons
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                icon = {
                    folder_closed = "", -- Nerd Font icons
                    folder_open = "",
                    folder_empty = "󰜌",
                     default = "", -- Default icon
                },
                git_status = {
                    symbols = { -- Nerd Font icons
                        added = "✚",
                        modified = "",
                        deleted = "✖",
                        renamed = "➜",
                        staged = "✓",
                        unmerged = "",
                        untracked = "?",
                        ignored = "◌",
                    },
                },
            },
             -- Intentionally empty event_handlers, as the LSP integration part was removed
             event_handlers = {},
        },
        config = function(_, opts)
            -- Setup neo-tree with the defined options
            require("neo-tree").setup(opts)

            -- Optional: Refresh git_status source after lazygit closes
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
        end,
    },
}