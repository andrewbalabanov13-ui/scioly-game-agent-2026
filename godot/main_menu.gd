extends Control

signal reset(type)

@export var menu := true
@export var player: Player
@export var DeathButtonHide := true
@export var start_player_button_hide := true
@export var PlayerMenuHide := false
@export var ai_hide := true
@export var AiMenuHide := false
var prev_death = false

@onready var ui_death: Control = get_parent().get_node("UiDeath")

func _ready() -> void:
	ui_death.visible = false

func _physics_process(delta: float) -> void:
	if menu:
		show()
	else:
		hide()
	if player.death:
		DeathButtonHide = false
		ui_death.visible = true
	else:
		DeathButtonHide = true
		ui_death.visible = false


func _on_death_button_pressed() -> void:
	menu = true
	DeathButtonHide = true
	player.death = false
	PlayerMenuHide = false
	start_player_button_hide = true
	ai_hide = true
	AiMenuHide = false
	
	


func _on_startplayer_button_pressed() -> void:
	menu = false
	emit_signal("reset","player") # Replace with function body.


func _on_player_menu_pressed() -> void:
	PlayerMenuHide = true
	start_player_button_hide = false
	AiMenuHide = true


func _on_back_from_player_pressed() -> void:
	PlayerMenuHide = false
	start_player_button_hide = true
	AiMenuHide = false


func _on_ai_menu_pressed() -> void:
	ai_hide = false # Replace with function body.
	AiMenuHide = true
	PlayerMenuHide = true


func _on_trainai_button_pressed() -> void:
	menu = false
	emit_signal("reset","ai_train") # Replace with function body.

 # Replace with function body.


func _on_startai_button_pressed() -> void:
	emit_signal("reset","ai_play") # Replace with function body.
