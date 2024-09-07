" Environment Variables {{{
let $RTP=split(&runtimepath, ',')[0]
let $VIMRC="$HOME/.vim/vimrc"
" }}}

" Basics {{{
filetype plugin indent on           " Add filetype, plugin, and indent support
syntax on                           " Turn on syntax highlighting
"}}}

" Settings {{{
set backspace=start,eol,indent      " Backspace everything in insert mode
set tabstop=4                       " tabstop:	width of tab character
set softtabstop=4                   " softtabstop:	fine tunes the amount of whitespace to be added
set shiftwidth=4                    " shiftwidth:	determines the amount of whitespace to add in normal mode
set expandtab                       " expandtab:	when on use space instead of tab
set autoindent                      " autoindent:	autoindent in new line
set smartindent                     " enable mouse support 
set relativenumber
set mouse=a                         " enable mouse
set number                          " enable line numbers
set laststatus=2
set path=.,**                       " Relative to current file and everything under :pwd
set wildignore=**/node_modules/**,**/dist/**,*.pyc
set wildmenu                        " Display matches in command-line mode
set hidden                          " Prefer hiding over unloading buffers
set noswapfile                      " Disables swapfiles
set cursorline                      " highlight current line 
:highlight Cursorline cterm=bold ctermbg=black
set hlsearch                        " enable highlight search pattern 
set ignorecase                      " enable smartcase search sensitivity 
set smartcase
set showmatch                       " show the matching part of pairs [] {} and () "
set noshowmode                      " Don't show mode like --INSERT-- in current statusline.
"}}}

" Colorscheme{{{
if !has('gui_running')              " enable color themes "
	set t_Co=256
endif
set termguicolors                   " enable true colors support "
colorscheme onedark                 " Vim colorscheme "
"}}}

" statusline{{{
let g:colorGreen  = "#2BBB4F"
let g:colorBlue   = "#4799EB"
let g:colorViolet = "#986FEC"
let g:colorYellow = "#D7A542"
let g:colorOrange = "#EB754D"
 
let g:colorLight  = "#C0C0C0"
let g:colorDark   = "#080808"
let g:colorDark1  = "#181818"
let g:colorDark2  = "#202020"
let g:colorDark3  = "#303030"


function! GetGitBranchName()
    if executable('git')
        let l:branchname = trim(system("git symbolic-ref --quiet --short HEAD 2>/dev/null || git describe --all --exact-match HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo ''"))
        if !empty(l:branchname)
            let b:gitbranchname = l:branchname
        else
            let b:gitbranchname = 'No-Branch'
        endif
    else
        let b:gitbranchname = 'No-Git'
    endif
endfunction


function! GetGitStatus()
    let b:gitstatus = '['
    " Check for uncommitted changes in the index
    let l:index_diff = system('git diff --quiet --ignore-submodules --cached')
    if l:index_diff != 0
        let b:gitstatus .= '+'
    endif

    " Check for unstaged changes
    let l:unstaged_diff = system('git diff-files --quiet --ignore-submodules --')
    if l:unstaged_diff != 0
        let b:gitstatus .= '!'
    endif

    " Check for untracked files
    let l:untracked_files = system('git ls-files --others --exclude-standard')
    if !empty(l:untracked_files)
        let b:gitstatus .= '?'
    endif

    " Check for stashed files
    let l:stashed_files = system('git rev-parse --verify refs/stash &>/dev/null')
    if !empty(l:stashed_files)
        let b:gitstatus .= '$'
    endif
    let b:gitstatus .= ']'
    return b:gitstatus
endfunction


" Execute function once and store variable in buffer
augroup GetGitBranchName
    autocmd!
    autocmd BufEnter * call GetGitBranchName()
augroup END

autocmd VimResized * wincmd =		" Automatically resize windows when Vim is resized

"augroup GetGitStatus
"    autocmd!
"    autocmd BufEnter * call GetGitStatus()
"augroup END


" Define highlight based on color palett
" pretty mode display - converts the one letter status notifiers to words
function! Mode()
    redraw
    let l:mode = mode()
	
	exec 'hi GitBranchHighlight guifg=' . g:colorLight ' guibg=' . g:colorDark2

    if     mode ==# "n"
	exec 'hi ModeHighlight guifg=' . g:colorDark ' guibg=' . g:colorGreen
    exec 'hi ModeHighlight2 guifg=' . g:colorGreen ' guibg=' . g:colorDark2
    exec 'hi ModeHighlight3 guifg=' . g:colorLight ' guibg=' . g:colorDark2 ' gui=bold'
	return "NORMAL "

    elseif mode ==# "i"
	exec 'hi ModeHighlight guifg=' . g:colorDark ' guibg=' . g:colorViolet
    exec 'hi ModeHighlight2 guifg=' . g:colorViolet ' guibg=' . g:colorDark2
	return "INSERT "

    elseif mode ==# "c"
	exec 'hi ModeHighlight guifg=' . g:colorDark ' guibg=' . g:colorYellow
    exec 'hi ModeHighlight2 guifg=' . g:colorYellow ' guibg=' . g:colorDark2
	return "COMMAND "

	elseif mode ==# "v"
	exec 'hi ModeHighlight guifg=' . g:colorDark ' guibg=' . g:colorBlue
    exec 'hi ModeHighlight2 guifg=' . g:colorBlue ' guibg=' . g:colorDark2
	return "VISUAL "

	elseif mode ==# "V"
	exec 'hi ModeHighlight guifg=' . g:colorDark ' guibg=' . g:colorBlue
    exec 'hi ModeHighlight2 guifg=' . g:colorBlue ' guibg=' . g:colorDark2
	return "V-LINE "

	elseif mode ==# "\<C-v>"
	exec 'hi ModeHighlight guifg=' . g:colorDark ' guibg=' . g:colorBlue
    exec 'hi ModeHighlight2 guifg=' . g:colorBlue ' guibg=' . g:colorDark2
	return "V-BLOCK "

	elseif mode ==# "R"
	exec 'hi ModeHighlight guifg=' . g:colorDark ' guibg=' . g:colorViolet
    exec 'hi ModeHighlight2 guifg=' . g:colorViolet ' guibg=' . g:colorDark2
	return "REPLACE"

	elseif mode ==# "s"
	exec 'hi ModeHighlight guifg=' . g:colorDark ' guibg=' . g:colorBlue
    exec 'hi ModeHighlight2 guifg=' . g:colorBlue ' guibg=' . g:colorDark2
	return "SELECT"

	elseif mode ==# "t"
	exec 'hi ModeHighlight guifg=' . g:colorDark ' guibg=' . g:colorYellow
    exec 'hi ModeHighlight2 guifg=' . g:colorYellow ' guibg=' . g:colorDark2
	return "TERM"

	elseif mode ==# "!"
	exec 'hi ModeHighlight guifg=' . g:colorDark ' guibg=' . g:colorYellow
    exec 'hi ModeHighlight2 guifg=' . g:colorYellow ' guibg=' . g:colorDark2
	return "SHELL"

    else               
	return ""

    endif
endfunc  

" Status line
set statusline=
set statusline+=%#ModeHighlight#
set statusline+=\ %{Mode()}
set statusline+=%#GitBranchHighlight#
set statusline+=\ %{get(b:,'gitbranchname','No-Branch')}
"set statusline+=\ %{get(b:,'gitbranchname',b:gitbranchname)}
"set statusline+=\ %{get(b:,'gitstatus',b:gitstatus)}
set statusline+=%#ModeHighlight2#
set statusline+=\ %t
set statusline+=%m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ 
set statusline+=%#ModeHighlight#
set statusline+=\ BN:\ %n\ \|
set statusline+=\ %p%%\ \|
set statusline+=\ %l/\%L\ \|\ :%c\ 
" }}}
