tool
extends CGChart
class_name CGChartLine

func draw_line_chart():
	var vertical_line = [Vector2(min_x, min_y), Vector2(min_x, min_y + max_y)]
	var horizontal_line = [vertical_line[1], Vector2(min_x + max_x, min_y + max_y)]
	var previous_point = {}

	# Need to draw the 0 ordinate line
	if min_value < 0:
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

			point = point_data.sprites[key].sprite.get_position() + texture_size * global_scale / 2.0

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
	
	_draw_chart_background(pointListObject)

	if current_show_label & LABELS_TO_SHOW.Y_LABEL:
		var ordinate_values = compute_ordinate_values(max_value, min_value)

		for ordinate_value in ordinate_values:
			var label = format(ordinate_value)
			var position = Vector2(max(0, 6.0 -label.length()) * 9.5, min_y + max_y - compute_y(ordinate_value))
			draw_string(label_font, position, label, grid_color)

	draw_line(vertical_line[0], vertical_line[1], grid_color, 1.0)
	draw_line(horizontal_line[0], horizontal_line[1], grid_color, 1.0)
