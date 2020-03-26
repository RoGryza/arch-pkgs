{
  nullOrEmpty:: function(v)
    v == null || std.length(v) == 0,

  mapToArray:: function(fn, obj)
    local mapped = std.mapWithKey(fn, obj);
    [mapped[k] for k in std.objectFieldsAll(obj)],

  objectFromPairs:: function(pairs) { [p[0]]: p[1] for p in pairs },

  mapPairs:: function(fn, obj) $.objectFromPairs($.mapToArray(fn, obj)),

  formatter:: function(fmtFns)
    local rec = function(v)
      local type = std.type(v);
      if std.objectHas(fmtFns, type)
      then fmtFns[type](rec, v)
      else error 'Cannot format %s' % v;
    rec,

  formatBash:: $.formatter({
    number: function(_, v) std.toString(v),
    string: function(_, v) std.escapeStringBash(v),
    array: function(rec, v) '(%s)' % std.join(' ', std.map(rec, v)),
  }),

  formatVim:: $.formatter({
    number: function(_, v) std.toString(v),
    string: function(_, v) "'%s'" % v,
    array: function(rec, v) '[%s]' % std.join(', ', std.map(rec, v)),
    object: function(rec, obj) '{%s}' % std.join(', ', $.mapToArray(
      function(k, v) '%s: %s' % [rec(k), rec(v)],
      obj,
    )),
  }),
}
