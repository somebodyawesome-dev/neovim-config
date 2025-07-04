-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.system {'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path}
    vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'

    use { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        requires = { -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', -- Useful status updates for LSP
        'j-hui/fidget.nvim', -- Additional lua configuration, makes nvim stuff amazing
        'folke/neodev.nvim'}
    }
    -- Debugging
    use 'mfussenegger/nvim-dap'
    use {
        "rcarriga/nvim-dap-ui",
        requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
    }
    use 'leoluz/nvim-dap-go'

    use { -- Autocompletion
        'hrsh7th/nvim-cmp',
        requires = {'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip'}
    }

    use { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update {
                with_sync = true
            })
        end
    }
    -- bufferline packages
    use {
        'akinsho/bufferline.nvim',
        tag = "*",
        requires = 'nvim-tree/nvim-web-devicons'
    }

    use { -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter'
    }

    -- Git related plugins
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'
    use 'lewis6991/gitsigns.nvim'
    use 'rebelot/kanagawa.nvim'
    use({
        "kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        requires = {"nvim-lua/plenary.nvim"}
    })
    -- use 'navarasu/onedark.nvim' -- Theme inspired by Atom
    use {'nvim-lualine/lualine.nvim'} -- Fancier statusline
    use {'kyazdani42/nvim-web-devicons'}
    use "lukas-reineke/indent-blankline.nvim" -- Add indentation guides even on blank lines
    use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
    use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

    -- Fuzzy Finder (files, lsp, etc)
    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = {'nvim-lua/plenary.nvim'}
    }

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        cond = vim.fn.executable 'make' == 1
    }
    use 'airblade/vim-rooter' -- auto set directory when file is opened
    -- download packages for formating
    use {
        'prettier/vim-prettier',
        run = 'npm install --frozen-lockfile --production'
    }
    -- Auto pair
    use 'jiangmiao/auto-pairs'
    -- transparent background
    use 'xiyaowong/nvim-transparent'
    -- use {
    --   "folke/trouble.nvim",
    --   requires = "kyazdani42/nvim-web-devicons",
    --   config = function()
    --     require("trouble").setup {
    --       -- your configuration comes here
    --       -- or leave it empty to use the default settings
    --       -- refer to the configuration section below
    --     }
    --   end
    -- }
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup() -- now this works in v3
        end
    }
    -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
    local has_plugins, plugins = pcall(require, 'custom.plugins')
    if has_plugins then
        plugins(use)
    end

    if is_bootstrap then
        require('packer').sync()
    end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
    print '=================================='
    print '    Plugins are being installed'
    print '    Wait until Packer completes,'
    print '       then restart nvim'
    print '=================================='
    return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', {
    clear = true
})
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | PackerCompile',
    group = packer_group,
    pattern = vim.fn.expand '$MYVIMRC'
})

