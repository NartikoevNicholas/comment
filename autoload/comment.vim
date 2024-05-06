let s:extentions = {
        \'vim':         '"',
        \'php':         '//', 
        \'sql':         '--', 
        \'py':          '#',
        \'.vimrc':      '"'
\}


function! comment#comment()
	if !exists('g:comment')
		let extention = expand('%:e') ?? expand('%')
		if !has_key(s:extentions, extention) 
			echo 'not found extention ' . extention 
			return 
		endif
		let g:comment = v:true
		let is_comment = v:false
		let ext = s:extentions[extention]
		for n in range(a:firstline, a:lastline)
			if ext != trim(getline(n))[0] && ext != trim(getline(n))[:1]
				let is_comment = v:true
				break
			endif
		endfor
		for n in range(a:firstline, a:lastline)
			call setline(n, is_comment ? ext . getline(n) : substitute(getline(n), ext, '', ''))
		endfor
	endif

	if line('.') == a:lastline
		if exists('g:comment_direction') && a:firstline < g:comment_direction[1]
			let g:comment_direction[1] = a:firstline - 1
			call setpos('.', g:comment_direction)
		else
			let cur_pos = getcurpos()
			let cur_pos[1] += 1
			call setpos('.', cur_pos)
		endif
		unlet g:comment
	endif
endfunction

augroup VisualEvent
	autocmd!
	autocmd ModeChanged *:[vV\x16]* let g:comment_direction = getcurpos()
augroup END

