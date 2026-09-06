-- The following section is for setting up the lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- The following section is for setting up the plugins
require("lazy").setup({
  "mhinz/vim-startify",
  "altercation/vim-colors-solarized",
  "tomasr/molokai",
  "Numkil/ag.nvim",
  "neovim/nvim-lspconfig",
  "FooSoft/vim-argwrap",
  "ntpeters/vim-better-whitespace",
  "lambdalisue/suda.vim",
  "lepture/vim-jinja",
  "jonsmithers/vim-html-template-literals",
  "pangloss/vim-javascript",
  "radenling/vim-dispatch-neovim",
  "tpope/vim-dispatch",
  "tpope/vim-eunuch",
  "nvim-treesitter/nvim-treesitter",
  -- "romgrk/nvim-treesitter-context",
  "udalov/kotlin-vim",
  "nvim-lua/plenary.nvim",
  {'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } },
  "tpope/vim-fugitive",
  --"github/copilot.vim",
  --"TabbyML/vim-tabby",
  {
    'aneeshdurg/winsearch',
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    'kaarmu/typst.vim',
    ft='typst',
    lazy=false,
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
  },
  {
    "olimorris/codecompanion.nvim",
    version = "^18.0.0",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
        processor = "magick_cli",
    }
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
        vim.g.molten_image_provider = "image.nvim"
    end,
  },
})

require("codecompanion").setup({
  interactions = {
    chat = {
      adapter = "ollama",
    },
    inline = {
      adapter = "ollama",
    },
    cmd = {
      adapter = "ollama",
    },
    background = {
      adapter = "ollama",
    },
  },
  adapters = {
    http = {
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          env = {
            url = "127.0.0.1:11434",
          },
          parameters = {
            sync = true,
          },
        })
      end,
    },
  },
})

vim.lsp.config.clangd = {
  cmd = { 'clangd', '--background-index' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp' },
}

vim.lsp.enable({'clangd'})

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client:supports_method('textDocument/completion') then
--       vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--     end
--   end,
-- })


vim.lsp.config('ts_ls', {})
vim.lsp.enable('ts_ls')
vim.lsp.config('pyright', {})
vim.lsp.enable('pyright')
vim.lsp.config('ruff', {})
vim.lsp.enable('ruff')
vim.lsp.config('clangd', {})
vim.lsp.enable('clangd')
vim.lsp.enable('bashls')

-- require'lspconfig'.clangd.setup{
-- }
-- require'lspconfig'.pyright.setup{
--   cmd = { "/home/aneesh/miniconda3/bin/conda", "run", "-n", "base", "--no-capture-output", "pyright-langserver", "--stdio" }
-- }
-- require'lspconfig'.pyright.setup{}
-- require'lspconfig'.ruff.setup{}

-- require'lspconfig'.rust_analyzer.setup{}
-- require'treesitter-context'.setup{
--     enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
--     throttle = true, -- Throttles plugin updates (may improve performance)
-- }


vim.keymap.set("v", "gf", vim.lsp.buf.format, { noremap = true, silent = true })

vim.o.winborder = 'rounded'

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})

vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
    { silent = true, desc = "Initialize the plugin" })
vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
    { silent = true, desc = "run operator selection" })
vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>",
    { silent = true, desc = "evaluate line" })
vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>",
    { silent = true, desc = "re-evaluate cell" })
vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
    { silent = true, desc = "evaluate visual selection" })
