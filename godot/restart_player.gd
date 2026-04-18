extends Button
@onready var button_hide = get_node("../../MainMenu").DeathButtonHide
var reset_type = 0

# Hidden until death UI logic reveals the restart affordance.
func _ready() -> void:
	hide()

# Placeholder (unused).
func _on_pressed() -> void:
	pass
	
# Mirror MainMenu DeathButtonHide to show/hide this button.
func _physics_process(delta: float) -> void:
	button_hide = get_node("../../MainMenu").DeathButtonHide
	if button_hide:
		hide()
	else:
		show()


# Remember which mode to reset when AI play ends in a lose state.
func _on_ai_ai_play_done(type: Variant,playAs) -> void:
	if type == "lose":
		reset_type = playAs # Replace with function body.
