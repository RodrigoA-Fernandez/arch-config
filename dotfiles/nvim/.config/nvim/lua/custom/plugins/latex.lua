return {
  {
    'lervag/vimtex',
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      vim.g.vimtex_view_method = 'sioyek'
      vim.g.vimtex_compiler_latexmk = {
        options = { '-shell-escape' },
      }
      local config = {
        filetypes = { 'tex' },
        on_attach = function(client, bufnr) end,
        capabilities = capabilities,
        cmd = { 'texlab', '-vvvv', '--log-file', '/tmp/texlab.log' },
      }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'tex',
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.spelllang = 'es'
          local lsp_config = vim.lsp.config('texlab', config)
          vim.lsp.start(config)
        end,
      })
    end,
  },
}
