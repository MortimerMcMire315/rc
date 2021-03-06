""-----VUNDLE PLUGINS-----"
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'chrisbra/csv.vim'
Plugin 'chrisbra/Recover.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'joonty/vdebug'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'junegunn/vim-easy-align'
Plugin 'lumiliet/vim-twig'
"Plugin 'mattn/emmet-vim'
Plugin 'pbrisbin/vim-syntax-shakespeare'
"Plugin 'swekaj/php-foldexpr.vim'
"Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-syntastic/syntastic'
Plugin 'VundleVim/Vundle.vim'


call vundle#end()

"-----END VUNDLE PLUGINS-----"

"Remap F10 for debugging
nmap <F8> <F10>

"Move between / delete buffers
map gn :bn<cr>
map gp :bp<cr>
map gd :bd<cr>

"Toggle paste on/off
map gsnp :set nopaste<cr>
map gsp :set paste<cr>

"-----CSV SETTINGS-----"
map gsva :%CSVArrangeColumn<cr>
map gsvu :%CSVUnArrangeColumn<cr>
"-----END CSV SETTINGS-----"

"-----SYNTASTIC SETTINGS-----"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

map gst :SyntasticToggleMode<cr>

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:airline_theme='base16'
let g:syntastic_loc_list_height = 4
let g:syntastic_filetype_map = { 'html.twig' : 'twig' }
let g:syntastic_twig_checkers = ['twiglint']
let g:syntastic_twig_twiglint_exec = 'php'
let g:syntastic_twig_twiglint_exe = 'twig-lint'
let g:syntastic_python_checkers = ['pycodestyle', 'python']
"-----END SYNTASTIC SETTINGS-----"

"-----AIRLINE-----"
let g:airline#extensions#tabline#fnamemod=':t'
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

"-----CTRLP-----"
"Ignore vendor directory on composer projects

let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](vendor|cache|\.git)$'
  \ }

"-----END CTRLP-----"

"-----GOYO/LIMELIGHT-----"
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
function! s:goyo_enter()
    SyntasticToggleMode
"    Limelight
endfunction

function! s:goyo_leave()
    SyntasticToggleMode
    SyntasticCheck
"    Limelight!
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
autocmd InsertLeave * highlight ExtraWhitespace ctermbg=091 guibg=red
autocmd InsertEnter * highlight ExtraWhitespace ctermbg=NONE guibg=NONE
match ExtraWhitespace /\s\+$/
"-----END HIGHLIGHT-----"

"-----SOLARIZED-----"
syntax enable
set background=dark
"let g:solarized_termcolors=256
colorscheme solarized
"-----END SOLARIZED-----"

"-----Grep directory for word under cursor-----"
function MoodleGrep()
    let wordundercursor = expand("<cword>")
    let moodleconfig = findfile('config.php', '.;')
    execute "!grep -RE '(function|class) " . wordundercursor . "' $(dirname " . moodleconfig . ")"
endfunction

function MoodleLibGrep()
    let wordundercursor = expand("<cword>")
    let moodleconfig = findfile('config.php', '.;')
    execute "!grep -RE '(function|class) " . wordundercursor . "' $(dirname " . moodleconfig . ")/lib "
endfunction

command! MoodleGrep call MoodleGrep()
command! MoodleLibGrep call MoodleLibGrep()
nmap gRM :MoodleGrep<return>
nmap gRL :MoodleLibGrep<return>
"-----End Grep thing-----"

"-----Generate ctags for current file-----"
function GenCtags()
    execute "silent !ctags %"
    execute "redraw!"
endfunction

command! GenCtags call GenCtags()
nmap gC :GenCtags<return>
"-----End ctags thing-----"

"-----Auto-close braces-----"
inoremap {<CR>  {<CR>}<Esc>O


hi Search ctermbg=053

set hidden
set number
set expandtab
set smarttab
set autoindent
set tabstop=4
set shiftwidth=4
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

"----- Haskell rebindings for fast typing (THAT PUN WAS INCREDIBLE!)-----"
autocmd BufNewFile,BufRead *.hs inoremap <buffer> <silent> -= <Space>-><Space>
autocmd BufNewFile,BufRead *.hs inoremap <buffer> <silent> =- <Space>=><Space>

"autocmd BufNewFile,BufRead *.php setlocal fdm=indent
autocmd BufnewFile,BufRead /home/sayoder/Documents/pnt/*.html setlocal ft=liquid
autocmd BufnewFile,BufRead /home/sayoder/Documents/pnt/*.markdown setlocal ft=liquid
autocmd BufnewFile,BufRead /home/sayoder/Documents/pnt/*/*.html setlocal ft=liquid
autocmd BufnewFile,BufRead /home/sayoder/Documents/pnt/*/*.markdown setlocal ft=liquid
autocmd BufNewFile,BufRead *.markdown setlocal wrap | setlocal tw=80

autocmd BufNewFile,BufRead *.markdown imap <C-g>ji {% include photo.html id="" %}<esc>F"i
autocmd BufNewFile,BufRead *.markdown nmap gji i{% include photo.html id="" %}<esc>F"i
autocmd BufNewFile,BufRead *.html setlocal ts=2 | setlocal sw=2

map gf10 <f10>
