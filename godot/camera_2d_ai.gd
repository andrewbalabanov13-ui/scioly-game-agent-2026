extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.enabled = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_main_menu_reset(type: Variant) -> void:
	if type == "ai":
		self.enabled = true
	else:
		self.enabled = false
