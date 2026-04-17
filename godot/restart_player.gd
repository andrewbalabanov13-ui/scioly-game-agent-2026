extends Button
@onready var button_hide = get_node("../../MainMenu").DeathButtonHide
var reset_type = 0

func _ready() -> void:
	hide()

func _on_pressed() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	button_hide = get_node("../../MainMenu").DeathButtonHide
	if button_hide:
		hide()
	else:
		show()


func _on_ai_ai_play_done(type: Variant,playAs) -> void:
	if type == "lose":
		reset_type = playAs # Replace with function body.
