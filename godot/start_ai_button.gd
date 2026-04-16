extends Button
@onready var ai_hide = get_parent().ai_hide

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ai_hide = get_parent().ai_hide
	if ai_hide:
		hide()
	else:
		show()
