tool
extends CGChart
class_name CGLine

var min_y_value = 0.0
var max_y_value = 1.0

export(Color) var grid_color = Color('#b111171c')
export(Texture) var dot_texture = preload("res://addons/ChartGraph/graph-plot-white.png")
export var line_width = 2.0
export(Color) var default_chart_color = Color('#ccffffff')

var end_point_position = Vector2.ZERO

onready var interline_color = Color(grid_color.r, grid_color.g, grid_color.b, grid_color.a * 0.5)

func _draw():
	draw_line_chart()
	_draw_labels()

func compute_y(value):
	var amplitude = max_y_value - min_y_value
	return ((value - min_y_value) / amplitude) * (max_y - dot_texture.get_size().y)

func _compute_max_y_value(point_data):
	# Being able to manage multiple points dynamically
	for key in point_data.values:
		max_y_value = max(point_data.values[key], max_y_value)
		min_y_value = min(point_data.values[key], min_y_value)

		# Set default color
		if not current_point_color.has(key):
			current_point_color[key] = {
				dot = default_chart_color,
				line = Color(default_chart_color.r,
					default_chart_color.g,
					default_chart_color.b,
					default_chart_color.a * COLOR_LINE_RATIO)
			}
	
func move_other_sprites():
	var index = 0

	for points_data in current_data:
		_move_other_sprites(points_data, index)

		index += 1


func compute_sprites(points_data):
	var sprites = {}

	for key in points_data.values:
		var value = points_data.values[key]

		var sprite = TextureRect.new()

		var initial_pos = Vector2(max_x, max_y)
		if end_point_position != Vector2.ZERO:
			initial_pos = end_point_position

		sprite.set_position(initial_pos)

		sprite.set_texture(dot_texture)
		sprite.set_modulate(current_point_color[key].dot)

		add_child(sprite)

		var end_pos = Vector2(max_x, max_y) - Vector2(-min_x, compute_y(value) - min_y)
		end_point_position=end_pos
		sprite.mouse_filter = MOUSE_FILTER_STOP
		sprite.set_tooltip('%s: %s' % [tr(key), format(value)])

		sprite.connect('mouse_entered', self, '_on_mouse_over', [key])
		sprite.connect('mouse_exited', self, '_on_mouse_out', [key])

		animation_move_dot(sprite, end_pos - dot_texture.get_size() * global_scale / 2.0, global_scale, 0.0, current_animation_duration)

		sprites[key] = {
			sprite = sprite,
			value = value
		}

	return sprites



func _move_other_sprites(points_data, index):
	for key in points_data.sprites:
		var delay = sqrt(index) / 10.0
		delay=0.0
		var y = min_y + max_y - compute_y(points_data.sprites[key].value)
		var x = min_x + (max_x / max(1.0, max(0, current_data.size() - 1))) * index

		animation_move_dot(points_data.sprites[key].sprite, Vector2(x, y) - dot_texture.get_size() * global_scale / 2.0, global_scale, delay)

func animation_move_dot(node, end_pos, end_scale, delay = 0.0, duration = 0.5):
	if node == null:
		return

	var current_pos = node.get_position()
	var current_scale = node.get_scale()

	tween_node.interpolate_property(node, 'rect_position', current_pos, end_pos, duration, Tween.TRANS_CIRC, Tween.EASE_OUT, delay)
	tween_node.interpolate_property(node, 'rect_scale', current_scale, end_scale, duration, Tween.TRANS_CIRC, Tween.EASE_OUT, delay)
	tween_node.interpolate_method(self, '_update_draw', 0.0, 1.0, duration, Tween.TRANS_CIRC, Tween.EASE_OUT, delay)


func create_new_point(point_data):
	_stop_tween()
	clean_chart()

	_compute_max_y_value(point_data)

	# Move others current_data
	move_other_sprites()

	current_data.push_back({
		label = point_data.label,
		sprites = compute_sprites(point_data)
	})

	_update_scale()
	move_other_sprites()
	update()
	tween_node.start()

func draw_line_chart():
	var vertical_line = [Vector2(min_x, min_y), Vector2(min_x, min_y + max_y)]
	var horizontal_line = [vertical_line[1], Vector2(min_x + max_x, min_y + max_y)]
	var previous_point = {}

	# Need to draw the 0 ordinate line
	if min_y_value < 0:
		horizontal_line[0].y = min_y + max_y - compute_y(0.0)
		horizontal_line[1].y = min_y + max_y - compute_y(0.0)

	var pointListObject = {}

	for point_data in current_data:
		var point

		for key in point_data.sprites:
			var current_dot_color = current_point_color[key].dot

			if current_mouse_over != null and current_mouse_over != key:
				current_dot_color = Color(
					current_dot_color.r,
					current_dot_color.g,
					current_dot_color.b,
					current_dot_color.a * COLOR_LINE_RATIO)

			point_data.sprites[key].sprite.set_modulate(current_dot_color)

			point = point_data.sprites[key].sprite.get_position() + dot_texture.get_size() * global_scale / 2.0

			if not pointListObject.has(key):
				pointListObject[key] = []

			if point.y < (min_y + max_y - 1.0):
				pointListObject[key].push_back(point)
			else:
				pointListObject[key].push_back(Vector2(point.x, min_y + max_y - 2.0))

			if previous_point.has(key):
				var current_line_width = line_width

				if current_mouse_over != null and current_mouse_over != key:
					current_line_width = 1.0
				elif current_mouse_over != null:
					current_line_width = 3.0

				draw_line(previous_point[key], point, current_point_color[key].line, current_line_width)

				# Don't add points that are too close of each others
				if abs(previous_point[key].x - point.x) < 10.0:
					pointListObject[key].pop_back()

			previous_point[key] = point

		draw_line(
			Vector2(point.x, vertical_line[0].y),
			Vector2(point.x, vertical_line[1].y),
			interline_color, 1.0)

		if current_show_label & LABELS_TO_SHOW.X_LABEL:
			var label = tr(point_data.label).left(3)
			var string_decal = Vector2(14, -LABEL_SPACE.y + 8.0)

			draw_string(label_font, Vector2(point.x, vertical_line[1].y) - string_decal, label, grid_color)
	
#	_draw_chart_background(pointListObject)

	if current_show_label & LABELS_TO_SHOW.Y_LABEL:
		var ordinate_values = compute_ordinate_values(max_y_value, min_y_value)

		for ordinate_value in ordinate_values:
			var label = format(ordinate_value)
			var position = Vector2(max(0, 6.0 -label.length()) * 9.5, min_y + max_y - compute_y(ordinate_value))
			draw_string(label_font, position, label, grid_color)

	draw_line(vertical_line[0], vertical_line[1], grid_color, 1.0)
	draw_line(horizontal_line[0], horizontal_line[1], grid_color, 1.0)


func compute_ordinate_values(max_y_value, min_y_value):
	var amplitude = max_y_value - min_y_value
	var ordinate_values = [-10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10]
	var result = []
	var ratio = 1

	for index in range(0, ordinary_factor):
		var computed_ratio = pow(ordinary_factor, index)

		if abs(amplitude) > computed_ratio:
			ratio = computed_ratio
			ordinate_values = []

			for index2 in range(-6, 6):
				ordinate_values.push_back(5 * index2 * computed_ratio / ordinary_factor)

	# Keep only valid values
	for value in ordinate_values:
		if value <= max_y_value and value >= min_y_value:
			result.push_back(value)

	return result

func self_clear_chart():
	max_y_value = 1.0
	min_y_value = 0.0
	clear_chart()

func _update_draw(object = null):
	update()
