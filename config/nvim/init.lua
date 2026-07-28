vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.winborder = "single"
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.completeopt = "menuone,noselect,popup"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.filetype.add({
  extension = {
    jai = "jai",
  },
})

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
    { "rluba/jai.vim" },
    { "L3MON4D3/LuaSnip" },
    { "direnv/direnv.vim" },
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
  install = { colorscheme = { "wallust" } },
  checker = { enabled = true },
})

local colorscheme_ok, colorscheme_error = pcall(vim.cmd.colorscheme, "wallust")
if not colorscheme_ok then
  vim.notify("Failed to load wallust colorscheme: " .. colorscheme_error, vim.log.levels.WARN)
end

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
    path_display = { "smart" },
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

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.jai = {
  install_info = {
    url = vim.fn.expand("~/.local/share/tree-sitter-jai"),
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "jai",
}

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "vim", "vimdoc", "rust", "toml", },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "DirenvLoaded",
  callback = function()
    vim.notify("direnv loaded", vim.log.levels.INFO)
  end,
})

-- LSP configuration
local builtin = require("telescope.builtin")
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
    vim.keymap.set("n", "gr", builtin.lsp_references,
      vim.tbl_extend("force", opts, { desc = "References" }))

    vim.keymap.set("n", "gi", builtin.lsp_implementations,
      vim.tbl_extend("force", opts, { desc = "Implementations" }))

    vim.keymap.set("n", "gy", builtin.lsp_type_definitions,
      vim.tbl_extend("force", opts, { desc = "Type definition" }))

    vim.keymap.set("n", "<leader>ca", require("actions-preview").code_actions,
      vim.tbl_extend("force", opts, { desc = "Code actions" }))

    vim.keymap.set("n", "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
  end,
})

require("actions-preview").setup({
  backend = { "telescope" },
  telescope = vim.tbl_extend(
    "force",
    require("telescope.themes").get_dropdown(), {}
  )
})

vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--query-driver=/nix/store/**/clang++,/nix/store/**/clang",
    "--header-insertion=never",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".clangd",
    ".git",
  },
  flags = {
    debounce_text_changes = 100,
  },
}

vim.lsp.enable("clangd")
vim.lsp.enable({ 'clangd' })

vim.lsp.config.rust_analyzer = {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },

  root_markers = {
    "Cargo.toml",
    "Cargo.lock",
    "rust-project.json",
    ".git",
  },

  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allTargets = true,
        features = "all",
        buildScripts = {
          enable = true,
        },
      },

      procMacro = {
        enable = true,
      },

      check = {
        command = "clippy",
      },

      completion = {
        fullFunctionSignatures = {
          enable = true,
        },
      },
    },
  },
}

vim.lsp.enable("rust_analyzer")

require("lspconfig").hls.setup({}) 

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
    border = "single",
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
local map = vim.keymap.set

-- Map jk to <Esc> in insert mode
map('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Optional: Map jk to <Esc> in visual/terminal mode
map('v', 'jk', '<Esc>', { noremap = true, silent = true })
map('t', 'jk', '<C-\\><C-n>', { noremap = true, silent = true })

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

-- window stuff
map("n", "<leader>wv", "<Cmd>vsplit<CR>", { desc = "split veritcally" })
map("n", "<leader>ws", "<Cmd>split<CR>", { desc = "split horizontally" })
map("n", "<leader>wh", "<C-w>h", { desc = "window swap left" })
map("n", "<leader>wj", "<C-w>j", { desc = "window swap down" })
map("n", "<leader>wk", "<C-w>k", { desc = "window swap up" })
map("n", "<leader>wl", "<C-w>l", { desc = "window swap right" })
