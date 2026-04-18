extends Button

@onready var ui_main = get_node("../../Ui - main menu")
@onready var ui_ai_menu = get_parent()


# Placeholder (no setup).
func _ready() -> void:
	pass # Replace with function body.


# Reserved (unused).
func _process(delta: float) -> void:
	pass


# Leave the AI submenu and show the main menu canvas again.
func _on_pressed() -> void:
	ui_ai_menu.visible = false
	ui_main.visible = true
