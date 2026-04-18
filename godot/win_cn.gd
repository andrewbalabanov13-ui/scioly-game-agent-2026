extends Control
@onready var selfcanvas = get_parent()
@export var main_menu: Control
# Placeholder (no setup).
func _ready() -> void:
	pass # Replace with function body.


# Reserved (unused).
func _process(delta: float) -> void:
	pass


# Toggle win UI visibility from end-of-run signals; force main menu flag when a run ends.
func _on_win(type: Variant, playAs: Variant) -> void:
	if type == "win":
		selfcanvas.visible = true
	if type == "lose":
		selfcanvas.visible = false
	main_menu.menu = true
