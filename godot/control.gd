extends Control


# Training-done overlay starts hidden until the AI finishes training.
func _ready() -> void:
	hide() # Replace with function body.


# Reserved (unused).
func _process(delta: float) -> void:
	pass


# Show the “training done” panel when the AI emits completion.
func _on_ai_ai_training_done() -> void:
	show()
	#$training_done_label.text = ""


# Dismiss the overlay after the player acknowledges training completion.
func _on_training_done_button_pressed() -> void:
	hide() # Replace with function body.
