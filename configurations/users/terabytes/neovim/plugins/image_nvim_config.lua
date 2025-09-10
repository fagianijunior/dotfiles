-- ./plugins/image_nvim_config.lua
-- Configuração para 3rd/image.nvim

require('image').setup({
  -- Exemplo de configurações:
  -- WezTerm geralmente não precisa de 'ueberzugpp' e pode usar o backend nativo.
  -- No entanto, ter o 'ueberzugpp' no path pode ser útil para compatibilidade.
  -- backend = "ueberzugpp", -- Explicitamente dizer para usar o backend do WezTerm
  
  delay_update = 500, -- Experimente 500ms ou até 1000ms (1 segundo)

  -- Adicione delay_redraw: Isso introduz um atraso antes que o Neovim redesenhe a tela,
  -- dando mais tempo para a imagem aparecer e permanecer.
  delay_redraw = 100, -- Experimente 50ms, 100ms ou 200ms

  -- Ative o modo de depuração para ver mensagens úteis (depois pode desativar)
  debug = true,

  -- Se você quiser definir diretórios específicos para visualização:
  -- file_types = { "png", "jpg", "jpeg", "gif", "svg" },
  -- max_width = 80, -- Largura máxima da imagem em colunas do terminal
  -- max_height = 30, -- Altura máxima da imagem em linhas do terminal

  -- Comandos para abrir e fechar a visualização (personalize se quiser)
  -- keymaps = {
  --   toggle = "<leader>it", -- Toggle image preview
  --   fit_width = "<leader>iw", -- Fit image to width
  --   fit_height = "<leader>ih", -- Fit image to height
  -- },

  -- Você pode adicionar mais opções aqui conforme a documentação do 3rd/image.nvim
  -- Consulte: https://github.com/3rd/image.nvim#configuration
})

-- Mapeamentos de teclado básicos (exemplo, você pode personalizar)
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.svg" },
  callback = function()
    -- Este comando tenta exibir a imagem ao abrir o buffer ou segurar o cursor
    -- A primeira vez que você abrir um arquivo de imagem, pode precisar de :ImageToggle
    -- ou configurar um autocomando mais agressivo se quiser pré-visualizar instantaneamente.
    -- require('image').toggle_file()
  end,
})

-- Sugestão de um mapeamento de teclado para alternar a visualização manualmente
-- Você pode adicionar isso no seu nvim-cmp_config.lua ou similar se preferir
vim.keymap.set("n", "<leader>ii", function()
  require("image").toggle()
end, { desc = "Toggle Image Preview" })
