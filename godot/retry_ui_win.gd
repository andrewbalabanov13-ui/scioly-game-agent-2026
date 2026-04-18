extends Button
@export var reset_type = "ai"

# Placeholder (no setup).
func _ready() -> void:
	pass

# Placeholder (unused).
func _on_pressed() -> void:
	pass
	
# Reserved (unused).
func _physics_process(delta: float) -> void:
	pass

# Store which play mode to retry after an AI win.
func _on_ai_ai_play_done(type: Variant, playAs: Variant) -> void:
	if type == "win":
		reset_type = playAs # Replace with function body.
