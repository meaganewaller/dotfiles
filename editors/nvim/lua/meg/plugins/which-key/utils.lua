local M = {}

local function register_descriptions(mappings)
  return vim.tbl_map(function(keymap)
    if type(keymap) ~= "table" then
      return keymap
    end

    if type(keymap[2]) == "string" then
      return keymap[2]
    end

    return register_descriptions(keymap)
  end, mappings)
end

local function register_modes(which_key, mappings)
  for mode, keymaps in pairs(mappings) do
    which_key.register(register_descriptions(keymaps), { mode = mode })
  end
end

function M.register_mappings(which_key, mappings)
  register_modes(which_key, mappings)
end

return M
