shader_type spatial;
//render_mode cull_disabled;
//render_mode blend_add;
render_mode unshaded;
uniform float sk = 0.0;
uniform float time = 0.0;
varying vec3 vertex_uv;
uniform float opacityy = 0.5;
uniform float opacityxz = 0.5;

uniform float outline_widthxz : hint_range(0.000, 1.000, 0.001) = 0.001;
uniform float outline_widthy : hint_range(0.000, 1.000, 0.001) = 0.001;

uniform vec4 base_colorxz : source_color = vec4(1.0);
uniform vec4 base_colory : source_color = vec4(1.0);

void vertex() {	
	vertex_uv = (vec4(VERTEX, 1.0)).xyz;
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
	float viduriukas = max(vertex_uv.x-vertex_uv.z-0.99,0.0-vertex_uv.x-vertex_uv.z-0.99);
	float viduriukas2 = max(vertex_uv.x+vertex_uv.z-0.99,0.0-vertex_uv.x+vertex_uv.z-0.99);
	
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
	if (viduriukas +outline_widthy> 0.0 && vertex_uv.x<-0.0&& vertex_uv.x>-0.01) {
		ALBEDO = base_colorxz.rgb;
        ALPHA = opacityy;
	}
	if (viduriukas2 +outline_widthy> 0.0 && vertex_uv.x<-0.0&& vertex_uv.x>-0.01) {
		ALBEDO = base_colorxz.rgb;
        ALPHA = opacityy;
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
