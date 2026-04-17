extends Button
@export var reset_type = "ai"

func _ready() -> void:
	pass

func _on_pressed() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass

func _on_ai_ai_play_done(type: Variant, playAs: Variant) -> void:
	if type == "win":
		reset_type = playAs # Replace with function body.
