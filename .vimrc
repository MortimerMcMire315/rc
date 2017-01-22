"-----VUNDLE PLUGINS-----"
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'pbrisbin/vim-syntax-shakespeare'
Plugin 'tpope/vim-surround'
Plugin 'vim-syntastic/syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'junegunn/vim-easy-align'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()

"-----END VUNDLE PLUGINS-----"

"-----SYNTASTIC SETTINGS-----"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:airline_theme='base16'
let g:syntastic_loc_list_height = 4
"-----END SYNTASTIC SETTINGS-----"

"-----AIRLINE-----"
let g:airline_powerline_fonts = 1
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
set guitablabel=%t
"-----END AIRLINE-----"

"-----VIM-EASY-ALIGN-----"
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


"    ---- haskell module-import alignment mappings. This is for a very
"         customized workflow, and basically helps me achieve import lists
"         that look like [this](http://tinyurl.com/glxp3k2)
"   Split lines on commas
    nmap gh, :s/\v,/\r,/g<Return>

"   (foo) -> ( foo )
    nmap gh<Space> ma0f(a<Space><Esc>$a<Space><Esc>F)i<Space><Esc>A<Backspace><Esc>'a

"   Align selection on commas or left-paren
    xmap gh( ga<C-X><Bslash>v(<Bslash>(\|,)<Return>

"   Align selection on righ-paren
    xmap gh) ga<C-X><Bslash>v[^<Bslash>.]<Bslash>)<Return>

"-----END VIM-EASY-ALIGN-----"

"-----GOYO/LIMELIGHT-----"
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
function! s:goyo_enter()
    SyntasticToggleMode
    Limelight
endfunction

function! s:goyo_leave()
    SyntasticToggleMode
    SyntasticCheck
    Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"-----END GOYO/LIMELIGHT-----"

filetype plugin indent on
syntax on
set re=1

"-----HIGHLIGHT EXTRA SPACE-----"
highlight ExtraWhitespace ctermbg=091 guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=091 guibg=red
match ExtraWhitespace /\s\+$/
"-----END HIGHLIGHT-----"

"-----SOLARIZED-----"
syntax enable
set background=dark
"let g:solarized_termcolors=256
colorscheme solarized
"-----END SOLARIZED-----"

"-----Grep directory for word under cursor-----"
function Grep()
    let wordundercursor = expand("<cword>")
    execute "!grep -R " . wordundercursor . " \."
endfunction

command! Grep call Grep()
nmap gR :Grep<return>
"-----End Grep thing-----"

hi Search ctermbg=053

set hidden
set number
set et
set autoindent
set smarttab
set smartindent
set ts=4
set sw=4
set nowrap
set backspace=indent,eol,start

if &term =~ '^screen'
        set ttymouse=xterm2
endif

noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

"----- Haskell rebindings for fast typing (THAT PUN WAS INCREDIBLE!)-----"
autocmd BufNewFile,BufRead *.hs inoremap <buffer> <silent> -= <Space>-><Space>
autocmd BufNewFile,BufRead *.hs inoremap <buffer> <silent> =- <Space>=><Space>
