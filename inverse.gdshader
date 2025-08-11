shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment()
{
	float r = 1.0 - texture(SCREEN_TEXTURE, SCREEN_UV).r;
	float g = 1.0 - texture(SCREEN_TEXTURE, SCREEN_UV).g;
	float b = 1.0 - texture(SCREEN_TEXTURE, SCREEN_UV).b;
	
	COLOR = vec4(r,g,b,1.0);
}