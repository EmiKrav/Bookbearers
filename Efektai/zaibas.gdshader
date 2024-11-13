shader_type spatial;
render_mode cull_disabled;

uniform vec4 color : source_color;
uniform vec4 colore : source_color;
uniform sampler2D albedo_texture: source_color; 
uniform sampler2D noise: source_color;
uniform float kampas;

void vertex() {
	
	float cosa = cos(kampas);
	float sina = sin(kampas);
	mat3 rotation_matrix =  mat3(
	  vec3(1.0, 0.0, 0.0),
	   vec3(0.0, cosa, -sina),
	   vec3(0.0, sina, cosa)
	);
	vec3 rotated_vertex =  rotation_matrix * VERTEX;
	vec3 rotated_normals =  rotation_matrix * NORMAL;

	VERTEX =  rotated_vertex;
	NORMAL =  rotated_normals;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex = texture(albedo_texture, UV);
	vec4 tex2 = texture(noise, UV);
	vec4 colo4 = mix(tex, tex2, 1.0);
	
	ALBEDO = tex.rgb;
	ALPHA = tex.a;
	EMISSION = colore.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
