extends Button
@onready var button_hide = get_node("../../MainMenu").DeathButtonHide

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
