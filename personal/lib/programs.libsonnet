{
  manifest:: {
    local manifest = self,

    _programs:: {
      editor: null,
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
