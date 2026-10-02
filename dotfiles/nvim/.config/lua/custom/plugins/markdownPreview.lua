return{{
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown' },
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,
  config = function()
    vim.g['mkdp_preview_options'].katex = {
      macros = {
        ['\\R'] = '\\mathbb{R}',
      },
    }
    vim.g['mkdp_auto_start'] = 1
    vim.g['mkdp_auto_close'] = 0
  end,
},
}