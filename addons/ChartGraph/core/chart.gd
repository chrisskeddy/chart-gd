tool
extends ReferenceRect
class_name CGChart

enum LABELS_TO_SHOW {
	NO_LABEL = 0,
	X_LABEL = 1,
	Y_LABEL = 2,
	LEGEND_LABEL = 4
}
enum CHART_TYPE {
	LINE_CHART,
	PIE_CHART
}

var current_data = []
var tween_node = Tween.new()
export(int, 6, 24) var MAX_VALUES = 12
onready var global_scale = Vector2(1.0, 1.0) / sqrt(MAX_VALUES)

func clean_chart():
	# If there is too many points, remove old ones
	while current_data.size() >= MAX_VALUES:
		var point_to_remove = current_data[0]

		if point_to_remove.has('sprites'):
			for key in point_to_remove.sprites:
				var sprite = point_to_remove.sprites[key]

				sprite.sprite.queue_free()

		current_data.remove(0)
		_update_scale()

func _update_scale():
#	current_data_size = current_data.size()
	global_scale = Vector2(1.0, 1.0) / sqrt(min(5, current_data.size()))

func _stop_tween():
#	Reset current tween
	tween_node.remove_all()
	tween_node.stop_all()
