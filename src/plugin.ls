export function lookup-plugins (plugin_names)
	plugin_names .map ->
		require it