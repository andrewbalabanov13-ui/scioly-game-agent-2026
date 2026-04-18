extends Camera2D


# Start with this camera off until an AI mode is selected from the main menu.
func _ready() -> void:
	self.enabled = false # Replace with function body.


# Reserved for per-frame camera logic (unused).
func _process(delta: float) -> void:
	pass

# Enable this camera for AI train/play; disable it for other modes (e.g. player).
func _on_main_menu_reset(type: Variant) -> void:
	if type == "ai_play" or type == "ai_train":
		self.enabled = true
	else:
		self.enabled = false
