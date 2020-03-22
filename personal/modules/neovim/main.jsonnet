local util = import 'lib/util.libsonnet';
local submodules = [
  import './ctrlp.jsonnet',
  import './editing.jsonnet',
  import './lsp.jsonnet',
  import './git.jsonnet',
  import './visual.jsonnet',

  import './languages.jsonnet',
  import './python.jsonnet',
];

std.foldl(function(a, b) a + b, submodules, {
  local manifest = self,

  _depends+:: [
    'neovim',
    'neovim-drop-in',
    'vim-eunuch',
  ],

  _programs+:: {
    editor: 'nvim',
  },

  _viminit:: importstr './init.vim',

  _vimfiles:: {
    'plugin/init.vim': manifest._viminit,
  },

  _check+:: [|||
    nvim --headless -u NONE -i NONE -c 'try | source /usr/share/vim/vimfiles/plugin/init.vim | catch | cq | endtry | q' || echo "Error in init.vim"
  |||],

  _files+:: util.mapPairs(
    function(path, content) ['usr/share/vim/vimfiles/%s' % path, { content: content }],
    self._vimfiles,
  ),
})

// " Python {{{
// if executable('pyls')
//   Plug 'ryanolsonx/vim-lsp-python'

//   augroup PythonLsp
//     au!
//     autocmd BufWritePre *.py LspDocumentFormatSync
//   augroup END
// endif
// " }}}

// " Jsonnet {{{
// Plug 'google/vim-jsonnet'



