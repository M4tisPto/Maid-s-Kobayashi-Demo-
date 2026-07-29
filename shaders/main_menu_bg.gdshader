shader_type canvas_item;

uniform vec4 color_one : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform vec4 color_two : source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform float angle = 0.785; 
uniform float line_count = 20.0; 
uniform float line_width : hint_range(0.0, 1.0) = 0.5; // Controls the size ratio
uniform float speed = 2.0; 

void fragment() {
    vec2 rot_uv = UV;
    mat2 rot = mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
    rot_uv = rot * rot_uv;
    
    // Using the line_width variable instead of a fixed 0.5
    float stripe = step(line_width, fract(rot_uv.x * line_count + TIME * speed));
    
    vec4 final_color = mix(color_one, color_two, stripe);
    COLOR = final_color;
}
