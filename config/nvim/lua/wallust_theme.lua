local M = {}

local function set_terminal_colors(p)
  for i = 0, 15 do
    vim.g["terminal_color_" .. i] = p["color" .. i]
  end
end

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.setup(p)
  vim.o.termguicolors = true
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "wallust"

  set_terminal_colors(p)

  hl("Normal", { fg = p.foreground, bg = p.background })
  hl("NormalNC", { fg = p.foreground, bg = p.background })
  hl("EndOfBuffer", { fg = p.background, bg = p.background })
  hl("SignColumn", { fg = p.color8, bg = p.background })
  hl("FoldColumn", { fg = p.color8, bg = p.background })
  hl("LineNr", { fg = p.color8, bg = p.background })
  hl("CursorLine", { bg = p.color0 })
  hl("CursorLineNr", { fg = p.color14, bg = p.color0, bold = true })
  hl("Cursor", { fg = p.background, bg = p.cursor })
  hl("ColorColumn", { bg = p.color0 })
  hl("Visual", { fg = p.foreground, bg = p.color0 })
  hl("Search", { fg = p.background, bg = p.color14 })
  hl("IncSearch", { fg = p.background, bg = p.color11, bold = true })
  hl("MatchParen", { fg = p.color14, bg = p.color0, bold = true })

  hl("NormalFloat", { fg = p.foreground, bg = p.color0 })
  hl("FloatBorder", { fg = p.color12, bg = p.color0 })
  hl("FloatTitle", { fg = p.color14, bg = p.color0, bold = true })
  hl("WinSeparator", { fg = p.color8, bg = p.background })

  hl("StatusLine", { fg = p.foreground, bg = p.color0 })
  hl("StatusLineNC", { fg = p.color8, bg = p.background })
  hl("TabLine", { fg = p.color8, bg = p.color0 })
  hl("TabLineSel", { fg = p.background, bg = p.color12, bold = true })
  hl("TabLineFill", { bg = p.background })

  hl("Pmenu", { fg = p.foreground, bg = p.color0 })
  hl("PmenuSel", { fg = p.background, bg = p.color12, bold = true })
  hl("PmenuSbar", { bg = p.color0 })
  hl("PmenuThumb", { bg = p.color8 })

  hl("Comment", { fg = p.color8, italic = true })
  hl("Constant", { fg = p.color11 })
  hl("String", { fg = p.color10 })
  hl("Character", { fg = p.color10 })
  hl("Number", { fg = p.color13 })
  hl("Boolean", { fg = p.color11, bold = true })
  hl("Float", { fg = p.color13 })
  hl("Identifier", { fg = p.foreground })
  hl("Function", { fg = p.color12, bold = true })
  hl("Statement", { fg = p.color9, bold = true })
  hl("Conditional", { fg = p.color9, bold = true })
  hl("Repeat", { fg = p.color9, bold = true })
  hl("Label", { fg = p.color14 })
  hl("Operator", { fg = p.color6 })
  hl("Keyword", { fg = p.color9, bold = true })
  hl("Exception", { fg = p.color1, bold = true })
  hl("PreProc", { fg = p.color5 })
  hl("Include", { fg = p.color5, bold = true })
  hl("Define", { fg = p.color5 })
  hl("Macro", { fg = p.color5 })
  hl("Type", { fg = p.color14, bold = true })
  hl("StorageClass", { fg = p.color13 })
  hl("Structure", { fg = p.color14 })
  hl("Special", { fg = p.color6 })
  hl("SpecialChar", { fg = p.color6 })
  hl("Delimiter", { fg = p.color7 })
  hl("Underlined", { fg = p.color12, underline = true })
  hl("Ignore", { fg = p.color8 })
  hl("Error", { fg = p.color1, bg = p.background, bold = true })
  hl("Todo", { fg = p.background, bg = p.color14, bold = true })

  hl("DiagnosticError", { fg = p.color1 })
  hl("DiagnosticWarn", { fg = p.color3 })
  hl("DiagnosticInfo", { fg = p.color12 })
  hl("DiagnosticHint", { fg = p.color10 })
  hl("DiagnosticOk", { fg = p.color10 })
  hl("DiagnosticUnderlineError", { sp = p.color1, undercurl = true })
  hl("DiagnosticUnderlineWarn", { sp = p.color3, undercurl = true })
  hl("DiagnosticUnderlineInfo", { sp = p.color12, undercurl = true })
  hl("DiagnosticUnderlineHint", { sp = p.color10, undercurl = true })

  hl("DiffAdd", { fg = p.color10, bg = p.background })
  hl("DiffChange", { fg = p.color12, bg = p.background })
  hl("DiffDelete", { fg = p.color1, bg = p.background })
  hl("DiffText", { fg = p.color14, bg = p.color0, bold = true })
  hl("GitSignsAdd", { fg = p.color10 })
  hl("GitSignsChange", { fg = p.color12 })
  hl("GitSignsDelete", { fg = p.color1 })

  hl("@variable", { fg = p.foreground })
  hl("@variable.builtin", { fg = p.color6, italic = true })
  hl("@parameter", { fg = p.color13 })
  hl("@property", { fg = p.color6 })
  hl("@field", { fg = p.color6 })
  hl("@function", { fg = p.color12, bold = true })
  hl("@function.builtin", { fg = p.color14, bold = true })
  hl("@keyword", { fg = p.color9, bold = true })
  hl("@keyword.return", { fg = p.color1, bold = true })
  hl("@type", { fg = p.color14, bold = true })
  hl("@type.builtin", { fg = p.color10, bold = true })
  hl("@string", { fg = p.color10 })
  hl("@comment", { fg = p.color8, italic = true })
  hl("@constant", { fg = p.color11 })
  hl("@constant.builtin", { fg = p.color13 })
  hl("@operator", { fg = p.color6 })
  hl("@punctuation", { fg = p.color7 })

  hl("TelescopeNormal", { fg = p.foreground, bg = p.background })
  hl("TelescopeBorder", { fg = p.color8, bg = p.background })
  hl("TelescopePromptNormal", { fg = p.foreground, bg = p.color0 })
  hl("TelescopePromptBorder", { fg = p.color12, bg = p.color0 })
  hl("TelescopePromptTitle", { fg = p.background, bg = p.color12, bold = true })
  hl("TelescopePreviewTitle", { fg = p.background, bg = p.color5, bold = true })
  hl("TelescopeResultsTitle", { fg = p.background, bg = p.color10, bold = true })
  hl("TelescopeSelection", { fg = p.color14, bg = p.color0, bold = true })
  hl("TelescopeMatching", { fg = p.color11, bold = true })

  hl("OilDir", { fg = p.color12, bold = true })
  hl("OilFile", { fg = p.foreground })
  hl("OilPermRead", { fg = p.color10 })
  hl("OilPermWrite", { fg = p.color11 })
  hl("OilPermExec", { fg = p.color1 })
end

return M
