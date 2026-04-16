extends Button
@onready var AiMenuHide = get_parent().AiMenuHide

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	AiMenuHide = get_parent().AiMenuHide
	if AiMenuHide:
		hide()
	else:
		show()
