// Render mode
shader_type spatial;
render_mode cull_back, depth_draw_opaque,diffuse_lambert_wrap,vertex_lighting,specular_disabled,shadows_disabled;


// Constants
#if !defined(OVERRIDE_VERTEX_SNAP_RESOLUTION)
	const ivec2 VERTEX_SNAP_RESOLUTION = ivec2(320, 240);
#endif


// Global uniforms

global uniform bool affine_texture_mapping;
global uniform bool texture_filtering;
global uniform float texture_lod_halve_distance;


#if defined(OVERRIDE_VERTEX_SNAP_RESOLUTION)
	global uniform ivec2 vertex_snap_resolution;
#else
	global uniform int vertex_snap_intensity;
#endif

global uniform float cull_distance;

uniform vec3 albedo_color : source_color = vec3(1.0);


uniform sampler2D albedo_texture :source_color, filter_nearest,
	#if defined(TEXTURE_REPEAT)
		repeat_enable;
	#else
		repeat_disable;
	#endif

uniform bool albedo_texture_as_primary_color = true;
uniform float mix_factor: hint_range(0.0, 1.0, 0.01) = 1.0;

uniform float texture_lod_halve_distance_override : hint_range(0.0, 32.0, 2.0) = 0;

uniform vec2 uv_offset = vec2(0.0);
uniform vec2 uv_scale = vec2(1.0);
uniform vec2 uv_scroll_speed = vec2(0.0);


#if defined(BILLBOARD)
	uniform int billboard_mode: hint_range(0, 2);
	uniform bool use_transform_scale = true;
#endif

uniform float cull_distance_override: hint_range(0.0, 1024.0, 2.0) = 0;

varying float position_w;

varying flat int should_halve_texture_lod;


// Functions
#if defined(SHINY)
	vec3 glimmer(vec3 input)
	{
		float grayscale = max(vec3(input).r, max(vec3(input).g, vec3(input).b));
		float lower = floor(grayscale * color_depth) / color_depth;
		float lower_difference = abs(grayscale - lower);
		float upper = ceil(grayscale * color_depth) / color_depth;
		float upper_difference = abs(upper - grayscale);
		float level = lower_difference <= upper_difference ? lower : upper;
		float adjustment = level / grayscale;
		return vec3(input) * adjustment;
	}
#elif !defined(TEXTURE_DISABLED)
	vec4 albedoTextureFiltered(vec2 uv)
	{
		vec2 albedo_texture_size = vec2(textureSize(albedo_texture, 0));

		vec2 tex_pix_a = vec2(1.0 / albedo_texture_size.x, 0.0);
		vec2 tex_pix_b = vec2(0.0, 1.0 / albedo_texture_size.y);
		vec2 tex_pix_c = vec2(tex_pix_a.x,tex_pix_b.y);
		vec2 half_tex = vec2(tex_pix_a.x * 0.5, tex_pix_b.y * 0.5);
		vec2 uv_centered = uv - half_tex;

		vec4 diffuse_color = texture(albedo_texture, uv_centered);
		vec4 sample_a = texture(albedo_texture, uv_centered + tex_pix_a);
		vec4 sample_b = texture(albedo_texture, uv_centered + tex_pix_b);
		vec4 sample_c = texture(albedo_texture, uv_centered + tex_pix_c);

		float interp_x = modf(uv_centered.x * albedo_texture_size.x, albedo_texture_size.x);
		float interp_y = modf(uv_centered.y * albedo_texture_size.y, albedo_texture_size.y);

		if (uv_centered.x < 0.0)
		{
			interp_x = 1.0 - interp_x * -1.0;
		}
		if (uv_centered.y < 0.0)
		{
			interp_y = 1.0 - interp_y * -1.0;
		}

		diffuse_color = (
			diffuse_color +
			interp_x * (sample_a - diffuse_color) +
			interp_y * (sample_b - diffuse_color)) *
			(1.0 - step(1.0, interp_x + interp_y));

		diffuse_color += (
			(sample_c + (1.0 - interp_x) * (sample_b - sample_c) +
			(1.0 - interp_y) * (sample_a - sample_c)) *
			step(1.0, interp_x + interp_y));

	    return diffuse_color;
	}
