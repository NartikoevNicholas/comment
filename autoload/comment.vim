let s:extentions = {
	\'vim':		['"', '"'],
	\'.vimrc':	['"', '"'],
	\'sql':		['-- ', '-- '],
	\'py':		['#', '#'],
	\'html':	['<!--', '-->', '<!--', '-->$'],
	\'css':		['/*', '*/', '/\*', '*/$'],
	\'php':		['//', '//'],
	\'js':		['//', '//'],
	\'cpp':		['//', '//'],
	\'cs':		['//', '//']	
\}


function! s:is_comment(start_line, end_line, extention)
	for n in range(a:start_line, a:end_line) 
		if a:extention != trim(getline(n))[:len(a:extention) - 1] 
			return v:true
		endif
	endfor
	return v:false
endfunction


function! comment#comment(...)
	let extention = expand('%:e') ?? expand('%:t')
	if !has_key(s:extentions, extention) 
		echo 'Extention not found ' . '"' . extention . '". Need add extention in array.' 
		return 
	endif
		
	let ext = s:extentions[extention]
	if len(ext) == 2
		let is_comment = s:is_comment(a:1, a:2, ext[0])
		for n in range(a:1, a:2)
			if is_comment
				call setline(n, ext[0] . getline(n))
			else
				call setline(n, substitute(getline(n), ext[1], '', ''))
			endif
		endfor
	else
		let is_comment = s:is_comment(a:1, a:2, ext[0])
		for n in range(a:1, a:2)
			if is_comment
				call setline(n, ext[0] . getline(n) . ext[1])
			else
				call setline(n, substitute(substitute(getline(n), ext[2], '', ''), ext[3], '', ''))
			endif
		endfor
	endif

"	set cursor position
	if exists('g:comment_direction')
		if a:1 < g:comment_direction[1]
			let g:comment_direction[1] = a:1 - 1
			call setpos('.', g:comment_direction)
		else
			let g:comment_direction[1] = a:2 + 1
			call setpos('.', g:comment_direction)
		endif
		unlet g:comment_direction
	else
		let cur_pos = getcurpos()
		let cur_pos[1] += 1
		call setpos('.', cur_pos) 	
	endif
endfunction


augroup VisualEvent
	autocmd!
	autocmd ModeChanged *:[vV\x16]* let g:comment_direction = getcurpos()
augroup END

