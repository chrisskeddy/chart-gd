extends Control


onready var chart_node = get_node('chart')

func _ready():
	chart_node.initialize(chart_node.LABELS_TO_SHOW.NO_LABEL,
	{
		stock1 = Color(1.0, 0.18, 0.18),
		stock2 = Color(0.58, 0.92, 0.07),
		stock3 = Color(0.5, 0.22, 0.6)
	})
	chart_node.set_labels(7)
	reset()
	set_process(true)



func reset():
	chart_node.create_new_point({
		label = 'January',
		values = {
			stock1 = 500,
			stock2 = 200,
			stock3 = 300
		}
	})

	chart_node.create_new_point({
		label = 'February',
		values = {
			stock1 = 600,
			stock2 = 400,
			stock3 = -250
		}
	})

	chart_node.create_new_point({
		label = 'March',
		values = {
			stock1 = 2000,
			stock2 = 1575,
			stock3 = -450
		}
	})

	chart_node.create_new_point({
		label = 'April',
		values = {
			stock1 = 350,
			stock2 = 750,
			stock3 = -509
		}
	})

	chart_node.create_new_point({
		label = 'May',
		values = {
			stock1 = 1350,
			stock2 = 750,
			stock3 = -100
		}
	})

	chart_node.create_new_point({
		label = 'June',
		values = {
			stock1 = 350,
			stock2 = 1750,
			stock3 = -250
		}
	})

	chart_node.create_new_point({
		label = 'July',
		values = {
			stock1 = 100,
			stock2 = 1500,
			stock3 = -50
		}
	})

	chart_node.create_new_point({
		label = 'August',
		values = {
			stock1 = 350,
			stock2 = 750,
			stock3 = -100
		}
	})

	chart_node.create_new_point({
		label = 'September',
		values = {
			stock1 = 1350,
			stock2 = 750,
			stock3 = -50
		}
	})

	chart_node.create_new_point({
		label = 'October',
		values = {
			stock1 = 350,
			stock2 = 2750,
			stock3 = 100
		}
	})

	chart_node.create_new_point({
		label = 'November',
		values = {
			stock1 = 450,
			stock2 = 200,
			stock3 = 150
		}
	})

	chart_node.create_new_point({
		label = 'December',
		values = {
			stock1 = 1350,
			stock2 = 500,
			stock3 = 200
		}
	})
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
