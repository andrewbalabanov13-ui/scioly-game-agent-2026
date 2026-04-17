extends CharacterBody2D
class_name Player


@export var score := 0
@export var death := false


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const REMOVABLE_ATLAS := Vector2i(11, 7)
const SPIKE_ATLAS := Vector2i(8,3)
var game_over = false
var play = false
var saved_deleted_tiles = []
@onready var _tile_layer: TileMapLayer = get_node("../Tiles/TileMapLayerZ2")
@onready var menu = get_node("../Ui - main menu/MainMenu").menu

signal player_play_done(type,playAs)
signal player_position
func _ready() -> void:
	hide()
	



func _physics_process(delta: float) -> void:
	emit_signal("player_position",position.x,position.y)
	menu = get_node("../Ui - main menu/MainMenu").menu
	# Add the gravity.
	if menu or not play:
		hide()
		return
	else:
		show()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_erase_touching_removable_tiles()



func _erase_touching_removable_tiles() -> void:
	if _tile_layer == null:
		return
	var bounds := _player_overlap_cell_bounds(_tile_layer)
	var spike_probe := _player_spike_probe_rect(_tile_layer)
	for y in range(bounds.position.y, bounds.end.y):
		for x in range(bounds.position.x, bounds.end.x):
			var cell := Vector2i(x, y)
			if _tile_layer.get_cell_source_id(cell) == -1:
				continue
			if _tile_layer.get_cell_atlas_coords(cell) == REMOVABLE_ATLAS:
				_tile_layer.erase_cell(cell)
				saved_deleted_tiles.append(cell)
				score += 1
			if _tile_layer.get_cell_atlas_coords(cell) == SPIKE_ATLAS:
				if game_over:
					continue
				if spike_probe.intersects(_spike_damage_rect_local(_tile_layer, cell)):					
					death = true
					emit_signal("player_play_done","lose","player")


func _player_overlap_cell_bounds(layer: TileMapLayer) -> Rect2i:
	var cs := $CollisionShape2D as CollisionShape2D
	var xf := cs.global_transform
	var half := Vector2.ZERO
	if cs.shape is RectangleShape2D:
		half = (cs.shape as RectangleShape2D).size * 0.5
	var min_cell := Vector2i(2147483647, 2147483647)
	var max_cell := Vector2i(-2147483648, -2147483648)
	for corner in [
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(-half.x, half.y),
		Vector2(half.x, half.y),
	]:
		var world_pt: Vector2 = xf * corner
		var map_cell := layer.local_to_map(layer.to_local(world_pt))
		min_cell.x = mini(min_cell.x, map_cell.x)
		min_cell.y = mini(min_cell.y, map_cell.y)
		max_cell.x = maxi(max_cell.x, map_cell.x)
		max_cell.y = maxi(max_cell.y, map_cell.y)
	return Rect2i(min_cell, max_cell - min_cell + Vector2i(1, 1))


func _player_aabb_in_layer_local(layer: TileMapLayer) -> Rect2:
	var cs := $CollisionShape2D as CollisionShape2D
	var half := Vector2.ZERO
	if cs.shape is RectangleShape2D:
		half = (cs.shape as RectangleShape2D).size * 0.5
	var min_p := Vector2(INF, INF)
	var max_p := Vector2(-INF, -INF)
	for corner in [
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(-half.x, half.y),
		Vector2(half.x, half.y),
	]:
		var lp: Vector2 = layer.to_local(cs.global_transform * corner)
		min_p.x = minf(min_p.x, lp.x)
		min_p.y = minf(min_p.y, lp.y)
		max_p.x = maxf(max_p.x, lp.x)
		max_p.y = maxf(max_p.y, lp.y)
	return Rect2(min_p, max_p - min_p)


## Bottom of hitbox: full AABB often sits in the upper half of a tile while feet touch the spike.
func _player_spike_probe_rect(layer: TileMapLayer) -> Rect2:
	var body := _player_aabb_in_layer_local(layer)
	var foot_h: float = maxf(body.size.y * 0.55, 8.0)
	if body.size.y < 1.0 or body.size.x < 1.0:
		var cs := $CollisionShape2D as CollisionShape2D
		var p := layer.to_local(cs.global_position + Vector2(0.0, 6.0))
		return Rect2(p - Vector2(6.0, 4.0), Vector2(12.0, 8.0))
	return Rect2(
		Vector2(body.position.x, body.position.y + body.size.y - foot_h),
		Vector2(body.size.x, foot_h)
	)


## Bottom half of tile (+ tiny upward bleed) so the seam with a half-tile collider still counts.
func _spike_damage_rect_local(layer: TileMapLayer, cell: Vector2i) -> Rect2:
	var ts := layer.tile_set
	var sz := Vector2(ts.tile_size)
	var top_left := layer.map_to_local(cell)
	var bleed := 2.0
	var y0 := sz.y * 0.5 - bleed
	return Rect2(top_left + Vector2(0.0, y0), Vector2(sz.x, sz.y - y0))


func _on_main_menu_reset(type) -> void:
	if type == "player":
		play = true
		position.x = 208
		position.y = 120
	else:
		play = false
		position.x = 1000
		position.y = 1000
	for x in saved_deleted_tiles:
		_tile_layer.set_cell(x,0,REMOVABLE_ATLAS,0)
	saved_deleted_tiles = []
	 # Replace with function body.
