filetype plugin indent on
syntax on
set title
set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab
set autoindent
set smartindent
set number
set scrolloff=8
set sidescrolloff=8
set incsearch
set ignorecase
set smartcase
set hidden
set splitright
set splitbelow
"set undofile
"set undodir=~/.vim/undo//
set wildmenu
set completeopt=menuone,noinsert,noselect

let NERDTreeShowHidden=1
call plug#begin('~/.vim/plugged')
" --- Maximizer ---
Plug 'szw/vim-maximizer'

" --- Theme & UI ---
Plug 'sainnhe/sonokai'             " High-contrast, vibrant theme
Plug 'itchyny/lightline.vim'       " Clean statusline
Plug 'preservim/nerdtree'          " File tree sidebar (:NERDTree)
Plug 'ctrlpvim/ctrlp.vim'          " Fuzzy file finder (Ctrl+P)
Plug 'easymotion/vim-easymotion'   " Jump anywhere fast (<leader><leader>w)

Plug 'junegunn/fzf.vim'            " Fuzzy finder using system fzf
Plug 'tpope/vim-fugitive'        " Git integration (:Git, :Gdiffsplit, :Git blame)
Plug 'editorconfig/editorconfig-vim'
call plug#end()

" --- Theme Configuration ---
if has('termguicolors')
  set termguicolors
endif

set background=dark
" 'atlantis' is very vibrant and high-contrast
let g:sonokai_style = 'atlantis'
let g:sonokai_better_performance = 1
let g:sonokai_enable_italic = 1
colorscheme sonokai

let g:lightline = {'colorscheme' : 'sonokai'}

" --- Transparency Fix ---
function! AdaptToTerminal()
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight SignColumn guibg=NONE ctermbg=NONE
    highlight MatchParen guifg=#FFFFFF guibg=#FF5F00 gui=bold
    highlight Terminal guibg=NONE ctermbg=NONE
    highlight StatusLine guibg=NONE ctermbg=NONE
    highlight StatusLineNC guibg=NONE ctermbg=NONE
endfunction

autocmd ColorScheme * call AdaptToTerminal()
call AdaptToTerminal()

" --- Keybindings ---
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
nnoremap <C-f> :NERDTreeFind<CR>

" --- Linux Kernel C Style ---
autocmd FileType c,cpp setlocal cindent cinoptions=:0,l1,t0,g0,(0
autocmd FileType c,cpp,h setlocal tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab
autocmd BufNewFile,BufRead *.dts,*.dtsi,*.overlay,*.keymap setfiletype dts
autocmd BufNewFile,BufRead Kconfig,Kconfig.* setfiletype kconfig

" ---- quickfix and project workflow ----
nnoremap <leader>w :update<CR>
nnoremap <leader>q :copen<CR>
nnoremap <leader>n :cnext<CR>
nnoremap <leader>p :cprevious<CR>
nnoremap <leader>x :cclose<CR>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>b :make<CR>
nnoremap <leader>r :execute 'make -j' . trim(system('nproc'))<CR>

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p')
endif


" ---- ctags ----
set tags=./tags;,tags;
" ./tags;   -> look for a 'tags' file starting in the current file's dir, walking up
" tags;     -> also search upward from vim's cwd
" the trailing ';' means "keep going up until found or hit root"

if has('cscope')
  set csprg=/usr/bin/cscope
  set csto=1        " prefer ctags over cscope for tag-name matches, cscope as fallback
  set cst            " use cscope for :tag / ctrl-]
  set nocsverb

  function! LoadCscope()
    " Don't re-add if a database is already loaded
    if !empty(cscope_connection())
      return
    endif

    " Search upward from the current buffer's directory for cscope.out
    let db = findfile("cscope.out", expand('%:p:h') . ';')
    if empty(db) && $CSCOPE_DB != ""
      let db = $CSCOPE_DB
    endif

    if !empty(db) && filereadable(db)
      execute "cs add " . fnameescape(db) . " " . fnameescape(fnamemodify(db, ":p:h"))
    endif
  endfunction

  augroup CscopeAutoLoad
    autocmd!
    autocmd VimEnter,BufEnter * call LoadCscope()
  augroup END

  set csverb
endif

" ---- optional: familiar cscope keymaps (ctrl-\ + letter) ----
nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>i :cs find i <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

" ---- vertical-split versions (ctrl-\ + v + letter) ----
nnoremap <C-\>vs :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>vg :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>vc :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>vt :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>ve :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>vf :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>vi :vert scs find i <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>vd :vert scs find d <C-R>=expand("<cword>")<CR><CR>

" ---- ctags: normal / horizontal / vertical / preview ----
nnoremap <C-]>      <C-]>
nnoremap <leader>ts :stag <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>tv :vert stag <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>tp :ptag <C-R>=expand("<cword>")<CR><CR>

" --- fzf ---
nnoremap <leader>f  :Files<CR>    
nnoremap <leader>F  :GFiles<CR>   
nnoremap <leader>g  :Rg<CR>       
nnoremap <leader>bb :Buffers<CR>  
nnoremap <leader>tt :Tags<CR>     
nnoremap <leader>tb :BTags<CR>    
nnoremap <leader>l  :Lines<CR>    
nnoremap <leader>H  :History<CR>

" --- vim-fugitive: Git workflow (all mappings use <leader>v) ---
nnoremap <leader>vs :Git<CR>                                      " Git status / summary
nnoremap <leader>va :Git add %<CR>                                " Stage current file
nnoremap <leader>vA :Git add -A<CR>                               " Stage all changes
nnoremap <leader>vc :Git commit<CR>                               " Commit staged changes
nnoremap <leader>vp :Git push<CR>                                 " Push to remote
nnoremap <leader>vP :Git pull<CR>                                 " Pull from remote
nnoremap <leader>vf :Git fetch<CR>                                " Fetch from remote
nnoremap <leader>vd :Gdiffsplit<CR>                               " Diff file against index
nnoremap <leader>vb :Git blame<CR>                                " Blame current file
nnoremap <leader>vl :Git log --oneline --decorate --all<CR>       " View Git history
nnoremap <leader>vL :Git log --oneline --decorate -- %<CR>	  " Log of current file

" Visual: <leader>y yanks to Vim AND the system clipboard
xnoremap <leader>y y:call system('wl-copy', @")<CR>

" Normal: <leader>y + motion (e.g. <leader>yy for a line)
nnoremap <expr> <leader>y 'y'
nnoremap <leader>yy yy:call system('wl-copy', @")<CR>

" Paste from system clipboard
nnoremap <leader>p :let @" = system('wl-paste --no-newline')<CR>""p
