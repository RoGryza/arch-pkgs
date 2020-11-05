{ lib, ... }:
with lib;
let
  wrapFmt = s: e: values: "${s}${strings.concatStringsSep ", " values}${e}";
in
rec {
  recSerializer = attrs:
  attrs // {
    __functor =
      self@{ name, serializers, ... }: v:
      let
        t = builtins.typeOf v;
        f =
          if builtins.hasAttr t serializers
          then builtins.getAttr t serializers
          else throw "No ${name} formatter for type ${t}";
      in
      if isRaw v then v._raw else f self v;
  };

  simpleSerializers = {
    t, f,
    quotes ? "\"",
    attr ? f: name: value: "${name}: ${f(value)}",
  }: {
    int = _: builtins.toString;
    float = _: builtins.toString;
    bool = _: v: if v then t else f;
    # TODO escape strings
    string = _: v: "${quotes}${v}${quotes}";
    set = f: v: wrapFmt "{" "}" (attrsets.mapAttrsToList (attr f) v);
    list = f: v: wrapFmt "[" "]" (map f v);
  };

  toVim = recSerializer {
    name = "vim";
    # TODO add indentation to pretty-print vim
    serializers = simpleSerializers {
      t = "v:true";
      f = "v:false";
      quotes = "'";
      attr = f: name: value: "${f(name)}: ${f(value)}";
    };
  };

  raw = v: { _raw = v; };
  isRaw = v: isAttrs v && hasAttr "_raw" v && isString v._raw;
  types.raw = mkOptionType { name = "raw"; check = isRaw; };

  toRasi =
    let
      inner = recSerializer {
        name = "rasi";
        serializers = {
          int = _: builtins.toString;
          float = _: builtins.toString;
          bool = _: v: if v then "true" else "false";
          string = _: v: "\"${v}\"";
          list = f: v: wrapFmt "[" "]" (map f v);
        };
      };
      section = v: strings.concatStringsSep "\n"
        (attrsets.mapAttrsToList (k: x: "  ${k}: ${inner x};") v);
    in
    v: strings.concatStringsSep "\n"
      (attrsets.mapAttrsToList
        (name: value: "${name} {\n${section(value)}\n}\n")
        v);
}
