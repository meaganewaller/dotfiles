
local function setup(tabby, separators)
  vim.o.showtabline = 2

  local theme = {
    fill = "TabFill",
    head = "TabLineHead",
    current_tab = "TabLineTabActive",
    current_win = "TabLineWinActive",
    inactive_tab = "TabLineInactive",
    inactive_win = "TabLineInactive",
    tab = "TabLine",
    win = "TabLineHead",
    tail = "TabLineHead",
  }

  local function tab_name(number, name, active)
    local icon = active and "" or ""

    return string.format(" %s:%s %s ", number, string.gsub(name, "%[..%]", ""), icon)
  end

  local function win_name(name, active)
    local icon = active and "" or ""

    return string.format(" %s %s ", icon, name)
  end

  tabby.set(function(line)
    return {
      {
        { separators.block[0], hl = theme.head },
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.inactive_tab
        return {
          tab_name(tab.number(), tab.name(), tab.is_current()),
          hl = hl,
          margin = " ",
        }
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        local hl = win.is_current() and theme.current_win or theme.inactive_win
        return {
          -- line.sep(" ", hl, theme.fill),
          win_name(win.buf_name(), win.is_current()),
          hl = hl,
          margin = " ",
        }
      end),
      {
        { separators.arrow[1], hl = theme.tail },
      },
      hl = theme.fill,
    }
  end)
end

local loaded, tabby = pcall(require, "tabby.tabline")
if not loaded then
  mw.loading_error_msg("tabby.tabline")
  return
end

local separators = mw.ui.separators
setup(tabby, separators)
