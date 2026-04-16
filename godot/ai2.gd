extends CharacterBody2D

var play = false
var q_table = []
var world = []
var last_state = 0
var last_action = -1
var action = -1
var episode_amount = 0
var robot_training_mode = -1
const SPEED = 300.0
const JUMP_VELOCITY = -400
const TILEMULTIPLIER = 1
const TILE_SIZE = 18
const EPSILON_VALUE = 0.05
const ALTHA = 0.1
const BASE_TICKS := 60

## Caps integration step for train/move. Without this, large Engine.time_scale makes delta huge and physics explodes.
const MAX_PHYSICS_SUBSTEP := 1.0 / 120.0
@export var tile: TileMapLayer


func set_game_speed(scale: float):
	scale = clamp(scale, 0.25, 2.0)    
	Engine.time_scale = scale
	Engine.physics_ticks_per_second = int(BASE_TICKS / scale)

func _ready() -> void:
	hide()
	
func get_reward(row,col):
	var block = world[row][col]
	if is_on_wall():
		return Vector2i(-10,1)
	if block == "s":
		return Vector2i(-1000,2)
	if block == "c":
		return Vector2i(1000,3)
	return Vector2i(-1,1)

func make_world():
	var world = []
	for y in tile.height_in_tiles:
		var row = []
		for x in tile.width_in_tiles:
			var cell := Vector2i(x,y)
			var cell_source_id = tile.get_cell_source_id(cell)
			if cell_source_id == -1:
				row.append("e")
				#empty
				continue
			var cell_type = tile.get_cell_atlas_coords(cell)
			if cell_type in [Vector2i(1,0), Vector2i(2,0), Vector2i(3,0), Vector2i(1,1), Vector2i(2,1), Vector2i(3,1), Vector2i(4,5)]:
				row.append("w")
				#wall
				continue
			if cell_type == Vector2i(8,3):
				row.append("s")
				#spike
				continue
			if cell_type == Vector2i(11,7):
				row.append("c")
				#coin
				continue
		world.append(row)
	return world

func make_q_table():
	q_table = []
	for x in tile.width_in_tiles:
		for y in tile.height_in_tiles:
			q_table.append([0,0,0])

func get_row_and_col():
	var col = floor(position.x / TILE_SIZE) 
	var row = floor(position.y / TILE_SIZE)
	return Vector2i(row,col)

func get_state(row,col):
	return row* tile.width_in_tiles + col

func reset():
	position.x = 208
	position.y = 120
	
func move(delta,dir):
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if dir == 2 and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if dir == 0:
		velocity.x = 1 * SPEED
	elif dir == 1:
		velocity.x = -1 * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
func get_action(state, is_train):
	var b = -99999999
	var index = 0
	if is_train and randf() < EPSILON_VALUE:
		index = randi_range(0,2)
		#chooses a random number between 0-2
		#possible choises include: 0,1,2
		#number tells the direction of ai
		#0 = right
		#1 = left
		#2 = up
	else:
		for x in range(len(q_table[state])):
			if q_table[state][x] > b:
				b = q_table[state][x]
				index = x
	return index
	
	


func train(posx,posy,delta):
	var pos = get_row_and_col()
	var row = pos.x
	var col = pos.y
	var state = get_state(row,col)
	var index = -1
	var b = -99999999999999
	#print(state)
	
	if state != last_state:
		if last_state >= 0:
			var reward_and_stop = get_reward(row,col)
			var reward = reward_and_stop.x
			var stop = reward_and_stop.y
			var new_actions = q_table[state]
			var TD = (reward + new_actions.max()) - q_table[last_state][action]
			q_table[last_state][action] = q_table[last_state][action] + (ALTHA * TD)
			if stop in [2,3]:
				if stop == 2:
					print('you lose')
				elif stop == 3:
					print('you win')
				reset()
				episode_amount += 1
				return 
			action = get_action(state,true)
		last_state = state
	
	move(delta,action)
	pos = get_row_and_col()
	row = pos.x
	col = pos.y
	if is_on_wall():
		action = get_action(state,true)
		
func _physics_process(delta: float) -> void:
	if not play:
		return
	if robot_training_mode == 0:
		if episode_amount < 1000:
			set_game_speed(100)
			for x in range(100):
				var steps: int = maxi(1, ceili(delta / MAX_PHYSICS_SUBSTEP))
				var sub_delta: float = delta / float(steps)
				for _i in range(steps):
					train(position.x, position.y, sub_delta)
		else:
			set_game_speed(1)
			position.x = 208
			position.y = 120
			robot_training_mode = 1
			print(q_table)
			
			
	if robot_training_mode == 1:
		set_game_speed(1)
		run_ai(delta)

func run_ai(delta):
	var pos = get_row_and_col()
	var row = pos.x
	var col = pos.y
	var state = get_state(row,col)
	var run_action = get_action(state,false)
	move(delta,run_action)


func _on_main_menu_reset(type: Variant) -> void:
	if type == "ai_train":
		play = true
		show()
		robot_training_mode = 0
		position.x = 208
		position.y = 120
		world = make_world()
		make_q_table()
	elif type == "ai_play":
		robot_training_mode = 1
	else:
		play = false
		position.x = 1000
		position.y = 1000
		
