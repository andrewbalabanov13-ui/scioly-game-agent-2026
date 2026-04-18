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
@export var docHide := false
@export var docLabelhide := true
var prev_death = false
@onready var ui_documentation: CanvasLayer = get_node("../../Documentation")
@onready var ui_main: CanvasLayer = get_parent()
@onready var ui_help: CanvasLayer = get_node("../../Help")
@onready var ui_death: Control = get_node("../UiDeath")
@onready var restart_lose: Button = get_node("../UiDeath/Restart")
@onready var ui_win: CanvasLayer = get_parent().get_parent().get_node("Win")
@onready var ui_ai_menu: CanvasLayer = get_node("../../AiMenu")
@onready var ui_lose: CanvasLayer = get_node("../../Lose")
# Cache UI layer references (no per-frame setup).
func _ready() -> void:
	pass
# Show or hide this root menu control based on `menu`; other systems toggle visibility elsewhere.
func _physics_process(delta: float) -> void:
	if menu:
		show()
	else:
		hide()

	


# Return from death overlay: restore menu flags and clear player death.
func _on_death_button_pressed() -> void:
	menu = true
	DeathButtonHide = true
	player.death = false
	PlayerMenuHide = false
	start_player_button_hide = true
	ai_hide = true
	AiMenuHide = false
	docHide = false
	
	


# Start human player mode: hide main UI and notify game systems.
func _on_startplayer_button_pressed() -> void:
	menu = false
	emit_signal("reset","player") # Replace with function body.


# Player submenu: hide main canvas and start player session from the flow that uses this button.
func _on_player_menu_pressed() -> void:
	ui_main.visible = false
	menu = false
	emit_signal("reset","player")

# AI submenu: hide main UI and start AI play mode.
func _on_ai_menu_pressed() -> void:
	ui_main.visible = false
	menu = false
	emit_signal("reset","ai_play")




# After AI training UI closes: show main menu again and reveal AI-related buttons.
func _on_training_done_button_pressed() -> void:
	ai_hide = false # Replace with function body.
	menu = true


# When AI run ends (win/lose), tuck AI entry points back behind flags used by child buttons.
func _on_ai_ai_play_done(type: Variant,reset_type) -> void:
	ai_hide = true
	AiMenuHide = true


# Open Help layer and hide the main menu canvas.
func _on_help_pressed() -> void:
	ui_main.visible = false
	ui_help.visible = true
	
# Open Documentation layer and hide the main menu canvas.
func _on_documentation_pressed() -> void:
	ui_main.visible = false
	ui_documentation.visible = true


# Start AI training mode (fast sim) from the menu.
func _on_ai_train_pressed() -> void:
	menu = false
	emit_signal("reset","ai_train")


# Close win overlay and return to the main menu canvas.
func _on_go_back_to_menu_pressed() -> void:
	ui_main.visible = true
	menu = true
	ui_win.visible = false


# Close lose overlay, show main menu, and clear death so gameplay can restart cleanly.
func _on_go_back_to_menu_pressed_from_Lose_ui() -> void:
	menu = true
	ui_lose.visible = false
	ui_main.visible = true
	player.death = false
