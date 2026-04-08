extends Control

## When true, the main menu is up and the player stays hidden.
var menu := true


func is_main_menu_open() -> bool:
	return menu


func close_main_menu() -> void:
	menu = false
	visible = false


func open_main_menu() -> void:
	menu = true
	visible = true
