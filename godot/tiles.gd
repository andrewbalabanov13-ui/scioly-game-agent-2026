extends Node2D

@onready var _main_menu_overlay: Control = get_node("../Ui - main menu/Overlay")


func _process(_delta: float) -> void:
	if _is_main_menu_open():
		hide()
	else:
		show()


func _is_main_menu_open() -> bool:
	if _main_menu_overlay == null or not _main_menu_overlay.has_method("is_main_menu_open"):
		return false
	return _main_menu_overlay.is_main_menu_open()
