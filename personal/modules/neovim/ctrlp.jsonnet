// TODO enable ctrlp-py-matcher
{
  _nvim+:: {
    _plugins+:: {
      ctrlp: {
        github: 'kien/ctrlp.vim',
        rev: '1.79',
      },
    },

    _init+:: {
      'ctrlp.vim': |||
        let g:ctrlp_open_new_file = 'r'
        let g:ctrlp_switch_buffer = 0

        let g:ctrlp_custom_ignore = {
          \ 'dir':  'node_modules\|__pycache__',
          \ 'file': '\v\.pyc$',
          \ }

        let g:ctrlp_map = '<c-p>'
        nnoremap <C-P> :CtrlP .<CR>
        nnoremap <C-B> :CtrlPBuffer<CR>
        nnoremap <C-T> :CtrlPTag<CR>
      |||,
    },
  },
}
