shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;

uniform int blur_strength = 6;
uniform sampler2D depth_texture : source_color, hint_depth_texture, filter_linear;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;


void vertex() {
  POSITION = vec4(VERTEX,1.0);
}
// Configurable Box Blur by Nighteyes -> https://godotshaders.com/shader/configurable-box-blur/
vec3 blur_size(sampler2D tex,vec2 uv, vec2 pixelSize) {
	pixelSize = 1.0/ pixelSize;
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
	return color / float(count);
}
void fragment() {
	float depth = texture(depth_texture, SCREEN_UV).r;
	depth = depth+0.015; //+ nuotolis
	float z = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2])-3.0;
	//float dz = clamp(z,0.0,1.0);
	float dz = clamp(z,0.0,1.0);
	
	vec3 screen = texture(screen_texture, SCREEN_UV).rgb;
	vec3 blur = blur_size(screen_texture, SCREEN_UV,VIEWPORT_SIZE);
	ALBEDO = mix(blur, screen, dz);
	//ALBEDO += mix(blur, screen,dz*1.005);
}
//
//void fragment() {
  //float depth = texture(depth_texture, SCREEN_UV).x;
  //vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
  //vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
  //view.xyz /= view.w;
  //float linear_depth = -view.z;
//
  //vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
  //vec3 world_position = world.xyz / world.w;
//
  //// Visualize linear depth
  //ALBEDO.rgb = vec3(fract(linear_depth));
//
  //// Visualize world coordinates
  ////ALBEDO.rgb = fract(world_position).xyz;
//}