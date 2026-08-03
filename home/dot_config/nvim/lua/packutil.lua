local M = {}

local errors = {}
local later_callbacks = {}
local finish_is_scheduled = false

local function report_errors()
    if #errors == 0 then
        return
    end

    local error_lines = table.concat(errors, "\n\n")
    errors = {}
    vim.notify("There were errors during two-stage execution:\n\n" .. error_lines, vim.log.levels.ERROR)
end

local function finish()
    local timer = assert(vim.uv.new_timer())

    local function step()
        vim.schedule(function()
            local callback = table.remove(later_callbacks, 1)
            if callback == nil then
                finish_is_scheduled = false
                later_callbacks = {}
                timer:stop()
                timer:close()
                report_errors()
                return
            end

            M.now(callback)
            timer:start(1, 0, step)
        end)
    end

    timer:start(1, 0, step)
end

local function schedule_finish()
    if finish_is_scheduled then
        return
    end

    finish_is_scheduled = true
    vim.schedule(finish)
end

function M.now(callback)
    local ok, err = pcall(callback)
    if not ok then
        table.insert(errors, err)
    end
    schedule_finish()
end

function M.now_require(module)
    M.now(function()
        require(module)
    end)
end

function M.now_setup(module, opts)
    M.now(function()
        require(module).setup(opts)
    end)
end

function M.later(callback)
    table.insert(later_callbacks, callback)
    schedule_finish()
end

function M.later_require(module)
    M.later(function()
        require(module)
    end)
end

function M.later_setup(module, opts)
    M.later(function()
        require(module).setup(opts)
    end)
end

return M
