extends Button
@onready var ai_hide = get_parent().docHide

# Placeholder (no setup).
func _ready() -> void:
	pass # Replace with function body.


# Show this documentation entry only when MainMenu.docHide allows it.
func _process(delta: float) -> void:
	ai_hide = get_parent().docHide
	if ai_hide:
		hide()
	else:
		show()
