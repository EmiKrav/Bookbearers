
// NOTE: Shader automatically converted from Godot Engine 4.2.2.stable.mono's FogMaterial.

shader_type fog;

uniform float density : hint_range(0, 1, 0.0001) = 1.0;
uniform vec4 albedo : source_color = vec4(1.0);
uniform vec4 emission : source_color = vec4(0, 0, 0, 1);
uniform float height_falloff = 0.0;
uniform float edge_fade = 0.1;
uniform sampler3D density_texture: hint_default_white;
uniform sampler2D noisetex: repeat_enable;
uniform float flatn;
uniform float dens;
uniform float rad;


void fog() {
	vec2 ran = vec2(0.2,0) * TIME;
	float l = length(WORLD_POSITION-OBJECT_POSITION);
	vec3 size = SIZE;
	
	float noise = texture(noisetex,WORLD_POSITION.xz*0.02 +ran).r;

	DENSITY = mix(1.0,noise,UVW.y * flatn);
	DENSITY *= 1.0 - step(rad * abs(sin(clamp(TIME/5.0, 0.0, 1.0))),l);
	DENSITY *= step(0.5,-SDF)*dens;
	
	DENSITY *= smoothstep(0.0,0,-SDF);
   // DENSITY = density * clamp(exp2(-height_falloff * (WORLD_POSITION.y - OBJECT_POSITION.y)), 0.0, 1.0);
    //DENSITY *= texture(density_texture, UVW).r;
    //DENSITY *= pow(clamp(-2.0 * SDF / min(min(size.x, size.y), size.z), 0.0, 1.0), edge_fade);
	ALBEDO = albedo.rgb;
    EMISSION = emission.rgb;
}




