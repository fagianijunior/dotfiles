local ls = require("luasnip")

-- `Ctrl+K` no modo de inserção para expandir o snippet atual no cursor. 
vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
-- `Ctrl+L` nos modos de inserção e seleção de snippet para pular para o próximo ponto de parada (placeholder) dentro de um snippet expandido.
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
-- `Ctrl+J` nos modos de inserção e seleção de snippet para pular para o ponto de parada anterior dentro de um snippet expandido.
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
-- `Ctrl+E` nos modos de inserção e seleção de snippet. Se houver múltiplas opções (choices) em um ponto de parada, este mapeamento muda para a próxima opção disponível.
vim.keymap.set({"i", "s"}, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, {silent = true})


-- Exemplo: Carregar snippets de um arquivo local (se my_snippets.lua estiver no mesmo dir)
-- local my_snippets = require("my_snippets")
-- ls.add_snippets("lua", my_snippets) -- Adiciona snippets para o tipo de arquivo "lua"

-- Exemplo: Configurar para carregar snippets de um diretório (como ~/.config/nvim/snippets)
-- ls.config.setup {
--   store_snippets_in_file = "~/.config/nvim/snippets",
-- }

