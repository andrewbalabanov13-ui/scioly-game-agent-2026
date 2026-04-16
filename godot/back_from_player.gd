extends Control
@onready var should_hide = get_parent().start_player_button_hide


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	should_hide = get_parent().start_player_button_hide
	if should_hide == true:
		hide()
	else:
		show()
		
		
