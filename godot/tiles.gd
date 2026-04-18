extends Node2D
@onready var menu = get_node("../Ui - main menu/MainMenu").menu



# Reserved (unused).
func _process(_delta: float) -> void:
	pass

# Show the tiles node again when returning from a menu-driven reset.
func _on_main_menu_reset() -> void:
	show() # Replace with function body.
	
# Hide tilemap layer while the main menu is open so it does not sit over gameplay.
func _physics_process(delta: float) -> void:
	menu = get_node("../Ui - main menu/MainMenu").menu
	if menu == true:
		hide()
	else:
		show()
