tool
extends EditorPlugin

func _enter_tree():
# Initialization of the plugin goes here
	add_custom_type("ChartGraph", "ReferenceRect", load("res://addons/GDCharts/plugin.gd"), load("res://addons/GDCharts/icon.png"))

func _exit_tree():
# Clean-up of the plugin goes here
	remove_custom_type("ChartGraph")

