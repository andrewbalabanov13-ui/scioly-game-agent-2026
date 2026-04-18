extends Button
@onready var ui_main = get_node("../../Ui - main menu")
@onready var ui_ai_menu = get_parent()

# No setup required for this menu button.
func _ready() -> void:
	pass # Replace with function body.


# Reserved (unused).
func _process(delta: float) -> void:
	pass


# Begin AI training: notify game and hide the AI menu layer.
func _on_pressed() -> void:
	emit_signal("reset","ai_train")
	ui_ai_menu.visible = false
