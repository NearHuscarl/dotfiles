" TODO:
" beautify
" add color depend on scope
" add count?
"   called
"   call
" background color option

" call vimcallgraph#vimcallgraph#gen('vimcallgraph.vim_')

let s:vcg = {}
let s:options = []

let s:function_pattern = '^\s*fu\%[nction]!\?\s\+\([^(]\+\)('
let s:end_function_pattern = '^\s*endfu\%[nction]'
let s:function_call_pattern = '\(\h[#:.a-zA-Z0-9_{}]*\)('
let s:function_object_pattern = '^\([^.]\+\.\)'

function! vimcallgraph#vimcallgraph#gen(file) " {{{
	if executable('dot')
		let filename = fnamemodify(a:file, ':t:r')
		let dot_file = filename . '.dot'
		let png_file = filename . '.png'

		call writefile(s:parse(a:file), dot_file)
		call system('dot -Tpng ' . dot_file . ' -o ' . png_file)
		" call delete(dot_file)
	else
		echoerr 'dot command not found. Please install graphviz'
	endif
endfunction
" }}}

function! s:parse(file, ...)
	if a:0
		" user supplied options
		call extend(s:options, a:1)
	endif
	call s:prepare_output()
	let input = readfile(a:file)
	let curline = 0
	let eof = len(input)
	while curline < eof
		let line = input[curline]
		let curline += 1
		" skip blank & comment lines
		if s:is_blank_or_comment(line)
			continue
		else
			call s:process(line)
		endif
	endwhile
	return s:output()
endfunction

function! s:prepare_output()
	let s:function_stack = ['__GLOBAL__']  " global scope
	let s:functions = {}
	call s:add_function(s:top_function())
	" let s:current_object = ''
	let s:out = []
endfunction

function! s:add_function(name)
	let name = a:name
	if !has_key(s:functions, name)
		let s:functions[name] = []
	endif
endfunction

function! s:push_function(name)
	let name = a:name
	call add(s:function_stack, name)
	if match(name, s:function_object_pattern) != -1
		let s:current_object = matchlist(name, s:function_object_pattern)[1]
	endif
endfunction

function! s:top_function()
	return s:function_stack[-1]
endfunction

function! s:pop_function()
	call remove(s:function_stack, -1)
endfunction

function! s:is_blank_or_comment(line)
	return a:line =~ '^\s*\%("\|$\)'
endfunction

function! s:process(line)
	" TODO: strip out actual comments
	let line = a:line
	let new_function = ''
	if match(line, s:function_pattern) != -1
		let new_function = matchlist(line, s:function_pattern)[1]
		call s:add_function(new_function)
	elseif match(line, s:end_function_pattern) != -1
		call s:pop_function()
	else
		call s:collect_function_calls(line)
	endif
	if new_function != ''
		call s:push_function(new_function)
	endif
endfunction

function! s:collect_function_calls(line)
	let line = a:line
	while match(line, s:function_call_pattern) != -1
		let name = matchlist(line, s:function_call_pattern)[1]
		" TODO: hack - collect the self -> dict from the top_function()
		" let name = substitute(name, 'self\.', 'sin.', 'g')
		if match(name, 'self\.') != -1
			let name = substitute(name, 'self\.', s:current_object, 'g')
		endif
		call s:add_function_call(name)
		let line = substitute(line, s:function_call_pattern, '', '')
	endwhile
endfunction

function! s:add_function_call(name)
	let name = a:name
	call add(s:functions[s:top_function()], name)
endfunction

function! s:output()
	let output = [
				\ 'digraph V {',
				\ 'node [shape=box, style=filled]'
				\ ]
	for [func_name, func_call_list] in items(s:functions)
		for func_call in func_call_list
			if index(s:vim_functions, func_call) == -1
				call add(output, '"' . func_name . '" -> "' . func_call . '";')
			endif
		endfor
	endfor
	call add(output, '}')
	return output
endfunction

