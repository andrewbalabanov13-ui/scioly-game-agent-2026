extends Button
@onready var shouldHide = get_parent().docLabelhide

# Placeholder (no setup).
func _ready() -> void:
	pass # Replace with function body.


# Show or hide from the parent’s docLabelhide flag (paired doc UI).
func _process(delta: float) -> void:
	shouldHide = get_parent().docLabelhide
	if shouldHide:
		hide()
	else:
		show()
