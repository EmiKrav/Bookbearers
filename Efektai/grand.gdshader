shader_type spatial;
render_mode unshaded;
//render_mode cull_disabled;
//render_mode specular_disabled;

varying vec3 vertex_uv;
uniform float sk = 0.0;
uniform float time = 0.0;
uniform float opacityy = 0.5;
uniform float opacityxz = 0.5;

uniform float outline_widthxz : hint_range(0.000, 1.000, 0.001) = 0.001;
uniform float outline_widthy : hint_range(0.000, 1.000, 0.001) = 0.001;

uniform vec4 base_colorxz : source_color = vec4(1.0);
uniform vec4 base_colory : source_color = vec4(1.0);

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


void fragment() {

	float basic_fresnely = max(vertex_uv.x-0.99-vertex_uv.z-0.999,0.0-vertex_uv.x-0.99-vertex_uv.z-0.999);
	float basic_fresnelyy = max(vertex_uv.x-0.99+vertex_uv.z-0.999,0.0-vertex_uv.x-0.99+vertex_uv.z-0.999);
	float basic_fresnel1 = max(vertex_uv.x-0.99-vertex_uv.y-0.05,0.0-vertex_uv.x-0.99-vertex_uv.y-0.05);
	float basic_fresnel2 = max(vertex_uv.x-0.99+vertex_uv.y-0.05,0.0-vertex_uv.x-0.99+vertex_uv.y-0.05);
	float basic_fresnel3 = max(vertex_uv.z-0.99-vertex_uv.y-0.05,0.0-vertex_uv.z-0.99-vertex_uv.y-0.05);
	float basic_fresnel4 = max(vertex_uv.z-0.99+vertex_uv.y-0.05,0.0-vertex_uv.z-0.99+vertex_uv.y-0.05);
	float galutinis=max(basic_fresnel1,basic_fresnel3);
	float galutinis2=max(basic_fresnel2,basic_fresnel4);
	float galutinis3=max(galutinis,galutinis2);
	float galutinis4=max(basic_fresnely,basic_fresnelyy);
	if (galutinis3 + outline_widthxz> 0.0 && vertex_uv.x<0.99 && vertex_uv.x>-0.99  && vertex_uv.z<0.99 && vertex_uv.z>-0.99) {
		ALBEDO = base_colory.rgb;
        ALPHA = opacityy;
	}
	if (galutinis4 + outline_widthy> 0.0 && vertex_uv.x >0.99) {
		ALBEDO = base_colorxz.rgb;
        ALPHA = opacityy;
	}
	if (galutinis4 + outline_widthy> 0.0 && vertex_uv.x <-0.99) {
		ALBEDO = base_colorxz.rgb;
        ALPHA = opacityy;
	}
	if (galutinis4 + outline_widthy> 0.0 && vertex_uv.z >0.99) {
		ALBEDO = base_colorxz.rgb;
        ALPHA = opacityy;
	}
	if (galutinis4 + outline_widthy> 0.0 && vertex_uv.z <-0.99) {
		ALBEDO = base_colorxz.rgb;
        ALPHA = opacityy;
	}
	
}