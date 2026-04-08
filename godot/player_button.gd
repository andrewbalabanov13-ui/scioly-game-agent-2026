extends Button

## Optional: drag the main-menu Overlay here. If empty, the parent Control is used.
@export var menu: Control



func _ready() -> void:
	if menu == null:
		menu = get_parent() as Control
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	
	# Start game: menu must be false so player/tiles show (open_main_menu keeps menu true and hides them).
	if menu != null and menu.has_method("close_main_menu"):
		menu.close_main_menu()
