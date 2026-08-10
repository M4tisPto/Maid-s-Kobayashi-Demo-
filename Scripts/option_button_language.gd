extends OptionButton
var languages = {
	0: "en",
	1: "es"
}

func _ready() -> void:
	clear()
	add_item("English")
	add_item("Spanish")


func _on_item_selected(index: int) -> void:
	var language_code = languages[index]
	print("Idioma selecionado: ", languages[index])
	TranslationServer.set_locale(language_code)
