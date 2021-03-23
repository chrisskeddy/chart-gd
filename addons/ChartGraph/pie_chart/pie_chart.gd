
class PieChartData:
	var data
	var hovered_item = null
	var hovered_radius_ratio = 1.1

	func _init():
		data = {}

	func _set(param, value):
		data[param] = value
		return true

	func _get(param):
		if not data.has(param):
			data[param] = 0.0
		return data[param]

	func set_hovered_item(name):
		hovered_item = name

	func set_radius(param, value):
		return _set(_format_radius_key(param), value)

	func get_radius(param):
		var radius_ratio = 1.0
		if param == hovered_item:
			radius_ratio = hovered_radius_ratio
		return _get(_format_radius_key(param)) * radius_ratio

	func _format_radius_key(param):
		return '%s_radius' % [param]

	func get_property_list():
		return data.keys()
