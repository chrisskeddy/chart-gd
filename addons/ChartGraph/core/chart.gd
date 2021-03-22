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
# Utilitary functions
const ordinary_factor = 10
const range_factor = 1000
const units = ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']
const LABEL_SPACE = Vector2(64.0, 32.0)
const COLOR_LINE_RATIO = 0.5

var current_mouse_over = null
var current_point_color = {}
var current_show_label = LABELS_TO_SHOW.NO_LABEL
var current_data = []
var current_animation_duration = 1.0

var tween_node = Tween.new()
export(int) var limit_x_count = 12
#export(int) var MAX_VALUES = 12
export(Font) var label_font
export(Color) var font_color = Color('#b111171c')
onready var global_scale = Vector2(1.0, 1.0) / sqrt(limit_x_count)
onready var min_x = 0.0
onready var max_x = get_size().x

onready var min_y = 0.0
onready var max_y = get_size().y

func _ready():
	add_child(tween_node)
	tween_node.set_active(true)
	tween_node.start()


func initialize(show_label, points_color = {}, animation_duration = 1.0):
	set_labels(show_label)
	current_animation_duration = animation_duration
	for key in points_color:
		current_point_color[key] = {
			dot = points_color[key],
			line = Color(
				points_color[key].r,
				points_color[key].g,
				points_color[key].b,
				points_color[key].a * COLOR_LINE_RATIO)
		}


func set_labels(show_label):
	current_show_label = show_label

	# Reset values
	min_y = 0.0
	min_x = 0.0
	max_y = get_size().y
	max_x = get_size().x

	if current_show_label & LABELS_TO_SHOW.X_LABEL:
		max_y -= LABEL_SPACE.y

	if current_show_label & LABELS_TO_SHOW.Y_LABEL:
		min_x += LABEL_SPACE.x
		max_x -= min_x

	if current_show_label & LABELS_TO_SHOW.LEGEND_LABEL:
		min_y += LABEL_SPACE.y
		max_y -= min_y

#	move_other_sprites()
	update()
	tween_node.start() 

func clean_chart():
	# If there is too many points, remove old ones
	while current_data.size() > limit_x_count:
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

#Use for formating numbers ex 1000 becomes 1k
func format(number, format_text_custom = '%.2f %s'):
	var unit_index = 0
	var format_text = '%d %s'
	var ratio = 1

	for index in range(0, units.size()):
		var computed_ratio = pow(range_factor, index)
		if abs(number) > computed_ratio:
			ratio = computed_ratio
			unit_index = index
			if index > 0:
				format_text = format_text_custom
	return format_text % [(number / ratio), units[unit_index]]

func _draw_labels():
	if current_show_label & LABELS_TO_SHOW.LEGEND_LABEL:
		var nb_labels = current_point_color.keys().size()
		var position = Vector2(min_x, 0.0)

		for legend_label in current_point_color.keys():
			var dot_color = current_point_color[legend_label].dot
			var rect = Rect2(position, LABEL_SPACE / 1.5)
			var label_position = position + LABEL_SPACE * Vector2(1.0, 0.4)

			if current_mouse_over != null and current_mouse_over != legend_label:
				dot_color = Color(
					dot_color.r,
					dot_color.g,
					dot_color.b,
					dot_color.a * COLOR_LINE_RATIO)
			draw_string(label_font, label_position, tr(legend_label), font_color)
			draw_rect(rect, dot_color)

			position.x += 1.0 * max_x / nb_labels

func clear_chart():
	_stop_tween()
#	max_value = 1.0
#	min_value = 0.0

	for point_to_remove in current_data:
		if point_to_remove.has('sprites'):
			for key in point_to_remove.sprites:
				var sprite = point_to_remove.sprites[key]

				sprite.sprite.queue_free()

	current_data = []
	_update_scale()
	update()
