shader_type canvas_item;

uniform vec4 color_one : source_color = vec4(0.85, 0.05, 0.05, 1.0); // Rojo oscuro
uniform vec4 color_two : source_color = vec4(1.0, 0.15, 0.15, 1.0);  // Rojo brillante
uniform float angle = -0.45; // Ángulo inclinado hacia la izquierda (~ -25 grados)
uniform float line_count = 12.0; 
uniform float line_width : hint_range(0.0, 1.0) = 0.5;
uniform float softness : hint_range(0.001, 0.1) = 0.01; // Suavizado anti-aliasing para las líneas
uniform float speed_lines = 1.0;          // Velocidad de avance de las líneas rojas
uniform float speed_diamonds = -2.5;       // Velocidad de la cascada de rombos (negativo para que caigan)

// PARÁMETROS PARA LOS ROMBOS
uniform vec4 spark_color : source_color = vec4(1.0, 1.0, 1.0, 0.08); // Blanco muy transparente
uniform float spark_density : hint_range(0.0, 100.0) = 6.0; // Espaciado y tamaño de la cuadrícula
uniform float diamond_softness : hint_range(0.01, 0.5) = 0.15; // Degradado del borde de los rombos rellenos
uniform float outline_thickness : hint_range(0.01, 0.2) = 0.03; // Grosor de línea para los rombos huecos

// Función matemática de ruido basada en celdas fijas
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {
    // Matriz de rotación general basada en el ángulo
    mat2 rot = mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
    vec2 rot_uv = rot * UV;
    
    // 1. Dibujamos las líneas con movimiento automático continuo
    float stripe_scroll = TIME * speed_lines;
    float stripe_val = fract(rot_uv.x * line_count + stripe_scroll);
    float stripe = smoothstep(line_width - softness, line_width + softness, stripe_val);
    vec4 bg_color = mix(color_one, color_two, stripe);
    
    // 2. Efecto Cascada para los rombos usando TIME
    // Multiplicamos TIME por la velocidad de los rombos y lo sumamos al eje Y para que fluyan en vertical
    float spark_scroll = TIME * speed_diamonds;
    vec2 spark_uv = (rot_uv * spark_density) + vec2(0.0, spark_scroll);
    
    vec2 ipos = floor(spark_uv); // Identificador único de cada celda que viaja
    vec2 fpos = fract(spark_uv); // Coordenadas locales para dibujar dentro de la celda
    
    // Al usar ipos puro, el rombo no parpadea en el sitio, sino que mantiene su forma mientras se desplaza
    float rand_val = hash(ipos);
    
    float spark_mask = 0.0;
    if (rand_val > 0.60) { // Probabilidad de aparición de los rombos
        // Distancia de Manhattan para generar la geometría del Rombo (|x| + |y|)
        vec2 centro_celda = abs(fpos - vec2(0.5));
        float dist_rombo = centro_celda.x + centro_celda.y;
        
        // El tamaño varía un poco según el valor aleatorio de la celda
        float tamano_rombo = 0.35 * (0.6 + rand_val * 0.4); 
        
        if (rand_val > 0.82) {
            // Rombo HUECO (Delineado)
            float borde_exterior = smoothstep(tamano_rombo, tamano_rombo - 0.01, dist_rombo);
            float borde_interior = smoothstep(tamano_rombo - outline_thickness, tamano_rombo - outline_thickness - 0.01, dist_rombo);
            spark_mask = borde_exterior - borde_interior;
        } else {
            // Rombo RELLENO (Suave / Difuminado)
            spark_mask = smoothstep(tamano_rombo, tamano_rombo - diamond_softness, dist_rombo);
        }
    }
    
    // 3. Mezcla final aplicando la transparencia alfa de spark_color
    COLOR = mix(bg_color, vec4(spark_color.rgb, 1.0), spark_mask * spark_color.a);
}
