extends CharacterBody2D

var play = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

signal ai_position

func _ready() -> void:
	hide()

func _physics_process(delta: float) -> void:
	pass
	if play == false:
		return
	move_and_slide()


func _on_main_menu_reset(type: Variant) -> void:
	if type == "ai":
		show()
		play = true
		$CollisionShape2D.disabled = false
	else:
		hide()
		play = false
		$CollisionShape2D.disabled = true
