{
  manifest:: {
    local manifest = self,

    _depends+:: ['xdg-utils'],

    _programs:: {
      editor: null,
      terminal: null,
    },

    _profile:: {
      programs: {
        EDITOR: manifest._programs.editor,
        SUDO_EDITOR: manifest._programs.editor,
        GIT_EDITOR: manifest._programs.editor,
        VISUAL: manifest._programs.editor,
      },
    },
  },
}
