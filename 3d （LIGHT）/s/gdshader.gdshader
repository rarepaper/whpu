shader_type spatial;
uniform sampler2D dithstyle;
uniform vec3 Vector3Parameter :source_color= vec3(0.800000, 0.8, 0.8);
uniform vec3 Vector3Parameter2 :source_color= vec3(0.200000, 0.2, 0.2);

vec3 soft_light(vec3 base, vec3 blend){
	return mix(
    base * (blend + 0.5),                     // base < 0.5 的情况
    1.0 - (1.0 - base) * (1.0 - (blend - 0.5)), // base >= 0.5 的情况
    step(vec3(0.5), base));
}
vec3 final_color(vec3 colorin, vec3 color0, vec3 color1) {
    float min_diff = 1000.0;
    vec3 result = vec3(0.0);
    const int num_interpolation_points = 3;
    for (int i = 0; i < num_interpolation_points; i++) {
        float t = float(i) / float(num_interpolation_points - 1);
        vec3 inter_color = mix(color0, color1, t);
        float cur_diff = distance(colorin, inter_color);
        if (cur_diff < min_diff) {
            min_diff = cur_diff;
            result = inter_color;
        }
    }
    return result;
}    
void light() {
	vec3 blend = texelFetch(dithstyle,ivec2(SCREEN_UV*VIEWPORT_SIZE)%2,0).xyz;
	vec3 base = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR / PI;
	vec3 step1 = soft_light(base,blend);
	DIFFUSE_LIGHT +=final_color(step1,Vector3Parameter,Vector3Parameter2);
}
