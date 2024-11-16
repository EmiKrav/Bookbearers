shader_type spatial;
render_mode cull_disabled;
render_mode blend_add;
render_mode unshaded;
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

uniform float specular;
uniform vec3 scale = vec3(1,1,1);

void vertex() {
	index = INSTANCE_ID;
	NORMAL = vec3(0.0, 1.0, 0.0);
	VERTEX.x += sin(NODE_POSITION_WORLD.x + TIME * 0.3 + UV.y) * ( 1.0 - UV.y) * 0.2;
	VERTEX.z += cos(NODE_POSITION_WORLD.z + TIME * 0.3 + UV.y) * ( 1.0 - UV.y) * 0.2;
	vec3 sc = scale;
	
	//sc.x *= abs(sin(TIME / 5.0))+0.5;
	//sc.y *= abs(sin(TIME / 1.0));
	//sc.z *= abs(sin(TIME / 1.0));
	VERTEX = VERTEX * vec3(sc.x, scale.y, scale.z);
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
	
}
float random (vec2 st) {
	return float(index) * fract(sin(dot(st.xy, vec2(12.9898,78.233))) 
	* 43758.5453123);
}


void fragment() {
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
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
