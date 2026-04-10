extends Control

signal reset(type)

@export var menu := true
@export var player: Player
@export var DeathButtonHide := true
@export var start_player_button_hide := false
var prev_death = false

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if menu:
		show()
	else:
		hide()
	if player.death == true:
		DeathButtonHide = false


func _on_death_button_pressed() -> void:
	menu = true
	DeathButtonHide = true
	player.death = false
	


func _on_startplayer_button_pressed() -> void:
	menu = false
	emit_signal("reset","player") # Replace with function body.


func _on_startai_button_pressed() -> void:
	menu = false
	emit_signal("reset","ai") # Replace with function body.
