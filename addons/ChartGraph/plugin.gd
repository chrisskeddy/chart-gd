tool
extends EditorPlugin

func _enter_tree():
# Initialization of the plugin goes here
	add_autoload_singleton("CGUtilities","res://addons/ChartGraph/core/utilities.gd")
	add_custom_type("ChartGraph", "ReferenceRect", load("res://addons/ChartGraph/script.gd"), preload("res://addons/ChartGraph/assets/icons/chartgraph_line.svg"))

func _exit_tree():
# Clean-up of the plugin goes here
	remove_custom_type("ChartGraph")

