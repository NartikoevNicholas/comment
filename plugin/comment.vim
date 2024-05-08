

if exists('g:loaded_comment')
	finish
endif


let g:loaded_comment = 1


command! CommentText '<,'> call comment#comment()
