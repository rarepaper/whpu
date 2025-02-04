extends HSlider
@export var sprite_2d:Node2D


func _on_value_changed(_value):
	sprite_2d.material.set_shader_parameter("dith_level",value)
