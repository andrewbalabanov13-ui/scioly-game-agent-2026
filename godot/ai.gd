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
var b = 0
var index = 0
var action = 0

@export var tile: TileMapLayer
@export var spawn_position: Vector2 = Vector2(208, 120)

var grid_width: int = 1
var grid_height: int = 1

## One RL decision every this many seconds (no parallel coroutines).
const AI_STEP_INTERVAL := 0.35
var _step_timer: float = 0.0
var _ai_spawned: bool = false


# Resolve tilemap reference and hide until the menu enables this agent.
func _ready() -> void:
	hide()
	if tile == null:
		tile = get_node_or_null("../Tiles/TileMapLayerZ2")


# Map body position to a discrete RL state index clamped to the Q-table.
func get_state() -> int:
	if tile == null or q_table.is_empty():
		return 0
	var tw := maxf(tile_size_x, 1.0)
	var th := maxf(tile_size_y, 1.0)
	var col := int(floor(position.x / tw))
	var row := int(floor(position.y / th))
	col = clampi(col, 0, maxi(grid_width - 1, 0))
	row = clampi(row, 0, maxi(grid_height - 1, 0))
	# Matches q_table: for x in width: for y in height: append → index = x * height + y
	var s := col * grid_height + row
	return clampi(s, 0, q_table.size() - 1)


# Turn the chosen action index into velocity (jump / move left / move right).
func _apply_action(dir: int) -> void:
	match dir:
		0:
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
		1:
			velocity.x = 150
		2:
			velocity.x = -150


# When playing: spawn once, apply gravity, pick a new action on a fixed timer, then move.
func _physics_process(delta: float) -> void:
	if not play:
		return

	if not _ai_spawned:
		position = spawn_position
		_ai_spawned = true
		_step_timer = 0.0

	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# Light friction so horizontal from the last action lasts across AI_STEP_INTERVAL.
		velocity.x = move_toward(velocity.x, 0.0, 90.0 * delta)

	_step_timer -= delta
	if _step_timer <= 0.0:
		_step_timer += AI_STEP_INTERVAL
		b = -999999999999999.0
		index = 0
		var state := get_state()
		if randf() < epsilon_value:
			action = int(floor(randf() * 3.0))
		else:
			for x in q_table[state].size():
				if q_table[state][x] > b:
					b = q_table[state][x]
					index = x
			action = index
		_apply_action(action)

	move_and_slide()


# Show and enable collision for legacy “ai” mode, or hide and park when switching away.
func _on_main_menu_reset(type: Variant) -> void:
	if type == "ai":
		show()
		play = true
		_ai_spawned = false
		_step_timer = 0.0
		$CollisionShape2D.disabled = false
	else:
		hide()
		play = false
		_ai_spawned = false
		$CollisionShape2D.disabled = true


# Size the Q-table and tile metrics from the tilemap’s used rect signal.
func _on_tile_map_layer_z_2_create_states(
	all_tile_width: int,
	all_tile_height: int,
	Ptop_left_tile: Variant,
	Pbottom_right_tile: Variant
) -> void:
	q_table = []
	for _x in all_tile_width:
		for _y in all_tile_height:
			for _z in TILEMULTIPLIER:
				q_table.append([0.0, 0.0, 0.0])
	grid_width = all_tile_width
	grid_height = all_tile_height
	tile_size_x = 18.0 / float(TILEMULTIPLIER)
	tile_size_y = 18.0 / float(TILEMULTIPLIER)
	top_left_tile = Ptop_left_tile
	bottom_right_tile = Pbottom_right_tile
