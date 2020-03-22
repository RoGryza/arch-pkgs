local fmtFns(rec) = {
  number: function(n) '%d' % n,
  string: std.escapeStringBash,
  array: function(a) '(%s)' % std.join(' ', [rec(x) for x in a]),
};

{
  nullOrEmpty:: function(v)
    v == null || std.length(v) == 0,

  mapToArray:: function(fn, obj)
    local mapped = std.mapWithKey(fn, obj);
    [mapped[k] for k in std.objectFieldsAll(obj)],

  objectFromPairs:: function(pairs) { [p[0]]: p[1] for p in pairs },

  mapPairs:: function(fn, obj) $.objectFromPairs($.mapToArray(fn, obj)),

  formatBash:: function(v)
    local type = std.type(v);
    local fns = fmtFns($.formatBash);
    if std.objectHasAll(fns, type)
    then fns[type](v)
    else error 'Cannot format %s' % v,
}