" long-ass list so put it here
let s:vim_functions = [
			\     'abs',
			\     'acos',
			\     'add',
			\     'and',
			\     'append',
			\     'append',
			\     'argc',
			\     'argidx',
			\     'arglistid',
			\     'argv',
			\     'argv',
			\     'assert_equal',
			\     'assert_exception',
			\     'assert_fails',
			\     'assert_false',
			\     'assert_inrange',
			\     'assert_match',
			\     'assert_notequal',
			\     'assert_notmatch',
			\     'assert_report',
			\     'assert_true',
			\     'asin',
			\     'atan',
			\     'atan2',
			\     'balloon_show',
			\     'balloon_split',
			\     'browse',
			\     'browsedir',
			\     'bufexists',
			\     'buflisted',
			\     'bufloaded',
			\     'bufname',
			\     'bufnr',
			\     'bufwinid',
			\     'bufwinnr',
			\     'byte2line',
			\     'byteidx',
			\     'byteidxcomp',
			\     'call',
			\     'ceil',
			\     'ch_canread',
			\     'ch_close',
			\     'ch_close_in',
			\     'ch_evalexpr',
			\     'ch_evalraw',
			\     'ch_getbufnr',
			\     'ch_getjob',
			\     'ch_info',
			\     'ch_log',
			\     'ch_logfile',
			\     'ch_open',
			\     'ch_read',
			\     'ch_readraw',
			\     'ch_sendexpr',
			\     'ch_sendraw',
			\     'ch_setoptions',
			\     'ch_status',
			\     'changenr',
			\     'char2nr',
			\     'cindent',
			\     'clearmatches',
			\     'col',
			\     'complete',
			\     'complete_add',
			\     'complete_check',
			\     'confirm',
			\     'copy',
			\     'cos',
			\     'cosh',
			\     'count',
			\     'cscope_connection',
			\     'cursor',
			\     'cursor',
			\     'deepcopy',
			\     'delete',
			\     'did_filetype',
			\     'diff_filler',
			\     'diff_hlID',
			\     'empty',
			\     'escape',
			\     'eval',
			\     'eventhandler',
			\     'executable',
			\     'execute',
			\     'exepath',
			\     'exists',
			\     'extend',
			\     'exp',
			\     'expand',
			\     'feedkeys',
			\     'filereadable',
			\     'filewritable',
			\     'filter',
			\     'finddir',
			\     'findfile',
			\     'float2nr',
			\     'floor',
			\     'fmod',
			\     'fnameescape',
			\     'fnamemodify',
			\     'foldclosed',
			\     'foldclosedend',
			\     'foldlevel',
			\     'foldtext',
			\     'foldtextresult',
			\     'foreground',
			\     'funcref',
			\     'function',
			\     'garbagecollect',
			\     'get',
			\     'get',
			\     'get',
			\     'getbufinfo',
			\     'getbufline',
			\     'getbufvar',
			\     'getchar',
			\     'getcharmod',
			\     'getcharsearch',
			\     'getcmdline',
			\     'getcmdpos',
			\     'getcmdtype',
			\     'getcmdwintype',
			\     'getcompletion',
			\     'getcurpos',
			\     'getcwd',
			\     'getfontname',
			\     'getfperm',
			\     'getfsize',
			\     'getftime',
			\     'getftype',
			\     'getline',
			\     'getline',
			\     'getloclist',
			\     'getmatches',
			\     'getpid',
			\     'getpos',
			\     'getqflist',
			\     'getreg',
			\     'getregtype',
			\     'gettabinfo',
			\     'gettabvar',
			\     'gettabwinvar',
			\     'getwininfo',
			\     'getwinposx',
			\     'getwinposy',
			\     'getwinvar',
			\     'glob',
			\     'glob2regpat',
			\     'globpath',
			\     'has',
			\     'has_key',
			\     'haslocaldir',
			\     'hasmapto',
			\     'histadd',
			\     'histdel',
			\     'histget',
			\     'histnr',
			\     'hlexists',
			\     'hlID',
			\     'hostname',
			\     'iconv',
			\     'indent',
			\     'index',
			\     'input',
			\     'inputdialog',
			\     'inputlist',
			\     'inputrestore',
			\     'inputsave',
			\     'inputsecret',
			\     'insert',
			\     'invert',
			\     'isdirectory',
			\     'islocked',
			\     'isnan',
			\     'items',
			\     'job_getchannel',
			\     'job_info',
			\     'job_setoptions',
			\     'job_start',
			\     'job_status',
			\     'job_stop',
			\     'join',
			\     'js_decode',
			\     'js_encode',
			\     'json_decode',
			\     'json_encode',
			\     'keys',
			\     'len',
			\     'libcall',
			\     'libcallnr',
			\     'line',
			\     'line2byte',
			\     'lispindent',
			\     'localtime',
			\     'log',
			\     'log00',
			\     'luaeval',
			\     'map',
			\     'maparg',
			\     'mapcheck',
			\     'match',
			\     'matchadd',
			\     'matchaddpos',
			\     'matcharg',
			\     'matchdelete',
			\     'matchend',
			\     'matchlist',
			\     'matchstr',
			\     'matchstrpos',
			\     'max',
			\     'min',
			\     'mkdir',
			\     'mode',
			\     'mzeval',
			\     'nextnonblank',
			\     'nr0char',
			\     'or',
			\     'pathshorten',
			\     'perleval',
			\     'pow',
			\     'prevnonblank',
			\     'printf',
			\     'pumvisible',
			\     'pyeval',
			\     'py0eval',
			\     'pyxeval',
			\     'range',
			\     'readfile',
			\     'reltime',
			\     'reltimefloat',
			\     'reltimestr',
			\     'remote_expr',
			\     'remote_foreground',
			\     'remote_peek',
			\     'remote_read',
			\     'remote_send',
			\     'remote_startserver',
			\     'remove',
			\     'remove',
			\     'rename',
			\     'repeat',
			\     'resolve',
			\     'reverse',
			\     'round',
			\     'screenattr',
			\     'screenchar',
			\     'screencol',
			\     'screenrow',
			\     'search',
			\     'searchdecl',
			\     'searchpair',
			\     'searchpairpos',
			\     'searchpos',
			\     'server2client',
			\     'serverlist',
			\     'setbufline',
			\     'setbufvar',
			\     'setcharsearch',
			\     'setcmdpos',
			\     'setfperm',
			\     'setline',
			\     'setloclist',
			\     'setmatches',
			\     'setpos',
			\     'setqflist',
			\     'setreg',
			\     'settabvar',
			\     'settabwinvar',
			\     'setwinvar',
			\     'sha-256',
			\     'shellescape',
			\     'shiftwidth',
			\     'simplify',
			\     'sin',
			\     'sinh',
			\     'sort',
			\     'soundfold',
			\     'spellbadword',
			\     'spellsuggest',
			\     'split',
			\     'sqrt',
			\     'str-3float',
			\     'str-4nr',
			\     'strchars',
			\     'strcharpart',
			\     'strdisplaywidth',
			\     'strftime',
			\     'strgetchar',
			\     'stridx',
			\     'string',
			\     'strlen',
			\     'strpart',
			\     'strridx',
			\     'strtrans',
			\     'strwidth',
			\     'submatch',
			\     'substitute',
			\     'synID',
			\     'synIDattr',
			\     'synIDtrans',
			\     'synconcealed',
			\     'synstack',
			\     'system',
			\     'systemlist',
			\     'tabpagebuflist',
			\     'tabpagenr',
			\     'tabpagewinnr',
			\     'taglist',
			\     'tagfiles',
			\     'tan',
			\     'tanh',
			\     'tempname',
			\     'term_getaltscreen',
			\     'term_getattr',
			\     'term_getcursor',
			\     'term_getjob',
			\     'term_getline',
			\     'term_getscrolled',
			\     'term_getsize',
			\     'term_getstatus',
			\     'term_gettitle',
			\     'term_gettty',
			\     'term_list',
			\     'term_scrape',
			\     'term_sendkeys',
			\     'term_start',
			\     'term_wait',
			\     'test_alloc_fail',
			\     'test_autochdir',
			\     'test_feedinput',
			\     'test_garbagecollect_now',
			\     'test_ignore_error',
			\     'test_null_channel',
			\     'test_null_dict',
			\     'test_null_job',
			\     'test_null_list',
			\     'test_null_partial',
			\     'test_null_string',
			\     'test_override',
			\     'test_settime',
			\     'timer_info',
			\     'timer_pause',
			\     'timer_start',
			\     'timer_stop',
			\     'timer_stopall',
			\     'tolower',
			\     'toupper',
			\     'tr',
			\     'trunc',
			\     'type',
			\     'undofile',
			\     'undotree',
			\     'uniq',
			\     'values',
			\     'virtcol',
			\     'visualmode',
			\     'wildmenumode',
			\     'win_findbuf',
			\     'win_getid',
			\     'win_gotoid',
			\     'win_id2tabwin',
			\     'win_id2win',
			\     'win_screenpos',
			\     'winbufnr',
			\     'wincol',
			\     'winheight',
			\     'winline',
			\     'winnr',
			\     'winrestcmd',
			\     'winrestview',
			\     'winsaveview',
			\     'winwidth',
			\     'wordcount',
			\     'writefile',
			\     'xor',
			\ ]
