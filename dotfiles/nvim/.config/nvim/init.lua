package.path = "/nix/store/dsm1paqxc186vn68n34n78xbm8dybijn-luajit-2.1.1785763465-env/share/lua/5.1/?.lua;/nix/store/dsm1paqxc186vn68n34n78xbm8dybijn-luajit-2.1.1785763465-env/share/lua/5.1/?/init.lua".. ";" .. package.path
package.cpath = "/nix/store/dsm1paqxc186vn68n34n78xbm8dybijn-luajit-2.1.1785763465-env/lib/lua/5.1/?.so".. ";" .. package.cpath

vim.g.loaded_node_provider=0;vim.g.loaded_perl_provider=0;vim.g.loaded_ruby_provider=0;vim.g.loaded_python3_provider=0
package.path = "/home/rodrigo/.config/nvim/?.lua;" .. package.path;
require("old_init")

-- user-associated plugin config {{{
require('mini.base16').setup({
  palette = {
    base00 = '#1d2021', base01 = '#3c3836', base02 = '#504945', base03 = '#665c54',
    base04 = '#bdae93', base05 = '#d5c4a1', base06 = '#ebdbb2', base07 = '#fbf1c7',
    base08 = '#fb4934', base09 = '#fe8019', base0A = '#fabd2f', base0B = '#b8bb26',
    base0C = '#8ec07c', base0D = '#83a598', base0E = '#d3869b', base0F = '#d65d0e'
  }
})



-- }}}
