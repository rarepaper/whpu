shader_type canvas_item;
uniform float dith_level:hint_range(0.0, 1.0);
uniform float dith_offset:hint_range(0.0, 1.0);
uniform vec4 colors[5]:source_color;
//这是废稿 
bool dither_rule(ivec2 pos){
	return (pos.x + pos.y) % 2 == 0;
}

void fragment() 
{
	vec4 temp = textureLod(TEXTURE , UV, 0.0);
	if(temp.a>0.0){
	float min_diff1 = 1000.0;
	float min_diff2 = 1000.0;
	int min_index1 = -1; // 第一个最近颜色的索引
	int min_index2 = -1; // 第二个最近颜色的索引
	for (int i = 0; i < colors.length(); i++) 
	{
		float curr_dist = distance(colors[i], temp);
		if (curr_dist < min_diff1) 
		{
			min_diff2 = min_diff1; 
			min_index2 = min_index1; 
			min_diff1 = curr_dist; 
			min_index1 = i; 
		}
		else if(curr_dist<min_diff2)
		{
			min_diff2 = curr_dist;
			min_index2 = i;
		}
	}
	vec4 dither_color=mix(colors[min_index1],colors[min_index2],0.5);
	if(distance(colors[min_index1], temp)*dith_level>=distance(dither_color,temp)){
		ivec2 pos=ivec2(UV/TEXTURE_PIXEL_SIZE);
		COLOR= dither_rule(pos) ? colors[min_index1]:colors[min_index2];
	}
	else {
		COLOR = colors[min_index1];
	}
}
}


