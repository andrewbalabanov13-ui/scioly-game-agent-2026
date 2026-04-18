extends Button
@onready var button_hide = get_node("../../MainMenu").DeathButtonHide

# Death-screen button begins hidden until the player dies.
func _ready() -> void:
	hide()

# Placeholder (unused).
func _on_pressed() -> void:
	pass
	
# Toggle visibility from MainMenu’s DeathButtonHide flag.
func _physics_process(delta: float) -> void:
	button_hide = get_node("../../MainMenu").DeathButtonHide
	if button_hide:
		hide()
	else:
		show()
