extends OptionButton
var languages = {
	0: "es",
	1: "en"
}

func _ready() -> void:
	clear()
	add_item("Spanish")
	add_item("English")


func _on_item_selected(index: int) -> void:
	var language_code = languages[index]
	print("Idioma selecionado: ", languages[index])
	TranslationServer.set_locale(language_code)
