shader_type spatial;
render_mode cull_disabled;
//render_mode blend_add;
render_mode unshaded;
uniform float sk = 0.0;


float timeprabego(){
	return TIME / 10.0;
}

float skaicius(){
	float som = 0.0;
	som += (TIME - sk)/ 10.0 ;
	return som;
}

void vertex() {	

	if (VERTEX.x < 0.0  && TIME > sk ) {
		VERTEX.x -= abs(sin(clamp(TIME/5.0 - sk/5.0, 1.0, 2.0))) * abs(sin(TIME*1.5-sk*1.5))* 0.25;
	}
	if (VERTEX.x > 0.0  && TIME > sk) {
		VERTEX.x += abs(sin(clamp(TIME/5.0 - sk/5.0, 1.0, 2.0)))* abs(sin(TIME*1.5-sk*1.5))* 0.25;
	}
	
	if (VERTEX.z > 0.0 && VERTEX.x == 0.0 && TIME > sk) {
		VERTEX.z += clamp(TIME/5.0- sk/5.0, 0, 1.0);
	}
	if (VERTEX.x == 0.0 && TIME > sk){
		VERTEX.y -= clamp(skaicius(), 0, 1.0);
	}
	
	

}


void fragment() {
	// Called for every pixel the material is visible on.
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
