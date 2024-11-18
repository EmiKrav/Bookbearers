// NOTE: Shader automatically converted from Godot Engine 4.2.2.stable.mono's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color = vec4(1.0,1.0,1.0,1.0);
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap;
uniform float alpha_scissor_threshold = 0.5;
uniform float point_size : hint_range(0,128) = 1;
uniform float roughness : hint_range(0,1) = 1;
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular = 0.5;
uniform float metallic;
uniform vec3 uv1_scale = vec3(1,1,1);
uniform vec3 uv1_offset;
uniform vec3 uv2_scale = vec3(1,1,1);
uniform vec3 uv2_offset;
uniform int hframe : hint_range(1,128);
uniform int vframe : hint_range(1,128);
uniform vec2 current_frame = vec2(0,0);
varying vec3 index;
uniform sampler2D hole : source_color,filter_linear_mipmap;
uniform vec3 duobkord[3];
uniform bool duobe = false;
uniform vec4 holecolor : source_color;

void vertex() {
	mat4 scale_mat = mat4(vec4(0.5, 0.0, 0.0, 0.0), 
	vec4(0.0, 0.5, 0.0, 0.0),
	 vec4(0.0, 0.0, 0.5, 0.0), 
	vec4(0.0, 0.0, 0.0, 0.5));
	
	index = (MODEL_MATRIX * scale_mat * vec4(VERTEX, 1.0)).xyz;
	UV= UV * vec2(uv1_scale.x / 16.0, uv1_scale.y / 16.0) + uv1_offset.xy;
	
}
void fragment() {
	vec2 frame = current_frame;
	frame = vec2(frame.x + index.x, frame.y + index.z);
	vec2 base_uv = (UV / vec2(float(hframe),float(vframe)));
	base_uv += frame / vec2(float(hframe),float(vframe));
	//vec2 base_uv = UV;
	vec2 base_uvduob = vec2(base_uv.x * 16.0, base_uv.y * 16.0);
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	vec4 duobetex = texture(hole, base_uvduob);
	duobetex = mix(duobetex, holecolor, duobetex.a);
	vec4 bled = mix(albedo_tex, duobetex, duobetex.a * 0.0);
	ALBEDO *= albedo_tex.rgb * bled.rgb;;
	ALPHA *= albedo_tex.a * bled.a;
	bled = mix(albedo_tex, duobetex, duobetex.a);
	for(int i = 0; i < 3; i++) { 
	if (duobe && base_uvduob.x - uv1_offset.x <= duobkord[i].x - index.x &&
				 base_uvduob.x - uv1_offset.x >= duobkord[i].x - index.x -2.0 &&
				 base_uvduob.y - uv1_offset.y <= duobkord[i].z - index.z &&
				 base_uvduob.y - uv1_offset.y >= duobkord[i].z - index.z -2.0){
		ALBEDO *= bled.rgb;
		ALPHA *= bled.a ;
	}
	}
		
	
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
	
	
}
