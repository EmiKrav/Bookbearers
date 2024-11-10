shader_type spatial;
render_mode cull_disabled;

uniform vec4 color : source_color;
uniform sampler2D albedo_texture: source_color; 
uniform int hframe : hint_range(1,128);
uniform int vframe : hint_range(1,128);

void vertex() {
	// Called for every vertex the material is visible on.
}
float random (vec2 st) {
    return TIME / 7.0 * fract(sin(dot(st.xy,
                      vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	int rnd = int(random(vec2(float(hframe),float(vframe)))*10.0);
	int rnd2 = int(random(vec2(float(hframe),float(vframe)))*10.0);
	
	vec2 base_uv = (UV / vec2(float(hframe),float(vframe)));
	vec2 current_frame;
	current_frame.x = float(rnd);
	current_frame.y = float(rnd2);
	base_uv += current_frame/vec2(float(hframe),float(vframe));
	vec4 tex = texture(albedo_texture,base_uv);
	ALBEDO = tex.rgb;
	ALPHA = tex.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
