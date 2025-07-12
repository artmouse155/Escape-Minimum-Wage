shader_type canvas_item;

uniform vec4 color : source_color;

float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, dot(position, position) * 4.0);
}

void fragment() {
	COLOR = color;
	COLOR.a = 1.0 - circle(UV - vec2(.5,.5), .8, 0.1);
}

