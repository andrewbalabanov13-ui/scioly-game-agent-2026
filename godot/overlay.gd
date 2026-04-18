extends Control

## When true, the main menu is up and the player stays hidden.
var menu := true


# Expose whether the overlay represents the main menu being open.
func is_main_menu_open() -> bool:
	return menu


# Hide overlay and mark menu closed so the game world can run.
func close_main_menu() -> void:
	menu = false
	visible = false


# Show overlay and mark menu open (title / front-end state).
func open_main_menu() -> void:
	menu = true
	visible = true
