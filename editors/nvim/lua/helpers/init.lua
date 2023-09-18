local helpers = {}

function helpers.cmdify(thing)
  return "<cmd>" .. thing .. "<cr>"
end

function helpers.themed_telescope(picker)
  local theme = require('telescope.themes').get_ivy({
    border = false,
  })
  return function() picker(theme) end
end

function helpers.cwd_in_git_repo()
  return vim.fn.system("git rev-parse --is-inside-work-tree") == "true\n"
end

local link_table = {
  NavicIconsFile = { link = "NvimTreeSpecialFile" },
  NavicIconsModule = { link = "CmpItemKindModule" },
  NavicIconsNamespace = { link = "CmpItemKindNamespace" },
  NavicIconsPackage = { link = "CmpItemKindPackage" },
  NavicIconsClass = { link = "CmpItemKindClass" },
  NavicIconsMethod = { link = "CmpItemKindMethod" },
  NavicIconsProperty = { link = "CmpItemKindProperty" },
  NavicIconsField = { link = "CmpItemKindField" },
  NavicIconsConstructor = { link = "CmpItemKindConstructor" },
  NavicIconsEnum = { link = "CmpItemKindEnum" },
  NavicIconsInterface = { link = "CmpItemKindInterface" },
  NavicIconsFunction = { link = "CmpItemKindFunction" },
  NavicIconsVariable = { link = "CmpItemKindVariable" },
  NavicIconsConstant = { link = "Constant" },
  NavicIconsString = { link = "String" },
  NavicIconsNumber = { link = "Number" },
  NavicIconsBoolean = { link = "Boolean" },
  NavicIconsArray = { link = "CmpItemKindField" },
  NavicIconsObject = { link = "CmpItemKindField" },
  NavicIconsKey = { link = "CmpItemKindConstant" },
  NavicIconsNull = { link = "CmpItemKindConstant" },
  NavicIconsEnumMember = { link = "CmpItemKindEnumMember" },
  NavicIconsStruct = { link = "CmpItemKindStruct" },
  NavicIconsEvent = { link = "CmpItemKindEvent" },
  NavicIconsOperator = { link = "CmpItemKindOperator" },
  NavicIconsTypeParameter = { link = "CmpItemKindConstant" },
  NavicText = { link = "Normal" },
  NavicSeparator = { link = "Delimiter" },
}

function helpers.link_navic_to_other_hlgroups()
  for group_name, group_settings in pairs(link_table) do
    vim.api.nvim_set_hl(0, group_name, group_settings)
  end
end

return helpers
