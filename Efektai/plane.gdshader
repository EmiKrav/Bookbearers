shader_type spatial;
render_mode cull_disabled;
//render_mode blend_add;
render_mode unshaded;
uniform float sk = 0.0;
uniform float time = 0.0;



void vertex() {	
	if (VERTEX.x < 0.0  && time > sk ) {
		VERTEX.x -= abs(sin(clamp((time - sk)/10.0, 1.0, 2.0))) * abs(sin((time-sk)*0.75))* 0.25;
	}
	if (VERTEX.x > 0.0  && time > sk) {
		VERTEX.x += abs(sin(clamp((time - sk)/10.0, 1.0, 2.0)))* abs(sin((time-sk)*0.75))* 0.25;
	}
	
	if (VERTEX.z > 0.0 && VERTEX.x == 0.0 && time > sk) {
		VERTEX.z += clamp((time- sk)/5.0, 0, 1.0);
	}
	if (VERTEX.x == 0.0 && time > sk){
		VERTEX.y -= clamp((time - sk)/ 10.0, 0, 1.0);
	}
	
	

}


void fragment() {
	// Called for every pixel the material is visible on.
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
