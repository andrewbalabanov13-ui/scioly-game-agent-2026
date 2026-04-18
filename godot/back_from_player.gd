extends Control
@onready var should_hide = get_parent().start_player_button_hide


# Placeholder (no setup).
func _ready() -> void:
	pass # Replace with function body.


# Show or hide this control from MainMenu’s start_player_button_hide.
func _process(delta: float) -> void:
	should_hide = get_parent().start_player_button_hide
	if should_hide == true:
		hide()
	else:
		show()
		
		
