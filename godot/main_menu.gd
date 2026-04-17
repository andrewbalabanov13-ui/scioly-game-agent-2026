extends Control

signal reset(type)

@export var UiDeath = Control

@export var menu := true
@export var ui_win_retry := Button
@export var player: Player
@export var DeathButtonHide := true
@export var start_player_button_hide := true
@export var PlayerMenuHide := false
@export var ai_hide := true
@export var AiMenuHide := false
var prev_death = false

@onready var ui_death: Control = get_node("../UiDeath")
@onready var restart_lose: Button = get_node("../UiDeath/Restart")
@onready var ui_win: Control = get_parent().get_node("UiWin")


func _ready() -> void:
	ui_death.visible = false
	ui_win.visible = false

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
	emit_signal("reset","ai_train") # Replace with function body.
	menu = false


 # Replace with function body.


func _on_startai_button_pressed() -> void:
	emit_signal("reset","ai_play") # Replace with function body.
	menu = false
	


func _on_restart_player_pressed() -> void:
	player.death = false
	menu = false
	emit_signal("reset",restart_lose.reset_type) # Replace with function body.
	DeathButtonHide = true
	print(restart_lose.reset_type)


func _on_training_done_button_pressed() -> void:
	ai_hide = false # Replace with function body.
	menu = true


func _on_back_from_ai_menu_pressed() -> void:
	ai_hide = true
	AiMenuHide = false
	PlayerMenuHide = false
	


func _on_ai_ai_play_done(type: Variant,reset_type) -> void:
	ai_hide = true
	AiMenuHide = true
	if type == "lose":
		ui_death.visible = true
		ui_win.visible = false
	if type == "win":
		ui_win.visible = true
		ui_death.visible = false


func _on_retry_pressed() -> void:
	player.death = false
	menu = false
	ui_win.visible = false
	emit_signal("reset",ui_win_retry.reset_type)
	print(ui_win_retry.reset_type)


func _on_go_back_to_main_menu_pressed() -> void:
	menu = true
	AiMenuHide = false
	PlayerMenuHide = false
	ai_hide = true
	ui_win.visible = false
	player.death = false
