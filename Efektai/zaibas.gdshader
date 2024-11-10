shader_type spatial;

uniform vec4 color : source_color;
uniform vec4 colore : source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = color.rgb;
	ALPHA = color.a;
	EMISSION = colore.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
