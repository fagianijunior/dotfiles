
let g:vimtex_view_method = 'zathura'
autocmd User VimtexEventQuit VimtexClean
nnoremap <F4> :NvimTreeToggle<CR>
nnoremap <F5> :VimtexCompile<CR>
nnoremap <F6> :VimtexStop<CR>:VimtexClean<CR>
