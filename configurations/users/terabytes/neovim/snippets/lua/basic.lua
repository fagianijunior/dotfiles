local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

return {
  s("print", {
    t("print("),
    i(1, "argumentos"),
    t(")"),
    i(0),
  }),
  s("for", {
    t("for "),
    i(1, "variável"),
    t(" in "),
    i(2, "coleção"),
    t(" do\n"),
    i(0),
    t("\nend"),
  }),
  -- ... mais snippets para 'lua' ...
}

