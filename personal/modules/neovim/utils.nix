{ lib, ... }:
with lib;
let
  # TODO add indentation to pretty-print vim
  vimFormatters = {
    int = _: builtins.toString;
    float = _: builtins.toString;
    bool = _: v: if v then "v:true" else "v:false";
    # TODO escape strings
    string = _: v: "'${v}'";
    set = f: v:
      wrapFmt "{" "}"
        (attrsets.mapAttrsToList
          (name: value: "${f(name)}: ${f(value)}")
          v);
    list = f: v:
      wrapFmt "[" "]"
        (map f v);
  };
  wrapFmt = s: e: values: "${s}${strings.concatStringsSep ", " values}${e}";
in
rec {
  toVim = v:
    let
      t = builtins.typeOf v;
      f = if builtins.hasAttr t vimFormatters
        then builtins.getAttr t vimFormatters
        else throw "No vim formatter for ${v} of type ${t}";
    in f toVim v;
}
