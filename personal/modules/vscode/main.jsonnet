{
  local manifest = self,

  _depends+:: ['code'],

  _programs+:: {
    editor: 'code -w',
  },
}
