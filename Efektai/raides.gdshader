shader_type spatial;
render_mode cull_disabled;
render_mode blend_add;
//render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;
//render_mode unshaded,blend_add,depth_prepass_alpha,cull_disabled,specular_disabled;

uniform vec4 color : source_color;
uniform vec4 color2 : source_color;
uniform sampler2D albedo_texture: source_color;
uniform int hframe : hint_range(1,128);
uniform int vframe : hint_range(1,128);
uniform int rand1 : hint_range(0,4);
uniform int rand2 : hint_range(0,4);
varying flat int index;

uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;

//uniform vec4 line_color : source_color = vec4(1.0,1.0,1.0,1.0); // Glow or outline color
//uniform float glowSize: hint_range(0.0, 300) = 15.0; // Size of glow
//uniform int glowDensity: hint_range(0, 300) = 30; // How many stamps to repeat in one direction
//uniform int glowRadialCoverage: hint_range(0, 32) = 4; // How many directions to spread out
//uniform float glowAngle: hint_range(0.0, 6.28) = 1.57; // The starting angle. More important if you want to use this as a trail.
//uniform float glowSharpness: hint_range(0.0, 5.0) = 1.0; // Effect how quickly stamps become transparent as they move out
//uniform float alphaThreshold: hint_range(0.0, 1.0) =  0.2; // Alpha level a pixel should be considered a glow

uniform float specular;

void vertex() {
	index = INSTANCE_ID;

}
float random (vec2 st) {
	return float(index) * fract(sin(dot(st.xy, vec2(12.9898,78.233))) 
	* 43758.5453123);
}


void fragment() {
	int ad = int(float(index));
	
	int rnd =rand1;
	int rnd2 = rand2;
	rnd = int(random(vec2(float(rnd),float(rnd2))));
	rnd2 = int(random(vec2(float(rnd),float(rnd2))));
	
	vec2 base_uv = (UV / vec2(float(hframe),float(vframe)));
	vec2 current_frame;
	current_frame.x = float(rnd);
	current_frame.y = float(rnd2);
	base_uv += current_frame/vec2(float(hframe),float(vframe));
	vec4 textur = texture(albedo_texture, base_uv) ;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	//vec4 colo4 = mix(textur, color, 1.0);
	albedo_tex = mix(albedo_tex, color, 1.0);
	vec3 colo4 = mix(color.rgb, color2.rgb, textur.a);
	vec4 colo5 = mix(vec4(colo4, textur.a),vec4(color.rgb, albedo_tex.a), albedo_tex.a);
	ALBEDO = colo4.rgb;
	ALPHA = colo5.a * textur.a * 10.0;
	
	//ALPHA = textur.a;
	//SPECULAR = specular;
	
	////ALPHA /=  bness;
	//vec2 pixel_size = 1.0 / vec2(2.0, 2.0);//vec2(textureSize(tex, 0)); // Set pixel size
	//float alph = 0.0; // Start with a 0 alpha to add to with each check
	//for (int i = 0; i < glowRadialCoverage; i++) { // Goes around in a circle
		//for (int j = 0; j < glowDensity; j++) { // Extends out
			//float radians360 = 6.28;
			//// The angle from which to grab pixel information
			//float angle = (radians360 / float(glowRadialCoverage))*float(i+1) + glowAngle;
			//// The distance to reach to grab pixel information
			//float dist = glowSize * float(j + 1) / float(glowDensity);
			//// Pixel coordinate to grab
			//vec2 pixel_coor = vec2( sin(angle) , cos(angle) );
			//// Gets the pixel based on the previous information
			//
    		////vec4 tex = texture(textur, UV + pixel_coor * pixel_size * dist);
			//base_uv += pixel_coor * pixel_size * dist;
			//// Sharpness. If you don't care about this, enable the next line and delete the next 3
			////alph += tex.a * line_color.a;
			//float distFrom = float(glowDensity-j) / float(glowDensity); // Distance iteration number (how far out)
			//float sharpness = mix(0.0, 1.0, pow(distFrom, glowSharpness) ); // Figure out sharpness level, interplote with distance and Glow Sharpness modifier
			//alph += (textur.a * line_color.a) * sharpness; // Apply sharpness
		//}
	//}
	//vec4 colorg = mix(colo4, line_color, 1.0);
	//ALBEDO = line_color.rgb;
	//EMISSION = line_color.rgb;
	//// Adds outline if this part of the image is transparent
	//if (ALPHA < alphaThreshold){
	//
		////ALBEDO = colorg.rgb;
		//ALPHA = alph;
	//}
	//
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
