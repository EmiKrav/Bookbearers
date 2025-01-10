shader_type canvas_item;

uniform vec4 color_gap: source_color = vec4(0.25);
uniform vec4 color_stripe: source_color = vec4(1.0, 0.75, 0.0, 1.0);
uniform float time = 0.0;
uniform float sk = 0.0;
void fragment() {
	
	float w = 0.0;
	float w2 = 0.0;
	
	float dist = distance(UV.x, 0.5); 
    float dist2 = distance(UV.y, 0.0); 
	float radius = clamp((time-sk)/5.5, 0.0, 1.25);
	float blury = 0.01;
	w += smoothstep(radius, radius-blury, distance(vec2(dist*5.0,dist2*5.0),vec2(clamp((time-sk)/3.0, 0.0, 2.5),0.0)));
	w += smoothstep(radius, radius -blury, distance(vec2(dist*5.0,dist2*5.0),vec2(clamp((time-sk)/3.0, 0.0, 2.5),5.0)));
	w2 += smoothstep(radius, radius -blury, distance(vec2(dist*5.0,dist2*5.0),vec2(clamp((time-sk)/3.0, 0.0, 2.5),2.5)));
	w += smoothstep(radius, radius -blury, distance(vec2(dist*2.0,dist2*5.0),vec2(clamp(1.0-(time-sk)/3.0, 0.0, 2.0),2.5)));
	
	if (w > 0.0){
		COLOR += color_stripe*w;
	}
	if (w > 0.0 && w2 > 0.0){
		COLOR = color_gap*w;
	}
	else{
		COLOR = color_stripe*w;
	}
	
}