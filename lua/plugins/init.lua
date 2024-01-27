local plugins = {
  { lazy = true, "nvim-lua/plenary.nvim" },

  -- { "MunifTanjim/nui.nvim", lazy = true },

  -- FTerm
  {
    "numToStr/FTerm.nvim",
    init = function()
      require("utils.loaders").load_mappings "fterm"
    end,
    opts = function()
      return require "plugins.configs.fterm"
    end,
    config = function(_, opts)
      require("FTerm").setup(opts)
    end,
  },

  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("utils.loaders").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },

  -- icons, for UI related plugins
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },

  -- search/replace in multiple files
  -- {
  --   "nvim-pack/nvim-spectre",
  --   build = false,
  --   cmd = "Spectre",
  --   opts = { open_cmd = "noswapfile vnew" },
  --   -- stylua: ignore
  --   keys = {
  --     { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
  --   },
  -- },

  -- syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "BufReadPre",
    init = function()
      require("utils.loaders").load_mappings "bufferline"
    end,
    opts = function()
      return require "plugins.configs.bufferline"
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },

  -- -- buffer + tab line
  -- {
  --   "akinsho/bufferline.nvim",
  --   event = "BufReadPre",
  --   config = function()
  --     require "plugins.configs.bufferline"
  --   end,
  -- },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    -- init = function()
    --   vim.g.lualine_laststatus = vim.o.laststatus
    --   if vim.fn.argc(-1) > 0 then
    --     -- set an empty statusline till lualine loads
    --     vim.o.statusline = " "
    --   else
    --     -- hide the statusline on the starter page
    --     vim.o.laststatus = 0
    --   end
    -- end,
    opts = function()
      return require "plugins.configs.lualine"
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },

  -- {
  --   "echasnovski/mini.statusline",
  --   config = function()
  --     require("mini.statusline").setup { set_vim_settings = false }
  --   end,
  -- },

  -- we use cmp plugin only when in insert mode
  -- so lets lazyload it at InsertEnter event, to know all the events check h-events
  -- completion , now all of these plugins are dependent on cmp, we load them after cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          local luasnip_config = require "plugins.configs.luasnip"
          luasnip_config(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    config = function()
      require "plugins.configs.cmp"
    end,
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = function(_, opts)
      require("mason").setup(opts)

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      require("utils.loaders").load_mappings "lspconfig"
    end,
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

  -- formatting , linting
  {
    "stevearc/conform.nvim",
    lazy = true,
    init = function()
      require("utils.loaders").load_mappings "conform"
    end,
    opts = function()
      return require "plugins.configs.conform"
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },

  -- indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      return require "plugins.configs.blankline"
    end,
    config = function(_, opts)
      require("utils.loaders").load_mappings "blankline"
      require("ibl").setup(opts)
    end,
  },

  -- files finder etc
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    init = function()
      require("utils.loaders").load_mappings "telescope"
    end,
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      -- Load telescope extensions
      -- for _, ext in pairs(opts.extensions_list) do
      --   telescope.load_extension(ext)
      -- end
    end,
  },

  -- git status on signcolumn etc
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- comment plugin
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    init = function()
      require("utils.loaders").load_mappings "comment"
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  -- Whichkey
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    init = function()
      require("utils.loaders").load_mappings "whichkey"
    end,
    cmd = "WhichKey",
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup(opts)
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = function()
      return require "plugins.configs.surround"
    end,
    config = function(_, opts)
      require("nvim-surround").setup(opts)
    end,
  },

  -- LSP
  {
    "folke/trouble.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    init = function()
      require("utils.loaders").load_mappings "trouble"
    end,
    opts = function()
      return require "plugins.configs.trouble"
    end,
    config = function(_, opts)
      require("trouble").setup(opts)
    end,
  },

  -- Helpers
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    init = function()
      return require "plugins.configs.copilot"
    end,
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },

  -- Themes
  {
    "Hiroya-W/sequoia-moonlight.nvim",
    priority = 1000,
    -- config = function()
    --   require("sequoia").colorscheme();
    -- end
  },

  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
  },

  -- {
  --   "EdenEast/nightfox.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("nightfox").setup {
  --       groups = {
  --         all = { VertSplit = { fg = "bg3" } },
  --       },
  --     }
  --   end,
  -- },
}

require("lazy").setup(plugins, require "plugins.configs.lazy_nvim")
