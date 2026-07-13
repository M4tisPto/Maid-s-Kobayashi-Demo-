shader_type canvas_item;

// Captura la pantalla detrás del sprite
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    // 1. Obtenemos el color del fondo (la pantalla)
    vec3 color_pantalla = texture(screen_texture, SCREEN_UV).rgb;
    
    // 2. Obtenemos la forma/opacidad de tu sprite actual
    vec4 mascara = texture(TEXTURE, UV);
    
    // 3. Calculamos qué tan "silueta" es el pixel.
    // Usamos el canal alfa, o el brillo (rgb) si tu sprite es negro sobre fondo blanco.
    // Al restar 1.0 - mascara.a invertimos el orden: lo invisible se vuelve negro.
    float factor_silueta = mascara.a; 
    
    // Si tu sprite es un dibujo negro sobre fondo blanco, descomenta la siguiente línea:
    // factor_silueta = 1.0 - mascara.r;

    // 4. Invertimos el factor para el alfa final (1.0 = opaco/negro, 0.0 = transparente)
    float alfaaterialtr_final = 1.0 - factor_silueta;
    
    // 5. Mezclamos el fondo con el color negro (vec3(0.0)) basado en la silueta
    vec3 color_final = mix(color_pantalla, vec3(0.0), factor_silueta);
    
    COLOR = vec4(color_final, alfa_final);
}
