return {
  {
    'Hoffs/omnisharp-extended-lsp.nvim',
    config = function()
      vim.keymap.set('n', 'gr', function()
        require('omnisharp_extended').telescope_lsp_references(require('telescope.themes').get_ivy { excludeDefinition = true })
      end, { noremap = true })
      vim.keymap.set('n', 'gd', require('omnisharp_extended').telescope_lsp_definition, { noremap = true })
      vim.keymap.set('n', '<leader>D', function()
        require('omnisharp_extended').telescope_lsp_references()
      end, { noremap = true })
      vim.keymap.set('n', 'gi', require('omnisharp_extended').telescope_lsp_implementation, { noremap = true })
      local pid = vim.fn.getpid()
      local config = {
        cmd = { 'OmniSharp', '--languageserver', '--hostPID', tostring(pid) },
        root_dir = require('lspconfig').util.root_pattern '.git',
        flags = {
          debounce_text_changes = 150,
        },
        settings = {
          FormattingOptions = {
            -- Enables support for reading code style, naming convention and analyzer
            -- settings from .editorconfig.
            EnableEditorConfigSupport = true,
            -- Specifies whether 'using' directives should be grouped and sorted during
            -- document formatting.
            OrganizeImports = true,
            NewLinesForBracesInControlBlocks = false,
          },
          MsBuild = {
            -- If true, MSBuild project system will only load projects for files that
            -- were opened in the editor. This setting is useful for big C# codebases
            -- and allows for faster initialization of code navigation features only
            -- for projects that are relevant to code that is being edited. With this
            -- setting enabled OmniSharp may load fewer projects and may thus display
            -- incomplete reference lists for symbols.
            LoadProjectsOnDemand = nil,
          },
          RoslynExtensionsOptions = {
            -- Enables support for roslyn analyzers, code fixes and rulesets.
            EnableAnalyzersSupport = true,
            -- Enables support for showing unimported types and unimported extension
            -- methods in completion lists. When committed, the appropriate using
            -- directive will be added at the top of the current file. This option can
            -- have a negative impact on initial completion responsiveness,
            -- particularly for the first few completion sessions after opening a
            -- solution.
            EnableImportCompletion = true,
            -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
            -- true
            AnalyzeOpenDocumentsOnly = nil,
          },
          Sdk = {
            -- Specifies whether to include preview versions of the .NET SDK when
            -- determining which version to use for project loading.
            IncludePrereleases = true,
          },
        },
      }
      vim.lsp.config('omnisharp', config)
    end,
  },
}
