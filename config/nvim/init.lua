vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.winborder = "rounded"
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.completeopt = "menuone,noselect,popup"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Theme
    {
      "rebelot/kanagawa.nvim",
      priority = 1000,
      config = function()
        require("kanagawa").setup({
          compile = true,
          undercurl = true,
          commentStyle = { italic = true },
          functionStyle = { bold = true },
          keywordStyle = { italic = true },
          statementStyle = { bold = true },
          typeStyle = { bold = true },
          transparent = false,
          terminalColors = true,
          theme = "wave",
          background = { dark = "wave" },

          colors = {
            palette = {
              -- Base backgrounds — BA navy/black
              sumiInk0  = "#00000A",
              sumiInk1  = "#060612",
              sumiInk2  = "#0A1020",
              sumiInk3  = "#0D1B2A",  -- main bg
              sumiInk4  = "#112236",
              sumiInk5  = "#1A2F45",
              sumiInk6  = "#1E3550",

              -- Foreground
              fujiWhite = "#C8D8F0",
              oldWhite  = "#A8BEDE",

              -- BA cyan — keywords, functions
              crystalBlue = "#4DB8FF",
              springBlue  = "#7FE7F5",
              lightBlue   = "#A0D8EF",

              -- BA lavender — types, special
              springViolet1 = "#B8A0FF",
              springViolet2 = "#9B85E8",
              oniViolet     = "#B8A0FF",
              oniViolet2    = "#9B85E8",

              -- BA pink — errors, warnings
              samuraiRed  = "#FF6B8A",
              peachRed    = "#FF8FA6",
              autumnRed   = "#CC4455",

              -- BA teal — strings
              springGreen = "#5DDBB0",
              autumnGreen = "#3DBB90",

              -- BA yellow — constants
              carpYellow  = "#FFD485",
              boatYellow1 = "#FFB84D",
              boatYellow2 = "#FFA020",

              -- Muted blues for comments/inactive
              fujiGray    = "#4A6A8A",
              dragonBlue  = "#6A9FBF",
            },
            theme = {
              wave = {
                ui = {
                  bg            = "#00000A",
                  bg_dim        = "#060612",
                  bg_gutter     = "#0A1020",
                  bg_m3         = "#0D1B2A",
                  bg_m2         = "#112236",
                  bg_m1         = "#1A2F45",
                  bg_p1         = "#1E3550",
                  bg_p2         = "#223860",
                  fg            = "#C8D8F0",
                  pmenu = {
                    bg    = "#0D1B2A",
                    bg_sel = "#1A2F45",
                    fg    = "#C8D8F0",
                    fg_sel = "#7FE7F5",
                    sbar  = "#112236",
                    thumb = "#2A5F8F",
                  },
                  float = {
                    bg     = "#0D1B2A",
                    bg_border = "#2A5F8F",
                  },
                },
              },
            },
          },

          overrides = function(colors)
            local theme = colors.theme
            return {
              -- Transparent floating windows with BA border
              NormalFloat  = { bg = "#0D1B2A" },
              FloatBorder  = { fg = "#4DB8FF", bg = "#0D1B2A" },
              FloatTitle   = { fg = "#7FE7F5", bold = true },

              -- Telescope
              TelescopeNormal         = { bg = "#0D1B2A" },
              TelescopeBorder         = { fg = "#2A5F8F", bg = "#0D1B2A" },
              TelescopePromptNormal   = { bg = "#112236" },
              TelescopePromptBorder   = { fg = "#4DB8FF", bg = "#112236" },
              TelescopePromptTitle    = { fg = "#7FE7F5", bold = true },
              TelescopePreviewTitle   = { fg = "#B8A0FF", bold = true },
              TelescopeResultsTitle   = { fg = "#5DDBB0", bold = true },
              TelescopeSelection      = { bg = "#1A2F45", fg = "#7FE7F5" },
              TelescopeMatching       = { fg = "#4DB8FF", bold = true },

              -- Cursor line
              CursorLine   = { bg = "#0D1B2A" },
              CursorLineNr = { fg = "#7FE7F5", bold = true },

              -- Line numbers
              LineNr       = { fg = "#2A5F8F" },

              -- Search
              Search       = { bg = "#1A3A5A", fg = "#7FE7F5" },
              IncSearch    = { bg = "#4DB8FF", fg = "#00000A" },

              -- Diagnostics
              DiagnosticError = { fg = "#FF6B8A" },
              DiagnosticWarn  = { fg = "#FFD485" },
              DiagnosticInfo  = { fg = "#4DB8FF" },
              DiagnosticHint  = { fg = "#5DDBB0" },

              -- LSP semantic tokens
              ["@variable"]          = { fg = "#C8D8F0" },
              ["@variable.builtin"]  = { fg = "#7FE7F5", italic = true },
              ["@function"]          = { fg = "#4DB8FF", bold = true },
              ["@function.builtin"]  = { fg = "#7FE7F5", bold = true },
              ["@keyword"]           = { fg = "#B8A0FF", italic = true },
              ["@keyword.return"]    = { fg = "#FF6B8A", italic = true },
              ["@type"]              = { fg = "#7FE7F5", bold = true },
              ["@type.builtin"]      = { fg = "#5DDBB0", bold = true },
              ["@string"]            = { fg = "#5DDBB0" },
              ["@comment"]           = { fg = "#4A6A8A", italic = true },
              ["@constant"]          = { fg = "#FFD485" },
              ["@constant.builtin"]  = { fg = "#FF8FA6" },
              ["@operator"]          = { fg = "#7FE7F5" },
              ["@punctuation"]       = { fg = "#6A8AAA" },
              ["@parameter"]         = { fg = "#C8D8F0", italic = true },
              ["@field"]             = { fg = "#A0D8EF" },
              ["@property"]          = { fg = "#A0D8EF" },

              -- Completion menu
              Pmenu      = { bg = "#0D1B2A", fg = "#C8D8F0" },
              PmenuSel   = { bg = "#1A2F45", fg = "#7FE7F5", bold = true },
              PmenuSbar  = { bg = "#112236" },
              PmenuThumb = { bg = "#2A5F8F" },

              -- Statusline
              StatusLine   = { bg = "#0D1B2A", fg = "#C8D8F0" },
              StatusLineNC = { bg = "#060612", fg = "#4A6A8A" },

              -- Tabline
              TabLine      = { bg = "#060612", fg = "#4A6A8A" },
              TabLineSel   = { bg = "#0D1B2A", fg = "#7FE7F5", bold = true },
              TabLineFill  = { bg = "#00000A" },

              -- Git signs (if you add gitsigns later)
              GitSignsAdd    = { fg = "#5DDBB0" },
              GitSignsChange = { fg = "#4DB8FF" },
              GitSignsDelete = { fg = "#FF6B8A" },

              -- Oil
              OilDir       = { fg = "#4DB8FF", bold = true },
              OilFile      = { fg = "#C8D8F0" },
              OilPermRead  = { fg = "#5DDBB0" },
              OilPermWrite = { fg = "#FFD485" },
              OilPermExec  = { fg = "#FF6B8A" },
            }
          end,
        })
        vim.cmd("colorscheme kanagawa-wave")
      end,
    },

    -- All your existing plugins unchanged
    { "nvim-telescope/telescope.nvim" },
    { "LinArcX/telescope-env.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "chentoast/marks.nvim" },
    { "stevearc/oil.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "aznhe21/actions-preview.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-lua/plenary.nvim" },
    { "chomosuke/typst-preview.nvim" },
    { "neovim/nvim-lspconfig" },
    { "L3MON4D3/LuaSnip" },
    {
      "mikavilpas/yazi.nvim",
      version = "*",
      event = "VeryLazy",
      dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
      },
      keys = {
        {
          "<leader>-",
          mode = { "n", "v" },
          "<cmd>Yazi<cr>",
          desc = "Open yazi at the current file",
        },
        {
          "<leader>z",
          "<cmd>Yazi cwd<cr>",
          desc = "Open the file manager in nvim's working directory",
        },
        {
          "<c-up>",
          "<cmd>Yazi toggle<cr>",
          desc = "Resume the last yazi session",
        },
      },
      opts = {
        open_for_directories = false,
        keymaps = {
          show_help = "<f1>",
        },
      },
      init = function()
        vim.g.loaded_netrwPlugin = 1
      end,
    },
  },
  install = { colorscheme = { "kanagawa-wave" } },
  checker = { enabled = true },
})

