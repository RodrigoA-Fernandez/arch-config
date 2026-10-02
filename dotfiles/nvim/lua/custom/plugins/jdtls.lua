return {
  "mfussenegger/nvim-jdtls",
  ft = "java",  -- solo carga para archivos Java
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    local jdtls = require("jdtls")
    local config = {
      cmd = { "jdtls" },
      root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
      settings = { java = {} },
      init_options = { bundles = {} },
    }
    jdtls.start_or_attach(config)

    vim.keymap.set("n", "<leader>co", jdtls.organize_imports, { desc = "Organize Imports" })
    vim.keymap.set("n", "<leader>crv", jdtls.extract_variable, { desc = "Extract Variable" })
    vim.keymap.set("v", "<leader>crv", function() jdtls.extract_variable(true) end)
    vim.keymap.set("n", "<leader>crc", jdtls.extract_constant, { desc = "Extract Constant" })
    vim.keymap.set("v", "<leader>crc", function() jdtls.extract_constant(true) end)
    vim.keymap.set("v", "<leader>crm", function() jdtls.extract_method(true) end)
    vim.keymap.set("n", "<leader>d", function() jdtls.extract_method(true) end)
  end,
}
