shader_type spatial;
render_mode cull_disabled;
render_mode blend_add;
render_mode unshaded;

void vertex() {	
	
	if (VERTEX.x < 0.0  ) {
		VERTEX.x -= abs(sin(clamp(TIME/5.0, 0.0, 1.0))) * abs(sin(TIME*1.5))* 0.25;
	}
	if (VERTEX.x > 0.0  ) {
		VERTEX.x += abs(sin(clamp(TIME/5.0, 0.0, 1.0)))* abs(sin(TIME*1.5))* 0.25;
	}
	
	if (VERTEX.z > 0.0 && VERTEX.x == 0.0 ) {
		VERTEX.z += abs(sin(clamp(TIME/5.0, 0.0, 1.0) *1.0));
	}
	if (VERTEX.x == 0.0){
		VERTEX.y -= abs(sin(clamp(TIME/5.0, 0.0, 1.0) *2.0));
	}
	

}


void fragment() {
	// Called for every pixel the material is visible on.
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
