extends TileMapLayer
signal create_states(width_in_tiles,height_in_tiles,top_left_tile_position,bottom_right_tile_position)

@export var height_in_tiles := 0
@export var width_in_tiles := 0
# Measure the used tile rect and broadcast dimensions for AI grid / state setup.
func _ready() -> void:
	   
	var rect = self.get_used_rect()
	
	var top_left_tile_position = Vector2(rect.position.x, rect.position.y)
	var bottom_right_tile_position = Vector2(rect.position.x + rect.size.x, rect.position.y + rect.size.y)
	
	var tilemap_size_in_tiles = self.get_used_rect().size
	width_in_tiles = tilemap_size_in_tiles.x
	height_in_tiles = tilemap_size_in_tiles.y
	emit_signal("create_states",width_in_tiles,height_in_tiles,top_left_tile_position,bottom_right_tile_position)
	print("row",+ height_in_tiles)
	print("col",+width_in_tiles)
	print(width_in_tiles*height_in_tiles)

# Reserved (unused).
func _process(delta: float) -> void:
	pass
