local keybindings = require("behavior.keybindings")

local behavior = {}

function behavior.apply_to_config(config)
    config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
    config.automatically_reload_config = true
    config.notification_handling = "AlwaysShow"

    require("behavior.eventhandlers")
    keybindings.apply_to_config(config)
end

return behavior
