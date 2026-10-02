vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.exrc = true

vim.g.have_nerd_font = true

vim.opt.number = true

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 10

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'numToStr/Comment.nvim', opts = {} },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]un/ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>h', group = '[H]arpoon' },
      }
    end,
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        build = 'make',

        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} },

      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      local nixd_root = vim.fs.root(0, {
        'flake.nix',
        'shell.nix',
        'default.nix',
        '.git',
      })
      local servers = {
        wgsl_analyzer = {
          filetypes = { 'wgsl' },
          command = { 'wgsl-analyzer' },
          cmd = { 'wgsl-analyzer' },
          nombre = 'wgsl_analyzer',
        },

        lua_ls = {
          filetypes = { 'lua' },
          command = { 'lua-language-server' },
          nombre = 'lua_ls',
          cmd = { 'lua-language-server' },
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
                runtime = {
                  version = 'LuaJIT',
                },

                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                  },
                },

                diagnostics = {
                  globals = { 'vim' },
                },

                telemetry = {
                  enable = false,
                },
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        r_language_server = {
          filetypes = { 'r' },
          settings = {},
        },
        pyright = {
          filetypes = { 'py', 'python' },
          cmd = { 'pyright-langserver', '--stdio' },
          settings = {
            python = {
              analysis = {
                typeCheckingMode = 'basic',
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
              },
            },
          },
          flags = {
            debounce_text_changes = 200,
          },
        },

        nixd = {
          filetypes = { 'nix' },
          cmd = { 'nixd' },
          capabilities = capabilities,

          settings = {
            nixd = {
              nixpkgs = {
                expr = 'import <nixpkgs> { }',
              },
              formatting = {
                command = { 'nixfmt' },
              },
              options = {
                nixos = {
                  expr = [[
                  let
                    flake = builtins.getFlake "/etc/nixos/";
                    hostname = builtins.getEnv "HOSTNAME";
                  in
                  flake.nixosConfigurations.${hostname}.options
                  ]],
                },
                ['home-manager'] = {
                  expr = [[
                    let
                      rawUser = builtins.getEnv "USER";
                      # Si se ejecuta con sudo, fuerza tu usuario real de Linux
                      username = if rawUser == "root" then "tu-usuario" else rawUser;
                      hostname = builtins.getEnv "HOSTNAME";
                      flake = builtins.getFlake "/home/${username}/home-flake";
                    in
                    flake.homeConfigurations."${username}@${hostname}".options
                  ]],
                },
                devenv = {
                  expr = [[
                    let
                      root = builtins.getEnv "DEVENV_ROOT";
                      devenv = import "${root}/.devenv/bootstrap/default.nix" {};
                    in
                    devenv.project.options
                ]],
                },

                ['config'] = {
                  expr = [[
                    let
                      rawUser = builtins.getEnv "USER";
                      username = if rawUser == "root" then "tu-usuario" else rawUser;
                      hostname = builtins.getEnv "HOSTNAME";
                      flake = builtins.getFlake "/home/${username}/home-flake";
                    in
                    flake.homeConfigurations."${username}@${hostname}".config.lib.stylix
                  ]],
                },
              },
            },
          },
        },
        clangd = {
          filetypes = { 'c', 'cpp' },
          cmd = { 'clangd', '--compile-commands-dir=build', '--clang-tidy' },
          on_attach = function(client, bufnr)
            client.server_capabilities.signatureHelpProvider = false
            -- LspOnAttach(client, bufnr)
          end,
          capabilities = capabilities,
        },
      }
      for k, s in pairs(servers) do
        vim.lsp.config(k, s)
        vim.lsp.enable(k)
      end

      -- lspconfig.marksman.setup {
      --   root_dir = lspconfig.util.root_pattern '.obsidian',
      --   settings = {},
      -- }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = 'InsertEnter',
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier' },
        xml = { 'xmlformatter' },
        xhtml = { 'prettierd' },
        go = { 'gofumpt' },
        json = { 'prettierd', 'prettier' },
        markdown = { 'cbfmt' },
        python = {},
        rust = { 'clippy' },
        cpp = { 'clang-format' },
        wgsl = { 'wgslfmt' },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
          },
        },
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
          require 'custom.snippets'
        end,
      },
      'saadparwaiz1/cmp_luasnip',

      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<C-y>'] = cmp.mapping.confirm { select = true },

          ['<C-Space>'] = cmp.mapping.complete {},

          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.jump(1)
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  {
    'echasnovski/mini.nvim',
    config = function()
      local spec_treesitter = require('mini.ai').gen_spec.treesitter
      require('mini.ai').setup {
        n_lines = 500,
        custom_textobjects = {
          F = spec_treesitter { a = '@function.outer', i = '@function.inner' },
          o = spec_treesitter {
            a = { '@conditional.outer', '@loop.outer' },
            i = { '@conditional.inner', '@loop.inner' },
          },
        },
      }

      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          -- check if parser exists and load it
          if not vim.treesitter.language.add(language) then
            return
          end
          -- enables syntax highlighting and other treesitter features
          vim.treesitter.start(buf, language)

          -- enables treesitter based folds
          -- for more info on folds see `:help folds`
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- vim.wo.foldmethod = 'expr'

          -- enables treesitter based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    import = 'kickstart.plugins.debug',
    -- require 'kickstart.plugins.indent_line',
    -- require 'kickstart.plugins.lint',
  },
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('x', '<leader>p', '"_dP')

