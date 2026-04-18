-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- {
  --   'embark-theme/vim',
  --   lazy = false,
  --   priority = 1000,
  --   name = 'embark',
  --   config = function()
  --     vim.cmd.colorscheme 'embark'
  --   end,
  -- },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        theme = 'wave', -- or "dragon" or "lotus"
      }
      vim.cmd 'colorscheme kanagawa-wave'
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          ['html'] = {
            enable_close = false,
          },
        },
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'mfussenegger/nvim-dap-python',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap = require 'dap'

      -- Config for Python
      dap.configurations.python = {
        {
          type = 'python',
          request = 'attach',
          name = 'Attach to Docker',
          connect = {
            host = '127.0.0.1',
            port = 5678,
          },
          pathMappings = {
            {
              localRoot = vim.fn.getcwd(),
              remoteRoot = '/app',
            },
          },
        },
      }
      -- Config for lldb
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.expand '~/.local/share/nvim/codelldb/extension/adapter/codelldb',
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
          end,
          cwd = function()
            return vim.fn.getcwd() .. '/build'
          end,
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp

      vim.keymap.set('n', '<F5>', function()
        dap.continue()
      end, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F8>', function()
        dap.step_over()
      end, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F7>', function()
        dap.step_into()
      end, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F6>', function()
        dap.step_out()
      end, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', function()
        dap.toggle_breakpoint()
      end, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>dq', function()
        dap.terminate()
      end, { desc = 'Debug: Terminate' })

      local dapui = require 'dapui'
      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        view = {
          width = '15%',
        },
        filters = {
          git_ignored = false,
        },
      }
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
    end,
  },
}
