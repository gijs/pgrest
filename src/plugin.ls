export lookup-plugins = (plugin_names) ->
  imported = []
  for modname in plugin_names
      if (modname.indexOf 'pgrest-') == 0
        mod = require modname
        imported.push mod
      else
        throw "invalid plugin name: #modname"

export try-invoke = (plugins, hookname, ...args) ->
  for plugin in plugins
    hook = plugin[normalized-hookname hookname]
    if hook?
      hook ...args

capitalize = -> it.replace /(?:^|\s)\S/g, -> it.toUpperCase!

normalized-hookname = (hookname) ->
  [hd, ...tl] = hookname / \-
  if hd in <[prehook posthook]> and tl
    hd + (tl.map -> capitalize it) * ''
  else
    throw "invalid hook name #hookname"
