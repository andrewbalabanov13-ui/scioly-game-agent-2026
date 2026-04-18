extends Button
@onready var Ui_main = get_node("../../Ui - main menu")
@onready var Ui_self = get_parent()
# Placeholder (no setup).
func _ready() -> void:
	pass # Replace with function body.


# Reserved (unused).
func _process(delta: float) -> void:
	pass


# Close Help layer and show the main menu.
func _on_pressed() -> void:
	Ui_main.visible = true
	Ui_self.visible = false
	
