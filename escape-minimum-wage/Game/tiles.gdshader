shader_type canvas_item;

uniform sampler2D image_texture;
uniform vec2 rect_size = vec2(100,100);
uniform vec2 tile_size = vec2(100,100);
uniform float scale : hint_range(0.0, 1.0) = 1.0;

uniform vec2 offset = vec2(0,0);
uniform vec2 zoom = vec2(1,1);

void fragment() {
	COLOR = texture(image_texture, mod(((((UV * rect_size) + (offset * zoom)) / tile_size) / scale), 1));
}