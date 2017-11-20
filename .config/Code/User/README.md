## Vim Equivalent key bindings:

```vim
" Movement
nnoremap ;  :
nnoremap h  ,
nnoremap l  ;
nnoremap gh h
nnoremap gl l
nnoremap J  jjjjjjjjjjzz
nnoremap K  kkkkkkkkkkzz
nnoremap L  jjjjjjjjjjjjjjjjjjjjzz
nnoremap H  kkkkkkkkkkkkkkkkkkkkzz

nnoremap U <C-r>
nnoremap <Leader>v <C-v>

" Jump back/forward
nnoremap [j <C-o>
nnoremap ]j <C-i>

" Switching between windows
nnoremap , workbench.action.previousEditor
nnoremap . workbench.action.nextEditor

" Debug mappings
nnoremap <CR>         editor.debug.action.toggleBreakpoint
nnoremap <Leader><CR> editor.debug.action.conditionalBreakpoint
nnoremap <Leader>s    workbench.action.debug.start
nnoremap <Leader>S    workbench.action.debug.stop
nnoremap <Leader>r    workbench.action.debug.restart
nnoremap <Leader>i    workbench.action.debug.stepInto
nnoremap <Leader>o    workbench.action.debug.stepOut
nnoremap s            workbench.action.debug.stepOver
nnoremap <Leader>c    workbench.action.debug.continue
nnoremap <Leader>C    editor.debug.action.runToCursor
nnoremap <Leader>w    editor.debug.action.selectionToWatch

" Misc
nnoremap -         workbench.action.files.save
nnoremap <Leader>f workbench.action.toggleFullScreen

nnoremap <Leader><Leader>s workbench.action.openGlobalSettings
nnoremap <Leader><Leader>k workbench.action.openGlobalKeybindings

" Insert mappings
inoremap <Leader>i <Esc>
```
