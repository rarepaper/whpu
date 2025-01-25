shader_type canvas_item;
render_mode blend_mix;
uniform sampler2D dithstyle;
uniform vec3 Vector3Parameter :source_color= vec3(0.800000, 0.000000, 0.000000);
uniform vec3 Vector3Parameter2 :source_color= vec3(0.200000, 0.000000, 0.000000);
uniform float dith_level:hint_range(0.0, 1.0)=1.0;

// constant_interpolation
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

void fragment() {
	vec4 n_out7p0= texture(TEXTURE, UV);
	vec2 n_out15p0 = vec2(UV/ TEXTURE_PIXEL_SIZE);
	vec4 n_out2p0 = texelFetch(dithstyle,ivec2(n_out15p0)%2,0);

//柔光
	vec3 n_out6p0;
	{
		float base = vec3(n_out7p0.xyz).x;
		float blend = vec3(n_out2p0.xyz).x;
		if (base < 0.5) {
			n_out6p0.x = mix(base,(base *(blend + 0.5)),dith_level);
		} else {
			n_out6p0.x = mix(base,(1.0 - (1.0 - base) * (1.0 - (blend - 0.5))),dith_level);
		}
	}
	{
		float base = vec3(n_out7p0.xyz).y;
		float blend = vec3(n_out2p0.xyz).y;
		if (base < 0.5) {
			n_out6p0.y = mix(base,(base *(blend + 0.5)),dith_level);
		} else {
			n_out6p0.y = mix(base,(1.0 - (1.0 - base) * (1.0 - (blend - 0.5))),dith_level);
		}
	}
	{
		float base = vec3(n_out7p0.xyz).z;
		float blend = vec3(n_out2p0.xyz).z;
		if (base < 0.5) {
			n_out6p0.z = mix(base,(base *(blend + 0.5)),dith_level);
		} else {
			n_out6p0.z = mix(base,(1.0 - (1.0 - base) * (1.0 - (blend - 0.5))),dith_level);
		}
	}
// Vector3Parameter:8
	vec3 n_out8p0 = Vector3Parameter;
// Vector3Parameter:9
	vec3 n_out9p0 = Vector3Parameter2;
	COLOR.rgb =final_color(n_out6p0, n_out8p0, n_out9p0);
}
