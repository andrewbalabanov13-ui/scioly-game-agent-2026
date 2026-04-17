extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ai_ai_training_done() -> void:
	show()
	#$training_done_label.text = ""


func _on_training_done_button_pressed() -> void:
	hide() # Replace with function body.
