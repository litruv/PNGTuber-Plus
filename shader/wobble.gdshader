shader_type canvas_item;

uniform sampler2D noise_texture: source_color, repeat_enable;
uniform float distortion_strengh: hint_range(0, 0.1) = 0.01;
uniform float speed: hint_range(0.1, 10) = 1.0;
uniform bool use_noise_texture: hint_default_true = false;

void fragment() {
	vec2 uv_offset = vec2(0.0);
	
	if (use_noise_texture) {
		vec4 noise_pixel = texture(noise_texture, UV + floor(TIME * speed) / 3.0);
		uv_offset = (noise_pixel.rg * 2.0 - 1.0) * distortion_strengh;
	} else {
		// Fallback procedural noise when no texture is provided
		float noise = sin(UV.x * 20.0 + TIME * speed) * cos(UV.y * 20.0 + TIME * speed * 0.7);
		uv_offset = vec2(noise) * distortion_strengh;
	}
	
	COLOR = texture(TEXTURE, UV + uv_offset);
}