extends CharacterBody2D

var play = false
var q_table = []
var world = []

const SPEED = 300.0
const JUMP_VELOCITY = -400
const TILEMULTIPLIER = 1
const TILE_SIZE = 18
const EPSILON_VALUE = 0.05
const ALTHA = 0.1
@export var tile: TileMapLayer

func _ready() -> void:
	pass
	Engine.time_scale = 4
	
func get_reward(row,col):
	var block = world[row][col]
	if is_on_wall():
		return -1000	
	if block == "s":
		return -100
	if block == "c":
		return 20
	return -1

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
	return row*(tile.width_in_tiles+1) + col

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
	#print("b",+position.x)
	#print(velocity.y)
	#print("b",+ position.y)
	move_and_slide()
	#print(position.x)
	#print(position.y)

func episode(posx,posy):
	position.x = posx
	position.y = posy

func train(posx,posy,delta):
	var pos = get_row_and_col()
	var row = pos.x
	var col = pos.y
	var state = get_state(row,col)
	var action = -1
	var index = -1
	var b = -99999999999999
	#print(state)
	if randf() < EPSILON_VALUE:
		action = randi_range(0,2)
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
		action = index
	move(delta,action)
	pos = get_row_and_col()
	row = pos.x
	col = pos.y
	var reward = get_reward(row,col)
	var new_actions = q_table[get_state(row,col)]
	var TD = (reward + new_actions.max()) - q_table[state][action]
	q_table[state][action] = q_table[state][action] + (ALTHA * TD)

func _physics_process(delta: float) -> void:
	if not play:
		return
	train(position.x,position.y,delta)


func _on_main_menu_reset(type: Variant) -> void:
	if type == "ai":
		play = true
		position.x = 208
		position.y = 120
		world = make_world()
		make_q_table()
	else:
		play = false
		position.x = 1000
		position.y = 1000
		