-- Plugin configurations (all unchanged)
require("marks").setup({
  builtin_marks = { "<", ">", "^" },
  refresh_interval = 250,
  sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
  excluded_filetypes = {},
  excluded_buftypes = {},
  mappings = {}
})

require("telescope").setup({
  defaults = {
    color_devicons = true,
    sorting_strategy = "ascending",
    borderchars = { "", "", "", "", "", "", "", "" },
    path_displays = "smart",
    layout_strategy = "horizontal",
    layout_config = {
      height = 100,
      width = 400,
      prompt_position = "top",
      preview_cutoff = 40,
    }
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({})
    }
  }
})

require("telescope").load_extension("env")
require("telescope").load_extension("ui-select")

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "vim", "vimdoc" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- LSP configuration
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    vim.notify(string.format("LSP attached: %s", client.name), vim.log.levels.INFO)

    if client:supports_method("textDocument/completion") then
      local chars = {}
      for i = 32, 126 do
        table.insert(chars, string.char(i))
      end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = "Go to definition" }))
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = "Go to declaration" }))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = "Hover documentation" }))
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = "Rename symbol" }))
  end,
})

require("actions-preview").setup({
  backend = { "telescope" },
  extensions = { "env" },
  telescope = vim.tbl_extend(
    "force",
    require("telescope.themes").get_dropdown(), {}
  )
})

