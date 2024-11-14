local utils = require 'utils'
local wezterm = require 'wezterm'

local mux = wezterm.mux

local session = {}

local session_dir = wezterm.home_dir .. "/.local/state/wezterm/session"

---@class (exact) session.LocalProcessInfo
---@field pid string
---@field ppid string
---@field name string
---@field status wezterm.LocalProcessInfoStatus
---@field argv string[]
---@field executable string
---@field cwd string
---@field children session.LocalProcessInfo[]

---@class (exact) session.Pane
---@field index number
---@field is_active boolean
---@field is_zoomed boolean
---@field left number
---@field top number
---@field width number
---@field height number
---@field pixel_width number
---@field pixel_height number
--------------
---@field current_working_dir? string
---@field cursor_position wezterm.StableCursorPosition
---@field domain_name? string
---@field foreground_process_info? wezterm.LocalProcessInfo
---@field foreground_process_name? string
---@field title string
---@field tty_name string
---@field pane_id number

---@class (exact) session.Tab
---@field index number
---@field is_active boolean
---@field title string
---@field panes session.Pane[]
---@field tab_id number

---@class session.Window
---@field workspace string
---@field title string
---@field tabs session.Tab[]

---
---@param window wezterm.MuxWindow
---@return table
local function serde_window(window)
    ---comment
    ---@param process_info? wezterm.LocalProcessInfo
    local function serde_process_info(process_info)
        if not process_info then return nil end
        process_info.children = utils.map(serde_process_info, utils.tbl_values(process_info.children))
        return process_info
    end

    window:get_workspace()
    ---@type session.Window
    local workspace_data = {
        workspace = window:get_workspace(),
        title = window:get_title(),
        tabs = utils.map(function(tab_info)
            ---@cast tab_info wezterm.TabWthInfo
            local tab = tab_info.tab
            ---@type session.Tab
            return {
                index = tab_info.index,
                is_active = tab_info.is_active,

                tab_id = tab:tab_id(),
                title = tab:get_title(),
                panes = utils.map(function(pane_info)
                    ---@cast pane_info wezterm.PaneWithInfo
                    local pane = pane_info.pane
                    wezterm.log_info(pane:get_foreground_process_info())
                    ---@type session.Pane
                    return {
                        index = pane_info.index,
                        is_active = pane_info.is_active,
                        is_zoomed = pane_info.is_zoomed,
                        left = pane_info.left,
                        top = pane_info.top,
                        width = pane_info.width,
                        height = pane_info.height,
                        pixel_width = pane_info.pixel_width,
                        pixel_height = pane_info.pixel_height,

                        current_working_dir = tostring(pane:get_current_working_dir()),
                        cursor_position = pane:get_cursor_position(),
                        domain_name = pane:get_domain_name(),
                        foreground_process_info = serde_process_info(pane:get_foreground_process_info()),
                        foreground_process_name = pane:get_foreground_process_name(),

                        title = pane:get_title(),
                        tty_name = pane:get_tty_name(),
                        pane_id = pane:pane_id(),
                    }
                end, tab:panes_with_info()),
            }
        end, window:tabs_with_info()),
    }

    return workspace_data
end

---comment
---@param window_data session.Window
---@return wezterm.MuxWindow|nil
local function deserde_window(window_data)
    if #window_data.tabs < 1 and #window_data.tabs[1].panes < 1 then
        wezterm.log_error("session must contain at least one pane and tab ", window_data)
        return
    end
    local tab_data = window_data.tabs[1]
    local pane_data = tab_data.panes[1]
    local tab, pane, window = wezterm.mux.spawn_window({
        workspace = window_data.workspace,
        cwd = pane_data.foreground_process_info.cwd,
        domain = { DomainName = pane_data.domain_name },
        -- args = { pane_data.foreground_process_info.executable },
    })
    window:set_title(window_data.title)
    window:set_workspace(window_data.workspace)

    ---@param tab_data session.Tab
    ---@param tab? wezterm.MuxTab
    ---@param pane? wezterm.Pane
    local function deserde_tab(tab_data, tab, pane)
        if not tab then
            tab, pane = window:spawn_tab({})
        end
        ---@cast tab -nil
        if not pane then tab:active_pane():split({
            direction = "Left",
        }) end
        tab:set_title(tab_data.title)
    end

    deserde_tab(window_data.tabs[1], tab, pane)

    return window
end

---
---@param window wezterm.Window
function session.save(window)
    local data = serde_window(window:mux_window())
    local filename = string.format("%s/%s.session", session_dir, window:active_workspace())
    wezterm.log_info(data)
    utils.save_json_file(data, filename)
end

function session.load(workspace_name)
    workspace_name = workspace_name or "default"
    local filename = string.format("%s/%s.session", session_dir, workspace_name)
    local data = utils.load_json_file(filename)
    if not data then return end
    deserde_window(data)
end

return session
