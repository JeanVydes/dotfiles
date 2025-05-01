-- ~/.config/nvim/lua/utils/project.lua

-- Define the module table that we will export
local M = {}

-- Localize Neovim API functions for clarity and potentially slight performance
local fn = vim.fn
local api = vim.api
local fs = vim.fs -- Use vim.fs for filesystem operations

-- Function to find the root of the current project (based on .git)
function M.find_project_root()
    -- Get the directory of the current buffer, or CWD if no buffer name
    local current_file = api.nvim_buf_get_name(0)
    local start_path = (current_file and current_file ~= "") and fn.fnamemodify(current_file, ":h") or fn.getcwd()

    -- Search upwards from the start_path for a .git directory
    -- Stop searching when we reach the HOME directory
    local git_root_marker = fs.find(".git", { upward = true, stop = vim.env.HOME, path = start_path, type = "directory" })

    if git_root_marker and #git_root_marker > 0 then
        -- vim.fs.find returns a list (usually with one element if found)
        -- Get the parent directory of the found '.git' marker
        return fn.fnamemodify(git_root_marker[1], ":h")
    end

    -- If no .git directory is found, fall back to the current working directory
    return fn.getcwd()
end

-- IMPORTANT: Return the module table at the end of the file
return M