vim.cmd 'filetype plugin on'
vim.filetype.add {
  extension = {
    ipynb = 'ipynb',
  },
}

-- Namespace único para extmarks (opcional)
local sig_ns = vim.api.nvim_create_namespace 'signature_help_ns'

-- Namespace único para extmarks (opcional)
local sig_ns = vim.api.nvim_create_namespace 'signature_help_ns'

-- Estado global del signature_help
local sig_state = {
  buf = nil,
  win = nil,
  signatures = {},
  idx = 0,
  row = nil,
  col = nil,
  bufnr = nil,
}

local function close_floating()
  if sig_state.win and vim.api.nvim_win_is_valid(sig_state.win) then
    vim.api.nvim_win_close(sig_state.win, true)
  end
  sig_state.win = nil
  sig_state.buf = nil
  sig_state.signatures = {}
  sig_state.idx = 0
end

local function cycle_signature()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]

  local clients = vim.lsp.get_clients { bufnr = bufnr }
  if #clients == 0 then
    return
  end
  local client = clients[1]

  -- Si el cursor o buffer cambió, cerramos el floating
  if sig_state.bufnr ~= bufnr or sig_state.row ~= row or sig_state.col ~= col then
    close_floating()
    sig_state.bufnr = bufnr
    sig_state.row = row
    sig_state.col = col
  end

  -- Si ya tenemos firmas, ciclar y actualizar floating
  if #sig_state.signatures > 0 then
    sig_state.idx = sig_state.idx + 1
    if sig_state.idx > #sig_state.signatures then
      sig_state.idx = 1
    end

    local label = sig_state.signatures[sig_state.idx].label
    label = label .. ' (' .. sig_state.idx .. '/' .. #sig_state.signatures .. ')'

    if not (sig_state.win and vim.api.nvim_win_is_valid(sig_state.win)) then
      sig_state.buf = vim.api.nvim_create_buf(false, true)
      sig_state.win = vim.api.nvim_open_win(sig_state.buf, false, {
        relative = 'cursor',
        row = 1,
        col = 0,
        width = #label,
        height = 1,
        style = 'minimal',
        border = 'rounded',
      })
    end

    -- Ajustar tamaño y contenido del floating
    vim.api.nvim_buf_set_lines(sig_state.buf, 0, -1, false, { label })
    vim.api.nvim_win_set_width(sig_state.win, #label)
    return
  end

  -- Si no tenemos firmas, hacer request al LSP
  local params = vim.lsp.util.make_position_params(nil, client.offset_encoding)
  client.request('textDocument/signatureHelp', params, function(err, result)
    if err or not result or not result.signatures or #result.signatures == 0 then
      return
    end

    sig_state.signatures = result.signatures
    sig_state.idx = 1
    local label = sig_state.signatures[sig_state.idx].label
    label = label .. ' (' .. sig_state.idx .. '/' .. #sig_state.signatures .. ')'

    sig_state.buf = vim.api.nvim_create_buf(false, true)
    sig_state.win = vim.api.nvim_open_win(sig_state.buf, false, {
      relative = 'cursor',
      row = 1,
      col = 0,
      width = #label,
      height = 1,
      style = 'minimal',
      border = 'rounded',
    })

    vim.api.nvim_buf_set_lines(sig_state.buf, 0, -1, false, { label })
  end, 0)
end

---clipboard
require('custom.clipboard_sync').setup()
---

-- Cerrar floating si el cursor se mueve
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  callback = close_floating,
})

-- Mapear en Insert y Visual
vim.keymap.set('i', '<C-S>', cycle_signature, { silent = true, noremap = true })
vim.keymap.set('v', '<C-S>', cycle_signature, { silent = true, noremap = true })
vim.keymap.set('n', '<C-S>', cycle_signature, { silent = true, noremap = true })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
