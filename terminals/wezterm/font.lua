local wez = require("wezterm")

local M = {}
-- The Font rules are being applied here.
M.apply_to_config = function(c)
  c.font = wez.font({ family = "0xProto Nerd Font Mono", weight = "Regular" })
  c.font_size = 18
  c.font_rules = {
    {
      intensity = "Normal",
      italic = true,
      font = wez.font({ family = "0xProto", weight = "Regular", italic = true, harfbuzz_features = { "ss01" } }),
    },
  }
  c.adjust_window_size_when_changing_font_size = false
end

return M
