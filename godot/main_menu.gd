extends Control
@export var menu := true


func _ready():
	var button = Button.new()
	button.text = "Click me"
	button.pressed.connect(_button_pressed)
	add_child(button)

func _button_pressed():
	print("Hello world!")
	menu = false
