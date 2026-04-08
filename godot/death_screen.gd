extends Control

@export var player: Player

func _ready() -> void:
	if player == null:
		player = get_node("../../Player") as Player
	hide()
	
	var button = Button.new()
	button.text = "Go back to main menu"
	button.pressed.connect(_button_pressed)
	button.position.x = 538
	button.position.y = 350
	add_child(button)
	
func _process(_delta: float) -> void:
	if player.death:
		show()
	else:
		hide()
	print(player.death)

func _button_pressed():
	player.death = false
	 
