

if exists('g:loaded_comment')
	finish
endif


let g:loaded_comment = 1

command! -range CommentText call comment#comment(<line1>, <line2>)


