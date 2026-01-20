shader_type spatial;
render_mode vertex_lighting;

// This lets you put your texture in the inspector
uniform sampler2D water_texture : filter_linear_mipmap;

// Control the speed here (X direction, Y direction)
uniform vec2 scroll_speed = vec2(0.1, 0.05);

// Control how many times the texture repeats
uniform vec2 texture_scale = vec2(20.0, 20.0);

void fragment() {
	// Calculate the moving position based on TIME
	vec2 moving_uv = (UV * texture_scale) + (scroll_speed * TIME);

	// Apply the texture to the surface
	vec4 color = texture(water_texture, moving_uv);

	ALBEDO = color.rgb;
	// Optional: Make it slightly see-through (0.0 is invisible, 1.0 is solid)
	ALPHA = 0.5;
}