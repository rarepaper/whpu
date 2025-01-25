extends Node
signal input_a
func _input(event):
	input_a.emit(event)
