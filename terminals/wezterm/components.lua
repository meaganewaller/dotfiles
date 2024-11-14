local wezterm = require("wezterm")

return function(config)
    wezterm.on("update-right-status", function(window, _)
        local hostname = " 🖥️" .. wezterm.hostname() .. "  "
        local key_table = window:active_key_table()
        local content = ""
        if key_table then content = content .. "⌨️  " end

        local components = {
            {
                { Foreground = { Color = "#e4e4e4" } },
                { Background = { Color = "#d70000" } },
                { Text = hostname },
            },
        }
        for _, component in ipairs(components) do
            wezterm.log_error(content)
            content = content .. wezterm.format(component)
        end
        window:set_right_status(content)
    end)
end
