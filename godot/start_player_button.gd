extends Button
@onready var should_hide = get_parent().start_player_button_hide

# Submenu child starts hidden until the parent menu reveals it.
func _ready() -> void:
	hide() # Replace with function body.


# Sync visibility with MainMenu’s start_player_button_hide flag.
func _process(delta: float) -> void:
	should_hide = get_parent().start_player_button_hide
	if should_hide == true:
		hide()
	else:
		show()
