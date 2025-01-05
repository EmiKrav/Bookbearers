shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

varying vec3 vertex_uv;
uniform float sk = 0.0;
uniform float time = 6.0;



void vertex() {
	vertex_uv = (vec4(VERTEX, 1.0)).xyz;
	float inz = VERTEX.z;
	float inz2 = VERTEX.z;
	
	if (VERTEX.z < distance(vec2(vertex_uv.x/1.5,vertex_uv.z/1.5),vec2(0.0,0.0))&& time > sk){
		//VERTEX.y -= 0.5;
		//
		
		//VERTEX.z -= 0.5-distance(vec2(vertex_uv.x*2.0,vertex_uv.z/1.5),vec2(0.0,0.0));
	 	inz = VERTEX.z;
		VERTEX.z -= clamp(0.5-distance(vec2(vertex_uv.x*((time-sk)/10.0),vertex_uv.z*((time-sk))/10.0),vec2(0.0,0.0)),
		(0.5-distance(vec2(vertex_uv.x*2.0,vertex_uv.z/1.5),vec2(0.0,0.0))),
		-inz-1.0
		//,(0.5-distance(vec2(vertex_uv.x*2.0,vertex_uv.z/1.5),vec2(0.0,0.0)))
		);
		
	}
	if (VERTEX.z > 0.5 && (VERTEX.x > -0.75 && VERTEX.x < 0.75 && time > sk + 10.0)){
		//VERTEX.z -= 2.0-distance(vec2(vertex_uv.x*2.0,vertex_uv.z/2.5),vec2(0.0,-0.4));
		
		VERTEX.z -= clamp(abs((time -sk- 10.0)/-10.0),-inz2,(2.0-distance(vec2(vertex_uv.x*2.0,vertex_uv.z/2.5),vec2(0.0,-0.4))));
		
		}
	//if (VERTEX.z > 1.5-distance(vec2(vertex_uv.x,vertex_uv.z),vec2(0.0,0.0))){
		//VERTEX.y = -0.5;
		//VERTEX.z = 1.5-distance(vec2(vertex_uv.x,vertex_uv.z),vec2(0.0,0.0));
	//}
	//if (VERTEX.x< -1.5+distance(vec2(vertex_uv.x,vertex_uv.z),vec2(0.0,0.0))){
		//VERTEX.y = -0.5;
		//VERTEX.x = -1.5+distance(vec2(vertex_uv.x,vertex_uv.z),vec2(0.0,0.0));
	//}
	//if (VERTEX.x> +1.5-distance(vec2(vertex_uv.x,vertex_uv.z),vec2(0.0,0.0))){
		//VERTEX.y = -0.5;
		//VERTEX.x =  +1.5-distance(vec2(vertex_uv.x,vertex_uv.z),vec2(0.0,0.0));
	//}
	
}


//void fragment() {

//}