// GrayscaleTint.gdshader
// A simple shader to tint a grayscale texture with a given color.
shader_type canvas_item;

// The 'uniform' keyword makes this variable accessible from scripts
// and from the Inspector. 'source_color' provides a color picker UI.
uniform vec4 tint_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Default to red

void fragment() {
    // Get the original color of the pixel from the sprite's texture.
    vec4 original_color = texture(TEXTURE, UV);

    // Since the original texture is grayscale, its R, G, and B components
    // are all equal. We can use any of them (e.g., .r) as the intensity value.
    float intensity = original_color.r;

    // Set the final color of the pixel.
    // We start with the tint_color.
    COLOR = tint_color;

    // We then multiply its RGB values by the grayscale intensity.
    // Black parts of the sprite (intensity ~ 0) will remain black.
    // White parts (intensity ~ 1) will take on the full tint_color.
    COLOR.rgb *= intensity;

    // It's important to preserve the original alpha (transparency)
    // so that transparent parts of your sprite remain transparent.
    COLOR.a = original_color.a;
}