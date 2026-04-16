extends Button
@onready var button_hide = get_parent().PlayerMenuHide

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	button_hide = get_parent().PlayerMenuHide
	if button_hide:
		hide()
	else:
		show()


func _on_pressed() -> void:
	hide() # Replace with function body.
	button_hide = true
