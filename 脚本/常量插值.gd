@tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeinterpolate
func _get_name():
	return "constant_interpolation"


func _get_category():
	return "MyShaderNodes"


func _get_description():
	return "常量颜色插值"


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_SCALAR


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	match port:
		0:
			return "colorin"
		1:
			return "color0"
		2:
			return "color1"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_3D
		1:
			return VisualShaderNode.PORT_TYPE_VECTOR_3D
		2:
			return VisualShaderNode.PORT_TYPE_VECTOR_3D


func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	return "result"


func _get_output_port_type(port):
	return VisualShaderNode.PORT_TYPE_VECTOR_3D


func _get_global_code(mode):
	return """
		vec3 final_color(vec3 colorin, vec3 color0, vec3 color1) {
			float min_diff=1000.0;
			vec3 result=vec3(0.0);
			for(int i=0;i<3;i++){
				vec3 inter_color=mix(color0,color1,float(i)/2.0);
				float cur_diff=distance(colorin,inter_color);
				if(cur_diff<min_diff){
					min_diff=cur_diff;
					result=inter_color;
				}
			}
			return result;
		}
	"""


func _get_code(input_vars, output_vars, mode, type):
	return output_vars[0] + " = final_color(%s, %s, %s);" % [input_vars[0], input_vars[1], input_vars[2]]
