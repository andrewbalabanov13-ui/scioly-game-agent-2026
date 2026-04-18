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

signal ai_training_done 
signal ai_play_done(type,playAs)

@export var player: CharacterBody2D
@export var main_menu: Control

## Caps integration step for train/move. Without this, large Engine.time_scale makes delta huge and physics explodes.
const MAX_PHYSICS_SUBSTEP := 1.0 / 120.0
@export var tile: TileMapLayer


# Scale game time and physics tick rate together (used for fast training vs normal play).
func set_game_speed(scale: float):
	Engine.time_scale = scale
	Engine.physics_ticks_per_second = int(BASE_TICKS * scale)

# Hide the AI agent until a menu mode activates it.
func _ready() -> void:
	hide()
	
# RL reward and episode outcome for the cell under the agent (walls, spikes, coins, flag).
func get_reward(row,col):
	var block = world[row][col]
	if is_on_wall():
		return Vector2i(-5,1)
	if block == "s":
		return Vector2i(-1000,2)
	if block == "c":
		return Vector2i(100,1)
	if block == "f":
		return Vector2i(1000,3)
	return Vector2i(-1,1)

# Build a string grid from the tilemap (wall/spike/coin/flag/empty) for reward lookups.
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
			if cell_type == Vector2i(12,5):
				row.append("f")
				#flag
		world.append(row)
	return world

# Allocate one Q-value triple per tile for actions left/right/jump.
func make_q_table():
	q_table = []
	for x in tile.width_in_tiles:
		for y in tile.height_in_tiles:
			q_table.append([0,0,0])

# Map world position to tile row/column indices.
func get_row_and_col():
	var col = floor(position.x / TILE_SIZE) 
	var row = floor(position.y / TILE_SIZE)
	return Vector2i(row,col)

# Flatten (row,col) into a single RL state index for the Q-table.
func get_state(row,col):
	return row* tile.width_in_tiles + col

# Teleport agent back to the level start after a terminal RL transition.
func reset():
	position.x = 250
	position.y = 120
	
# Apply gravity, jump, horizontal speed, then collide with the level.
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
# Epsilon-greedy (training) or greedy (play) choice of action index 0–2.
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
	
	


# One RL step: TD update on state change, optional episode reset, then move with current action.
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
				#if stop == 2:
					#print('you lose')
				#elif stop == 3:
					#print('you win')
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
		
# Drive training (many substeps) or inference depending on robot_training_mode.
func _physics_process(delta: float) -> void:
	if not play:
		return
	if robot_training_mode == 0:
		if episode_amount < 10000:
			for x in range(500):
				var steps: int = maxi(1, ceili(delta / MAX_PHYSICS_SUBSTEP))
				var sub_delta: float = delta / float(steps)
				for _i in range(steps):
					train(position.x, position.y, sub_delta)
		else:
			emit_signal("ai_training_done")
			episode_amount = 0
			robot_training_mode = -1
			hide()
			
	elif robot_training_mode == 1:
		run_ai(delta)

# Play mode: pick greedy action from Q-table, detect win/lose tiles, then move.
func run_ai(delta):
	var pos = get_row_and_col()
	var row = pos.x
	var col = pos.y
	var state = get_state(row,col)
	var run_action = get_action(state,false)
	var reward_and_stop = get_reward(row,col)
	var stop = reward_and_stop.y
	if stop in [2,3]:
		if stop == 2:
			#print("you lose")
			emit_signal("ai_play_done","lose","ai_play")
			player.death = true
		elif stop == 3:
			#print("you win")
			emit_signal("ai_play_done","win","ai_play")
		robot_training_mode = -1
		main_menu.menu = true
		hide()
		
	move(delta,run_action)


# Start/stop AI training or play from main menu; reset position, Q-table, and time scale.
func _on_main_menu_reset(type: Variant) -> void:
	if type == "ai_train":
		play = true
		show()
		robot_training_mode = 0
		episode_amount = 0
		position.x = 250
		position.y = 120
		world = make_world()
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		make_q_table()
		set_game_speed(100000)

	elif type == "ai_play":
		play = true
		robot_training_mode = 1
		position.x = 250
		position.y = 120
		if q_table == []:
			make_q_table()
			world = make_world()
		show()
		set_game_speed(1)
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)


	else:
		play = false
		position.x = 1000
		position.y = 1000
		set_game_speed(1)
		
