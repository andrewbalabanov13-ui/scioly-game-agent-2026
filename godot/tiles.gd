extends Node2D
@onready var menu = get_node("../Ui - main menu/MainMenu").menu



func _process(_delta: float) -> void:
	pass

func _on_main_menu_reset() -> void:
	show() # Replace with function body.
	
func _physics_process(delta: float) -> void:
	menu = get_node("../Ui - main menu/MainMenu").menu
	if menu == true:
		hide()
	else:
		show()
