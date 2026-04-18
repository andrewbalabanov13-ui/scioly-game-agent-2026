extends Control
@export var player: Player
@onready var menu = get_node("../../Ui - main menu/main_menu").menu

# Resolve player reference, stay hidden, and add a simple back-to-menu button.
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
	
# Show this overlay only while the player is dead and the main menu is not up.
func _physics_process(_delta: float) -> void:
	menu = get_node("../../Ui - main menu/main_menu").menu
	if player.death and not menu:
		show()
	else:
		hide()
		

# Clear death flag when the user presses the improvised back button.
func _button_pressed():
	player.death = false
	print(player.death)
	
	 
