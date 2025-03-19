shader_type canvas_item;

// 用于调色, 可以不要, 参考
uniform sampler2D gradient_fallof : filter_nearest;
render_mode blend_mix;
uniform sampler2D dithstyle;
uniform vec3 Vector3Parameter :source_color= vec3(0.800000, 0.000000, 0.000000);
uniform vec3 Vector3Parameter2 :source_color= vec3(0.200000, 0.000000, 0.000000);
uniform vec2 w_bzd_a=vec2(512,512);
//uniform float dith_level:hint_range(0.0, 1.0)=1.0;

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
vec3 soft_light(vec3 base, vec3 blend){
	return mix(
    base * (blend + 0.5),                     // base < 0.5 的情况
    1.0 - (1.0 - base) * (1.0 - (blend - 0.5)), // base >= 0.5 的情况
    step(vec3(0.5), base));
}
void light() {
	// 以余弦作为光照强度, 结果是 [-1, 1] 之间. 取 max 防止负数
	float calculated_light_value = max(0.0, dot(NORMAL, LIGHT_DIRECTION));
	// 计算光照强度并钳制在 0.5 - 0.95 之间防止强度过高或过低
	float sample = clamp(calculated_light_value * LIGHT_ENERGY, 0.05, 0.95);
	// 沿水平方向采样进一步调制
	vec4 shaded_texture = texture(gradient_fallof, vec2(sample, 0));
	// 光照后的最终颜色
	vec4 color = vec4(LIGHT_COLOR.rgb * COLOR.rgb * shaded_texture.rgb, LIGHT_COLOR.a);
	
	// 如果不要梯度色带则使用 sample. 
	//vec4 color = vec4(LIGHT_COLOR.rgb * COLOR.rgb * sample, LIGHT_COLOR.a);
	
	// rarepaper 稀有纸张的代码
	vec3 n_out7p0= color.xyz;
	vec3 n_out2p0 = texelFetch(dithstyle,ivec2((UV*w_bzd_a))%2,0).xyz;

	//柔光
	vec3 n_out6p0=soft_light(n_out7p0,n_out2p0);
	vec3 f_color = final_color(n_out6p0, Vector3Parameter, Vector3Parameter2);
	LIGHT = vec4(f_color.x, f_color.y, f_color.z, color.a);
}

