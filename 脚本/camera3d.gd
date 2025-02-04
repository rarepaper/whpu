extends Camera3D
@export var start_pos:=Vector3(1,1,1)
var v_zoom=0.2
var target_pos=Vector3(0,0,0)
var mouse_sens=0.01
var r
var r_y

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("drag"):
		var mouse_delta = event.relative * mouse_sens
		r_y=sqrt(r*r-position.y*position.y)
		var ang_end_lat=atan2(position.z , position.x)+atan2(mouse_delta.x,1)
		position.x=cos(ang_end_lat)*r
		position.z=sin(ang_end_lat)*r
		var ang_end_lon=asin(position.y / r)+atan2(mouse_delta.y,1)
		position.y=sin(ang_end_lon)*r
		var a=cos(asin(position.y / r))/cos(atan2(mouse_delta.y,1))
		position.x*=a
		position.z*=a
		fansuo()

func _ready():
	position=start_pos
	r=position.distance_to(target_pos)
	pass # Replace with function body.
# Called every frame. 'rarepaper' is a bilibili up,he wrote the terrible code.

func fansuo():
	look_at(target_pos,Vector3.UP)
	if Input.is_action_just_pressed("amp"):
		position.x*=(1+v_zoom)
		position.y*=(1+v_zoom)
		position.z*=(1+v_zoom)
		r=position.distance_to(target_pos)
	if r>1:
		if Input.is_action_just_pressed("min"):
			position.x*=(1-v_zoom)
			position.y*=(1-v_zoom)
			position.z*=(1-v_zoom)
			r=position.distance_to(target_pos)
	pass
