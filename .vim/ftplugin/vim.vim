if has('folding')
   let customMarkerList = ['00_config.vim', '_vimrc', 'init.vim', 'utils.vim', 'statusline.vim']
   setlocal foldmethod=marker
   if index(customMarkerList, expand('%:t')) >= 0
      setlocal foldenable
      setlocal foldmarker=\[\|\|,\|\|\]                    "Set fold marker to something prettier
   else
      setlocal nofoldenable
      setlocal foldmarker&
   endif
endif

if has('localmap')
   if (expand('%:t') == '_vimrc')
      nnoremap <buffer> 'a 'azz
      nnoremap <buffer> 'f 'fzz
      nnoremap <buffer> 'v 'vzz
      nnoremap <buffer> 'm 'mzz
      nnoremap <buffer> 's 'szz
   endif
endif
