extends Control


onready var chart_graph = get_node("CGLine")
var rng = RandomNumberGenerator.new()
var x = 0
func _ready():
	chart_graph.initialize(chart_graph.LABELS_TO_SHOW.NO_LABEL,
	{
		stock = Color(0.58, 0.92, 0.07)
	})
	chart_graph.set_labels(7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	chart_graph.create_new_point({
		label = String(x),
		values = {
		  stock = rng.randi_range(-50,50)
		}
	})
	x = x + 1
