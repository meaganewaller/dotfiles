local spectre = require("spectre")

local config = {
	mapping = {},
	line_sep_start = "╭─────────────────────────────────────────",
	line_sep = "╰─────────────────────────────────────────",
	result_padding = "│  ",
}

-- Keymaps ===================================================================

config.mapping = {
	["toggle_line"] = {
		map = "xddt",
		cmd = "<Cmd>lua require('spectre').toggle_line()<CR>",
		desc = "Toggle item (spectre)"
	},
	["enter_file"] = {
		map = "<cr>",
		cmd = "<Cmd>lua require('spectre.actions').select_entry()<CR>",
		desc = "open file (spectre)",
	},
	["send_to_qf"] = {
		map = "<leader>q",
		cmd = "<Cmd>lua require('spectre.actions').send_to_qf()<CR>",
		desc = "send all item to quickfix (spectre)",
	},
	["replace_cmd"] = {
		map = "<leader>c",
		cmd = "<Cmd>lua require('spectre.actions').replace_cmd()<CR>",
		desc = "input replace vim command (spectre)",
	},
	["show_option_menu"] = {
		map = "<leader>o",
		cmd = "<Cmd>lua require('spectre').show_options()<CR>",
		desc = "show option (spectre)",
  },
  ['run_current_replace'] = {
    map = '<leader>rc',
    cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
    desc = 'replace current line (spectre)'
  },
  ['run_replace'] = {
    map = '<leader>R',
    cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
    desc = 'replace all (spectre)'
  },
  ['change_view_mode'] = {
    map = '<leader>v',
    cmd = "<cmd>lua require('spectre').change_view()<CR>",
    desc = 'change result view mode (spectre)'
  },
  ['change_replace_sed'] = {
    map = 'trs',
    cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
    desc = 'use sed to replace (spectre)'
  },
  ['change_replace_oxi'] = {
    map = 'tro',
    cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
    desc = 'use oxi to replace (spectre)'
  },
  ['toggle_live_update'] = {
    map = 'tu',
    cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
    desc = 'update when vim writes to file (spectre)'
  },
  ['toggle_ignore_case'] = {
    map = 'ti',
    cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
    desc = 'toggle ignore case (spectre)'
  },
  ['toggle_ignore_hidden'] = {
    map = 'th',
    cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
    desc = 'toggle search hidden (spectre)'
  },
  ['resume_last_search'] = {
    map = '<leader>l',
    cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
    desc = 'repeat last search (spectre)'
  },
}

nx.map({
  { "<Leader>S", "<cmd>lua require('spectre').toggle()<CR>", desc = "Toggle Spectre" },
  { "<Leader>sw", "<cmd>lua require('spectre').open_visual({ select_word = true })<CR>", desc = "Search current word (spectre)" },
  { "<Leader>sw", "<esc><cmd>lua require('spectre').open_visual()<CR>", "v", desc = "Search current word (spectre)" },
  { "<Leader>sp", "<cmd>lua require('spectre').open_file_search({ select_word = true })<CR>", desc = "Search on current file (spectre)" },
})

spectre.setup(config)
