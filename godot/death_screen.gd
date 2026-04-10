extends Control
@export var player: Player
@onready var menu = get_node("../../Ui - main menu/main_menu").menu

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
	
func _physics_process(_delta: float) -> void:
	menu = get_node("../../Ui - main menu/main_menu").menu
	if player.death and not menu:
		show()
	else:
		hide()
		

func _button_pressed():
	player.death = false
	print(player.death)
	
	 
