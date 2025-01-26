shader_type canvas_item;

// Animate from 0 to 1
uniform float progress : hint_range(0.0, 1.0) = 0.0;

// How jagged each band of melting pixels are
uniform float meltiness : hint_range(0.0, 16.0) = 1.0;

float pseudo_rand(float x) {
    return fract(sin(x * 12.9898) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;

    // Avoid division by zero and ensure smooth progress
    uv.y -= progress / max(UV.y + 0.001, 0.001);

    // Create jagged edges for each pixel on the x-axis
    uv.y -= progress * meltiness * pseudo_rand(UV.x - mod(UV.x, TEXTURE_PIXEL_SIZE.x));

    // Fetch the texture color at the modified UV coordinates
    COLOR = texture(TEXTURE, uv);

    // "Delete" pixels out of range by setting their alpha to 0
    if (uv.y <= 0.0) {
        COLOR.a = 0.0;
    }
}
