extends CharacterBody2D

var tile_size_x = 0
var tile_size_y = 0
var play = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const TILEMULTIPLIER = 1
signal ai_position
var q_table = []

var right_tile = 0
var left_tile = 0
var up_tile = 0
var down_tile = 0

var leftest_x_pos = 0
var rightest_x_pos = 0
var uppest_y_pos = 0
var downest_y_pos = 0

var epsilon_value = 0.1
var stop = 1
var b = 0
var index = 0
var action = 0
func _ready() -> void:
	hide()
	
func get_grid():
	pass
	
	
func episode(posx,posy):
	position.x = posx
	position.y = posy
	stop = 1
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
		episode(1,0)
	
	
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


func _on_tile_map_layer_z_2_create_states(all_tile_width,all_tile_height,right_tile_x,left_tile_x,top_tile_y,bottom_tile_y) -> void:
	q_table = []
	for x in all_tile_width:
		for y in all_tile_height:
			for z in TILEMULTIPLIER:
				q_table.append([0,0,0,0])
	right_tile = right_tile_x
	left_tile = left_tile_x
	print(left_tile)
	up_tile = top_tile_y
	down_tile = bottom_tile_y
	tile_size_x = 18 / TILEMULTIPLIER
	tile_size_y = 18 / TILEMULTIPLIER
	leftest_x_pos = tile_size_x * left_tile_x
	rightest_x_pos = tile_size_x * right_tile_x
	uppest_y_pos = tile_size_y * top_tile_y
	downest_y_pos = tile_size_y * bottom_tile_y
		
	
	
