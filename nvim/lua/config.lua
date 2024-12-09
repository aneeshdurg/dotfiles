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
  "nvim-treesitter/nvim-treesitter",
  -- "romgrk/nvim-treesitter-context",
  "udalov/kotlin-vim",
  "nvim-lua/plenary.nvim",
  {'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } },
  "tpope/vim-fugitive",
  "github/copilot.vim",
  --"TabbyML/vim-tabby",
})

require'lspconfig'.tsserver.setup {}

require'lspconfig'.clangd.setup{
}
require'lspconfig'.pyright.setup{
  cmd = { "/home/aneesh/miniconda3/bin/conda", "run", "-n", "base", "--no-capture-output", "pyright-langserver", "--stdio" }
}
require'lspconfig'.jdtls.setup{
  cmd = { "conda", "run", "-n", "jdtls", "--no-capture-output", "/Users/aneesh/jdtls/bin/jdtls" }
}


require'lspconfig'.rust_analyzer.setup{}
-- require'treesitter-context'.setup{
--     enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
--     throttle = true, -- Throttles plugin updates (may improve performance)
-- }


vim.keymap.set("v", "gf", vim.lsp.buf.format, { noremap = true, silent = true })
