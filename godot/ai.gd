extends CharacterBody2D

var tile_size_x = 0
var tile_size_y = 0
var play = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const TILEMULTIPLIER = 1
signal ai_position
var q_table = []

var top_left_tile = 0
var bottom_right_tile = 0

var epsilon_value = 0.1
var stop = 1
var b = 0
var index = 0
var action = 0
var tiled_pos = 0

func _ready() -> void:
	hide()
	
func get_state():
	pass	

func episode(posx,posy):
	position.x = posx
	position.y = posy
	stop = 0
	while stop == 1:
		b = -999999999999999
		index = 0
		if randf() < epsilon_value:
			action = floor(randf() * 4)
		else:
			for x in range(1):
				pass
			
		

func _physics_process(delta: float) -> void:
	pass
	if play == false:
		return
	for x in range(1000):
		episode(208,120)
	
	
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


func _on_tile_map_layer_z_2_create_states(all_tile_width,all_tile_height,Ptop_left_tile,Pbottom_right_tile) -> void:
	q_table = []
	for x in all_tile_width:
		for y in all_tile_height:
			for z in TILEMULTIPLIER:
				q_table.append([0,0,0,0])
	tile_size_x = 18 / TILEMULTIPLIER
	tile_size_y = 18 / TILEMULTIPLIER
	top_left_tile = Ptop_left_tile
	bottom_right_tile = Pbottom_right_tile
