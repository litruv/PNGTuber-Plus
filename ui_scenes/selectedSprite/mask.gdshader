shader_type canvas_item;

uniform sampler2D mask_texture : source_color;
uniform bool use_mask = false;
uniform float mask_opacity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	// Get the original sprite color
	vec4 sprite_color = texture(TEXTURE, UV);
	
	if (use_mask) {
		// Sample the mask texture
		vec4 mask_sample = texture(mask_texture, UV);
		
		// Use the mask's alpha channel to determine visibility
		float mask_alpha = mask_sample.a * mask_opacity;
		
		// Apply the mask by multiplying the sprite's alpha with the mask alpha
		sprite_color.a *= mask_alpha;
	}
	
	COLOR = sprite_color;
}