#endif

void vertex()
{
	UV = UV * uv_scale + uv_offset + (uv_scroll_speed * TIME);

	#if defined(BILLBOARD)
		if (billboard_mode > 0)
		{
			if (billboard_mode == 1)
			{
				MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
					INV_VIEW_MATRIX[0],
					INV_VIEW_MATRIX[1],
					INV_VIEW_MATRIX[2],
					MODEL_MATRIX[3]);
			}
			else
			{
				MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
					vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0),
					vec4(0.0, 1.0, 0.0, 0.0),
					vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
					MODEL_MATRIX[3]);
			}

			if (use_transform_scale)
			{
				MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(
					vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
					vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
					vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
					vec4(0.0, 0.0, 0.0, 1.0));
			}

			MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
		}
	#endif

	float vertex_distance = length((MODELVIEW_MATRIX * vec4(VERTEX, 1.0)));


	float actual_texture_lod_halve_distance = texture_lod_halve_distance_override > 0.0 ? texture_lod_halve_distance_override : texture_lod_halve_distance;

	should_halve_texture_lod = (!texture_filtering && actual_texture_lod_halve_distance > 0.0 && vertex_distance > actual_texture_lod_halve_distance) ? 1 : 0;

	float actual_cull_distance = cull_distance_override > 0.0 ? cull_distance_override : cull_distance;

	if (actual_cull_distance > 0.0 && vertex_distance > actual_cull_distance)
	{
		POSITION = vec4(sqrt(-1));
	}
	else
	{
		POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);

		#if defined(OVERRIDE_VERTEX_SNAP_RESOLUTION)
			vec4 snapped_position = POSITION;
			snapped_position.xyz = POSITION.xyz / POSITION.w;

			vec2 actual_vertex_snap_resolution = vec2(vertex_snap_resolution);

			snapped_position.x =
				floor(actual_vertex_snap_resolution.x * snapped_position.x) /
				actual_vertex_snap_resolution.x;

			snapped_position.y =
				floor(actual_vertex_snap_resolution.y * snapped_position.y) /
				actual_vertex_snap_resolution.y;

			snapped_position.xyz *= POSITION.w;

			POSITION.xyz = snapped_position.xyz;
		#else
			if (vertex_snap_intensity > 0 && vertex_snap_intensity <= 2)
			{
				vec2 real_vertex_snap_resolution =
					vec2(VERTEX_SNAP_RESOLUTION) * (1.0 / float(vertex_snap_intensity));

				vec4 snapped_position = POSITION;
				snapped_position.xyz = POSITION.xyz / POSITION.w;

				snapped_position.x =
					floor(real_vertex_snap_resolution.x * snapped_position.x) /
					real_vertex_snap_resolution.x;

				snapped_position.y =
					floor(real_vertex_snap_resolution.y * snapped_position.y) /
					real_vertex_snap_resolution.y;

				snapped_position.xyz *= POSITION.w;

				POSITION.xyz = snapped_position.xyz;
			}
		#endif
	}


	if (affine_texture_mapping)
	{
		position_w = POSITION.w;
		UV *= abs(POSITION.w);
	}

}

void fragment()
{
	vec2 uv;
	uv = UV;
	vec4 sampled_color;

	if (should_halve_texture_lod == 1)
	{
		vec2 half_albedo_texture_size = vec2(textureSize(albedo_texture, 0)) * 0.5;
		vec2 new_uv = floor(uv * half_albedo_texture_size) / half_albedo_texture_size;

		sampled_color = texture(albedo_texture, new_uv);
	}
	else
	{
		if (texture_filtering)
			sampled_color = albedoTextureFiltered(uv);
		else
			sampled_color = texture(albedo_texture, uv);
	}


	vec3 primary_color = albedo_texture_as_primary_color ? sampled_color.rgb : COLOR.rgb;

	vec3 secondary_color = albedo_texture_as_primary_color ? COLOR.rgb : sampled_color.rgb;

	ALBEDO = (1.0 - mix_factor) * primary_color + mix_factor * secondary_color * primary_color;
	ALBEDO *= albedo_color.rgb;

}