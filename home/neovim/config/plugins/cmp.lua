-- Completion Configuration with nvim-cmp
-- Requirements: 4.2

local cmp = require('cmp')
local luasnip = require('luasnip')

-- Setup nvim-cmp
cmp.setup({
  -- Snippet engine configuration
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  
  -- Window appearance
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  
  -- Keybindings for completion
  -- Requirements: 4.2 (Tab, S-Tab, CR, C-Space)
  mapping = cmp.mapping.preset.insert({
    -- Tab: Select next item or expand snippet
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    
    -- Shift-Tab: Select previous item or jump back in snippet
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    
    -- Enter: Confirm selection
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    
    -- Ctrl-Space: Trigger completion manually
    ['<C-Space>'] = cmp.mapping.complete(),
    
    -- Additional useful mappings
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
  }),
  
  -- Completion sources
  -- Requirements: 4.2 (LSP, snippets, buffer, path)
  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 1000 },  -- LSP completion (highest priority)
    { name = 'luasnip', priority = 750 },    -- Snippet completion
    { name = 'buffer', priority = 500 },     -- Buffer completion
    { name = 'path', priority = 250 },       -- Path completion
  }),
  
  -- Formatting for completion menu
  formatting = {
    format = function(entry, vim_item)
      -- Add source name to completion items
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
      })[entry.source.name]
      return vim_item
    end,
  },
  
  -- Experimental features
  experimental = {
    ghost_text = true,  -- Show ghost text for completion
  },
})

-- Set up completion for command line
-- This provides intelligent autocompletion when you type ":" or "/"
-- Press Tab or Ctrl-n/Ctrl-p to navigate through suggestions
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
