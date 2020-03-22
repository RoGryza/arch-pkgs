// TODO enable ctrlp-py-matcher
{
  _depends+:: ['vim-ctrlp'],

  _viminit+:: |||
    " CtrlP
    let g:ctrlp_open_new_file = 'r'
    let g:ctrlp_switch_buffer = 0

    let g:ctrlp_map = '<c-p>'
    nnoremap <C-P> :CtrlP .<CR>
    nnoremap <C-B> :CtrlPBuffer<CR>
    nnoremap <C-T> :CtrlPTag<CR>
  |||,
}
