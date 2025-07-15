shader_type canvas_item;

uniform vec4 color : source_color;
uniform float radius = 0.8;
uniform float thickness = 0.1;
uniform float opacity = 1.0;

float circle(vec2 position, float _radius, float feather)
{
	return smoothstep(_radius, _radius + feather, dot(position, position) * 4.0);
}

void fragment() {
	COLOR = color;
	COLOR.a = opacity * (circle(UV - vec2(.5,.5), radius - thickness, 0.1) - circle(UV - vec2(.5,.5), radius, 0.1));
}
