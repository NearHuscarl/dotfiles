function! origin#init()
	let vcg = {}
	let vcg.function_pattern = '^\s*fu\%[nction]!\?\s\+\([^(]\+\)('
	let vcg.end_function_pattern = '^\s*endfu\%[nction]'
	let vcg.function_call_pattern = '\(\h[#.a-zA-Z0-9_{}]\+\)('
	let vcg.function_object_pattern = '^\([^.]\+\.\)'
	let vcg.vim_functions = [
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

	func vcg.parse(file, ...) dict
		if a:0
			" user supplied options
			call extend(self.options, a:1)
		endif
		call self.prepare_output()
		" Allow a list as argument
		let self.input = type(a:file) == type('') ? readfile(a:file) : a:file
		let self.curline = 0
		let self.eof = len(self.input)
		while self.curline < self.eof
			let line = self.input[self.curline]
			let self.curline += 1
			" skip blank & comment lines
			if self.is_blank_or_comment(line)
				continue
			else
				call self.process(line)
			endif
		endwhile
		return self.output()
	endfunc

	func vcg.prepare_output() dict
		let self.function_stack = ['__GLOBAL__']  " global scope
		let self.functions = {}
		call self.add_function(self.top_function())
		" let self.current_object = ''
		let self.out = []
	endfunc

	func vcg.add_function(name) dict
		let name = a:name
		if ! has_key(self.functions, name)
			let self.functions[name] = []
		endif
	endfunc

	func vcg.push_function(name) dict
		let name = a:name
		call add(self.function_stack, name)
		echo 'name=' . name
		if match(name, self.function_object_pattern) != -1
			echo 'name=' . name
			let self.current_object = matchlist(name, self.function_object_pattern)[1]
		endif
	endfunc

	func vcg.top_function() dict
		if len(self.function_stack) > 1
			return self.function_stack[-1]
		else
			return self.function_stack[0]
		endif
	endfunc

	func vcg.pop_function() dict
		" if len(self.function_stack) > 1
		call remove(self.function_stack, -1)
		" endif
	endfunc

	func vcg.is_blank_or_comment(line)
		return a:line =~ '^\s*\%("\|$\)'
	endfunc

	func vcg.process(line) dict
		" TODO: strip out actual comments
		let line = a:line
		let new_function = ''
		if match(line, self.function_pattern) != -1
			let new_function = matchlist(line, self.function_pattern)[1]
			call self.add_function(new_function)
		elseif match(line, self.end_function_pattern) != -1
			call self.pop_function()
		endif
		call self.collect_function_calls(line)
		if new_function != ''
			call self.push_function(new_function)
		endif
	endfunc

	func vcg.collect_function_calls(line) dict
		let line = a:line
		while match(line, self.function_call_pattern) != -1
			let name = matchlist(line, self.function_call_pattern)[1]
			" TODO: hack - collect the self -> dict from the top_function()
			" let name = substitute(name, 'self\.', 'sin.', 'g')
			if match(name, 'self\.') != -1
				let name = substitute(name, 'self\.', self.current_object, 'g')
			endif
			call self.add_function_call(name)
			let line = substitute(line, self.function_call_pattern, '', '')
		endwhile
	endfunc

	func vcg.add_function_call(name) dict
		let name = a:name
		call add(self.functions[self.top_function()], name)
	endfunc

	func vcg.output() dict
		let output = ['digraph V {', 'rankdir=LR']
		for [fn, fcs] in items(self.functions)
			for fc in fcs
				if index(self.vim_functions, fc) == -1
					call add(output, '"' . fn . '" -> "' . fc . '";')
				endif
			endfor
		endfor
		call add(output, '}')
		return output
	endfunc

	return vcg
endfunction

" finish
" test
" let vcg = origin#init()
" call writefile(vcg.parse('source.vim'), 'source_.dot')
