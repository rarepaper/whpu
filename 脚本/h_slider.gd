extends HSlider
@onready var sprite_2d = $"../Sprite2D"


func _on_value_changed(_value):
	sprite_2d.material.set_shader_parameter("dith_offset",value)
