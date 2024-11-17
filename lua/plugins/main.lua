return {
  { "navarasu/onedark.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  { "folke/trouble.nvim", enabled = false },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
  },

  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        rust_analyzer = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        rust_analyzer = function(_, opts)
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "vim",
        "yaml",
        "rust",
        "ron",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
      })
    end,
  },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },

  --    {
  --     "stevearc/conform.nvim",
  --     dependencies = { "mason.nvim" },
  --     lazy = true,
  --     cmd = "ConformInfo",
  --     keys = {
  --       {
  --         "<leader>cF",
  --         function()
  --           require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
  --         end,
  --         mode = { "n", "v" },
  --         desc = "Format Injected Langs",
  --       },
  --     },
  --     init = function()
  --       -- Install the conform formatter on VeryLazy
  --       LazyVim.on_very_lazy(function()
  --         LazyVim.format.register({
  --           name = "conform.nvim",
  --           priority = 100,
  --           primary = true,
  --           format = function(buf)
  --             require("conform").format({ bufnr = buf })
  --           end,
  --           sources = function(buf)
  --             local ret = require("conform").list_formatters(buf)
  --             ---@param v conform.FormatterInfo
  --             return vim.tbl_map(function(v)
  --               return v.name
  --             end, ret)
  --           end,
  --         })
  --       end)
  --     end,
  --     opts = function()
  --       local plugin = require("lazy.core.config").plugins["conform.nvim"]
  --       if plugin.config ~= M.setup then
  --         LazyVim.error({
  --           "Don't set `plugin.config` for `conform.nvim`.\n",
  --           "This will break **LazyVim** formatting.\n",
  --           "Please refer to the docs at https://www.lazyvim.org/plugins/formatting",
  --         }, { title = "LazyVim" })
  --       end
  --       ---@type conform.setupOpts
  --       local opts = {
  --         default_format_opts = {
  --           timeout_ms = 3000,
  --           async = false, -- not recommended to change
  --           quiet = false, -- not recommended to change
  --           lsp_format = "fallback", -- not recommended to change
  --         },
  --         formatters_by_ft = {
  --           lua = { "stylua" },
  --           fish = { "fish_indent" },
  --           sh = { "shfmt" },
  --         },
  --         -- The options you set here will be merged with the builtin formatters.
  --         -- You can also define any custom formatters here.
  --         ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
  --         formatters = {
  --           injected = { options = { ignore_errors = true } },
  --           -- # Example of using dprint only when a dprint.json file is present
  --           -- dprint = {
  --           --   condition = function(ctx)
  --           --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
  --           --   end,
  --           -- },
  --           --
  --           -- # Example of using shfmt with extra args
  --           -- shfmt = {
  --           --   prepend_args = { "-i", "2", "-ci" },
  --           -- },
  --         },
  --       }
  --       return opts
  --     end,
  --     config = M.setup,
  --   },
}