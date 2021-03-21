extends Control


onready var chart_graph = get_node("ChartGraph")
var rng = RandomNumberGenerator.new()
var x = 0
func _ready():
	chart_graph.initialize(chart_graph.LABELS_TO_SHOW.NO_LABEL,
	{
		depenses = Color(1.0, 0.18, 0.18),
		recettes = Color(0.58, 0.92, 0.07),
		interet = Color(0.5, 0.22, 0.6)
	})
	chart_graph.set_labels(7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	chart_graph.create_new_point({
		label = String(x),
		values = {
		  recettes = rng.randi_range(-50,50)
		}
	})
	x = x + 1
