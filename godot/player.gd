extends CharacterBody2D
var score = 0

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const REMOVABLE_ATLAS := Vector2i(11, 7)
const SPIKE_ATLAS := Vector2i(8,3)

@onready var _tile_layer: TileMapLayer = get_node("../Tiles/TileMapLayerZ2")


func _physics_process(delta: float) -> void:
	# Add the gravity.
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
	var player_aabb := _player_aabb_in_layer_local(_tile_layer)
	for y in range(bounds.position.y, bounds.end.y):
		for x in range(bounds.position.x, bounds.end.x):
			var cell := Vector2i(x, y)
			if _tile_layer.get_cell_source_id(cell) == -1:
				continue
			if _tile_layer.get_cell_atlas_coords(cell) == REMOVABLE_ATLAS:
				_tile_layer.erase_cell(cell)
				score += 1
				print(score)
			if _tile_layer.get_cell_atlas_coords(cell) == SPIKE_ATLAS:
				if player_aabb.intersects(_spike_damage_rect_local(_tile_layer, cell)):
					print("touched!")


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


## Spikes only hurt on the bottom half of the tile (matches a short physics polygon).
func _spike_damage_rect_local(layer: TileMapLayer, cell: Vector2i) -> Rect2:
	var ts := layer.tile_set
	var sz := Vector2(ts.tile_size)
	var top_left := layer.map_to_local(cell)
	return Rect2(top_left + Vector2(0.0, sz.y * 0.5), Vector2(sz.x, sz.y * 0.5))