vim.lsp.enable({ 'clangd' })

require("oil").setup({
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = true,
  },
  columns = {
    "permissions",
    "icon",
  },
  float = {
    max_width = 0.7,
    max_height = 0.6,
    border = "rounded",
  },
})

require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

local function run_build()
  local build_script = vim.fn.findfile("build.sh", ".;")
  if build_script == "" then
    vim.notify("build.sh not found", vim.log.levels.ERROR)
    return
  end
  local build_dir = vim.fn.fnamemodify(build_script, ":h")
  vim.cmd("split | terminal")
  vim.cmd("startinsert")
  vim.api.nvim_chan_send(vim.b.terminal_job_id,
    string.format("cd '%s' && ./build.sh\n", build_dir))
end

-- Keymaps (all unchanged)
local ls = require("luasnip")
local builtin = require("telescope.builtin")
local map = vim.keymap.set

for i = 1, 8 do
  map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end
map({ "n", "t" }, "<Leader>t", "<Cmd>tabnew<CR>")
map({ "n", "t" }, "<Leader>x", "<Cmd>tabclose<CR>")

map("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics list" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank" })

map("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>gp", builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>sb", builtin.buffers, { desc = "Telescope buffers" })
map("n", "<leader>si", builtin.grep_string, { desc = "Telescope grep string" })
map("n", "<leader>so", builtin.oldfiles, { desc = "Telescope old files" })
map("n", "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
map("n", "<leader>sm", builtin.man_pages, { desc = "Telescope man pages" })
map("n", "<leader>sr", builtin.lsp_references, { desc = "Telescope LSP references" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "Telescope diagnostics" })
map("n", "<leader>sl", builtin.lsp_implementations, { desc = "Telescope LSP implementations" })
map("n", "<leader>sT", builtin.lsp_type_definitions, { desc = "Telescope LSP type definitions" })
map("n", "<leader>ss", builtin.current_buffer_fuzzy_find, { desc = "Telescope current buffer fuzzy find" })
map("n", "<leader>st", builtin.builtin, { desc = "Telescope builtins" })
map("n", "<leader>sc", builtin.git_bcommits, { desc = "Telescope git commits" })
map("n", "<leader>sk", builtin.keymaps, { desc = "Telescope keymaps" })
map("n", "<leader>se", "<cmd>Telescope env<cr>", { desc = "Telescope environment variables" })
map("n", "<leader>sa", require("actions-preview").code_actions, { desc = "Code actions preview" })

map({ "i", "s" }, "<C-k>", function() ls.jump(1) end, { desc = "Next snippet placeholder" })
map({ "i", "s" }, "<C-j>", function() ls.jump(-1) end, { desc = "Previous snippet placeholder" })

map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open Oil file manager" })
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit init.lua" })
map("n", "<leader>w", "<Cmd>update<CR>", { desc = "Write the current buffer" })
map("n", "<leader>q", "<Cmd>quit<CR>", { desc = "Quit the current buffer" })
map("n", "<leader>mb", run_build, { desc = "Run build.sh" })
