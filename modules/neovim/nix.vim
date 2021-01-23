" Prefetch URL shas
" Source: https://discourse.nixos.org/t/nix-prefetch-integration-for-vim/4670/5
function! NixPrefetchUrlSha()
  execute ':normal F"lyt"'
  let l:reg = getreg('"')
  normal! /sha256
  execute ':normal nf"ldt"'
  let l:cmd = '! nix-prefetch-url ' . '"' . l:reg . '" 2>/dev/null | tail -1 | tr -d "\n"'
  let l:sha = system(l:cmd) | redraw!
  execute ":normal i" . l:sha
endfunc
noremap <Leader>p :call NixPrefetchUrlSha()<CR>
