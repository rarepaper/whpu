extends Node2D
func _input(event):
	if event is InputEventMouseMotion:
		$SubViewport.push_input(event)
