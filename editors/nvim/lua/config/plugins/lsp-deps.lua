-- codicons stolen from onsails/lspkind.nvim
local codicons = {
  Text = " ",
  Method = " ",
  Function = " ",
  Constructor = " ",
  Field = " ",
  Variable = " ",
  Class = " ",
  Interface = " ",
  Module = " ",
  Property = " ",
  Unit = " ",
  Value = " ",
  Enum = " ",
  Keyword = " ",
  Snippet = " ",
  Color = " ",
  File = " ",
  Reference = " ",
  Folder = " ",
  EnumMember = " ",
  Constant = " ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
}

if vim.g.vscode then
  return {}
else
  return {
    {
      'williamboman/mason.nvim',
      build = ':MasonUpdate',
      config = true,
    },

    { 'neovim/nvim-lspconfig', },
    {
      'folke/neodev.nvim',
      config = true,
    },
    {
      'onsails/lspkind.nvim',
      config = function()
        require('lspkind').init({
          mode = 'symbol',
          preset = 'codicons'
        })
      end,
      event = 'VeryLazy',
    },
    {
      'utilyre/barbecue.nvim',
      dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons",
      },

      opts = {
        show_modified = true,
        attach_navic = false,
        theme = {
          context_file = { link = "NvimTreeSpecialFile" },
          context_module = { link = "CmpItemKindModule" },
          context_namespace = { link = "CmpItemKindNamespace" },
          context_package = { link = "CmpItemKindPackage" },
          context_class = { link = "CmpItemKindClass" },
          context_method = { link = "CmpItemKindMethod" },
          context_property = { link = "CmpItemKindProperty" },
          context_field = { link = "CmpItemKindField" },
          context_constructor = { link = "CmpItemKindConstructor" },
          context_enum = { link = "CmpItemKindEnum" },
          context_interface = { link = "CmpItemKindInterface" },
          context_function = { link = "CmpItemKindFunction" },
          context_variable = { link = "CmpItemKindVariable" },
          context_constant = { link = "Constant" },
          context_string = { link = "String" },
          context_number = { link = "Number" },
          context_boolean = { link = "Boolean" },
          context_array = { link = "CmpItemKindField" },
          context_object = { link = "CmpItemKindField" },
          context_key = { link = "CmpItemKindConstant" },
          context_null = { link = "CmpItemKindConstant" },
          context_enum_member = { link = "CmpItemKindEnumMember" },
          context_struct = { link = "CmpItemKindStruct" },
          context_event = { link = "CmpItemKindEvent" },
          context_operator = { link = "CmpItemKindOperator" },
          context_type_parameter = { link = "CmpItemKindConstant" },
        }
      }
    },
    {
      'SmiteshP/nvim-navbuddy',
      dependencies = {
        'SmiteshP/nvim-navic',
        'MunifTanjim/nui.nvim',
        'numToStr/Comment.nvim',
        'nvim-telescope/telescope.nvim',
      },
      opts = {
        icons = codicons,
        node_markers = {
          icons = {
            branch = " ",
          }
        }
      }
    }
  }
end
