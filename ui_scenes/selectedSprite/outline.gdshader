shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 0.3);

void fragment(){
	vec4 tex = texture(TEXTURE, UV);
	COLOR = vec4(outline_color.rgb, tex.a * outline_color.a);
}