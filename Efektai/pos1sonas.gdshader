shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;

uniform int blur_strength = 6;
uniform sampler2D depth_texture : source_color, hint_depth_texture, filter_linear;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float radius = 0.2; 
uniform float feather = 0.05;


float mask(vec2 uv, float _radius, float _feather) {
    float dist = distance(uv.x, 0.5); // Distance from current pixel to the center
    float dist2 = distance(uv.y, 0.58); // Distance from current pixel to the center
	return smoothstep(_radius, _radius - _feather,distance(vec2(dist*2.5,dist2/1.7),vec2(0.0,0.0)));
	//return smoothstep(_radius, _radius - _feather, dist+0.12); // Smooth transition
}

void vertex() {
  POSITION = vec4(VERTEX,1.0);
}
// Configurable Box Blur by Nighteyes -> https://godotshaders.com/shader/configurable-box-blur/
vec3 blur_size(sampler2D tex,vec2 uv, vec2 pixelSize) {
	pixelSize =  1.0/pixelSize;
	vec2 pixel = uv / pixelSize;
	int x_min = max(int(pixel.x) - blur_strength, 0);
	int y_min = max(int(pixel.y) - blur_strength, 0);
	int x_max = min(int(pixel.x) + blur_strength, int(1.0 / pixelSize.x));
	int y_max = min(int(pixel.y) + blur_strength, int(1.0 / pixelSize.y));
	
	int count = 0;
	vec3 color = vec3(0.0);
	for(int x = x_min; x <= x_max; x++) {
		for(int y = y_min; y <= y_max; y++) {           
			color += texture(tex, vec2(float(x), float(y)) * pixelSize).rgb;
			count++;
		}
	}
	return color/ float(count);
}
void fragment() {
	//float depth = texture(depth_texture, SCREEN_UV).r;
	//depth = depth-0.05; //+ nuotolis
	//float z = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2])-2.0;
	//float dz = clamp(z,0.0,1.0);
	//float dz = clamp(z,0.0,1.0);
	
	vec3 screen = texture(screen_texture, SCREEN_UV).rgb;
	vec3 blur = blur_size(screen_texture, SCREEN_UV,VIEWPORT_SIZE);
	
	ALBEDO = mix(blur, screen, 0.1);
	float circ = 1.0-mask(SCREEN_UV, radius, feather); 
	ALPHA = circ; 
}