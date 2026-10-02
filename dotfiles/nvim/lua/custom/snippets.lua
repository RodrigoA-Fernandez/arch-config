local ls = require 'luasnip'

local s = ls.snippet
local d = ls.dynamic_node
local i = ls.insert_node
local t = ls.text_node
local extras = require 'luasnip.extras'
local fmt = require('luasnip.extras.fmt').fmt
local rep = extras.rep

local latex = {
  s('mk', {
    t '$',
    i(1),
    t '$ ',
    i(0),
  }),
  s('dm', {
    t '$$',
    i(1),
    t '$$',
    i(0),
  }),
  s('fraccion', {
    t '\\frac{',
    i(1),
    t '}{',
    i(2),
    t '}',
  }),

  s('bb', {
    t '\\mathbb{',
    i(1),
    t '}',
  }),

  s('sc', {
    t '\\mathscr{',
    i(1),
    t '}',
  }),

  s('bf', {
    t '\\mathbf{',
    i(1),
    t '}',
  }),
  s('cal', {
    t '\\mathcal{',
    i(1),
    t '}',
  }),

  s('ooo', { t '\\infty ' }),
  s('iff', { t '\\iff ' }),
  s('in', { t '\\in ' }),
  s('to', { t '\\to ' }),
  s('->', { t '\\to ' }),
  s('mapsto', { t '\\mapsto ' }),
  s('forall', { t '\\forall ' }),
  s('exists', { t '\\exists ' }),
  s('nabla', { t '\\nabla ' }),
  s('emptyset', { t '\\emptyset ' }),

  s('texto', { t '\\text{', i(1), t '} ', i(0) }),
  s('overline', { t '\\overline{', i(1), t '} ', i(0) }),
  s('interior', { t '\\mathring{', i(1), t '} ', i(0) }),

  -- Letras Griegas
  s('@a ', { t '\\alpha ' }),
  s('@A ', { t '\\alpha ' }),
  s('@b ', { t '\\beta ' }),
  s('@B ', { t '\\beta ' }),
  s('@c ', { t '\\chi ' }),
  s('@C ', { t '\\chi ' }),
  s('@g ', { t '\\gamma ' }),
  s('@G ', { t '\\Gamma ' }),
  s('@d ', { t '\\delta ' }),
  s('@D ', { t '\\Delta ' }),
  s('@e ', { t '\\epsilon ' }),
  s('@E ', { t '\\epsilon ' }),
  s(':e ', { t '\\varepsilon ' }),
  s(':E ', { t '\\varepsilon ' }),
  s('@i ', { t '\\iota ' }),
  s('@k ', { t '\\kappa ' }),
  s('@K ', { t '\\kappa ' }),
  s('@l ', { t '\\lambda ' }),
  s('@L ', { t '\\Lambda ' }),
  s('@m ', { t '\\mu ' }),
  s('@M ', { t '\\mu ' }),
  s('@o ', { t '\\omega ' }),
  s('@O ', { t '\\Omega ' }),
  s('@p ', { t '\\phi ' }),
  s('@P ', { t '\\Phi ' }),
  s(':p ', { t '\\varphi ' }),
  s(':P ', { t '\\varPhi ' }),
  s('@r ', { t '\\rho ' }),
  s('@R ', { t '\\rho ' }),
  s('@s ', { t '\\sigma ' }),
  s('@S ', { t '\\Sigma ' }),
  s('@T ', { t '\\Theta ' }),
  s('@t ', { t '\\theta ' }),
  s(':t ', { t '\\tau ' }),
  s('@z ', { t '\\zeta ' }),
  s('@Z ', { t '\\zeta ' }),

  --Conjuntos
  s('RR', { t '\\mathbb{R} ' }),
  s('PP', { t '\\mathbb{P} ' }),
  s('SS', { t '\\mathbb{S} ' }),
  s('QQ', { t '\\mathbb{Q} ' }),
  s('CC', { t '\\mathbb{C} ' }),
  s('NN', { t '\\mathbb{N} ' }),
  s('II', { t '\\mathbb{I} ' }),
  s('ZZ', { t '\\mathbb{Z} ' }),
  s('MM', { t '\\mathcal{M}_n(', i(1), t ') ' }),

  -- Operadores
  s('sum', { t '\\sum_{', i(1), t '}^{', i(2), t '}' }),
  s('prod', { t '\\prod_{', i(1), t '}^{', i(2), t '}' }),

  s('set', { t '\\{', i(1), t '\\}', i(0) }),
  s('suc', { t '\\{', i(1), t '_', i(2), t '\\}_{', rep(2), t '=', i(3), t '}^\\infty', i(0) }),
  s('bolaa', { t 'B(', i(1), t ';', i(2), t ')' }),
  s('bolac', { t '\\overline{B}(', i(1), t ';', i(2), t ')' }),
  s('ser', { t '\\sum_{n=', i(1), t '}^\\infty', i(0) }),
  s('avg', { t '\\langle ', i(1), t ' \\rangle', i(0) }),
  s('norma', { t '||', i(1), t '||', i(0) }),
  s('abs', { t '|', i(1), t '|', i(0) }),
  s('lim', { t '\\lim\\limits_{', i(1), t '\\to ', i(2), t '}', i(0) }),

  s('comb', { t '{{', i(1), t '}\\choose{', i(2), t '}}', i(0) }),

  s('=>', { t '\\implies ' }),
  s('rightsquigarrow', { t '\\rightsquigarrow ' }),
  s('cdot', { t '\\cdot ' }),
  s('circ', { t '\\circ ' }),
  s('times', { t '\\times ' }),
  s('cap', { t '\\cap ' }),
  s('cup', { t '\\cup ' }),

  --Relaciones
  s('neq', { t '\\neq ' }),
  s('leq', { t '\\leq ' }),
  s('<=', { t '\\leq ' }),
  s('geq', { t '\\geq ' }),
  s('>=', { t '\\geq ' }),
  s('normal', { t '\\lhd ' }),
  s('lhd', { t '\\lhd ' }),
  s('subset', { t '\\subset ' }),
  s('divide', { t '\\backslash ' }),

  s('sim', { t '\\sim ' }),
  s('simeq', { t '\\simeq ' }),
  s('congruente', { t '\\cong ' }),
  s('aprox', { t '\\approx ' }),

  -- Cursiva y negrita
  s('i', { t '*', i(1), t '*', i(0) }),
  s('b', { t '**', i(1), t '**', i(0) }),
  s('bi', { t '***', i(1), t '***', i(0) }),

  --Entornos
  s(
    'begin',
    fmt(
      [[
      \begin{{{}}}
        {}
      \end{{{}}}
      ]],
      {
        i(1),
        i(0),
        rep(1),
      },
      { repeat_duplicates = true }
    )
  ),

  s('inv', {
    t '^{-1}',
  }),
}

local function crearBloque(cad, name, vacio)
  if vacio == 1 then
    return s(
      '> ' .. name,
      fmt(
        [[
  > [!{}] {}
  > {}
  ]],
        { t(cad), i(1), i(0) }
      )
    )
  end
  return s(
    '> ' .. name,
    fmt(
      [[
  > [!{}] {} {}
  > {}
  ]],
      { t(cad), t(name), i(1), i(0) }
    )
  )
end

local md = {
  s(
    '> bloque',
    fmt(
      [[
  > [!{}] {}
  > {}
  ]],
      { i(1), i(2), i(0) }
    )
  ),
  crearBloque('definition', 'Definición', 1),
  crearBloque('proposition', 'Proposición', 0),
  crearBloque('theorem', 'Teorema', 0),
  crearBloque('corollary', 'Corolario', 0),
  crearBloque('proof', 'Demostración', 0),
  crearBloque('note', 'Nota', 0),
  crearBloque('example', 'Ejemplo', 0),
}

ls.add_snippets('markdown', latex)
ls.add_snippets('markdown', md)
ls.add_snippets('rmd', latex)
ls.add_snippets('latex', latex)
