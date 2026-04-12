extends TileMapLayer
signal create_states(width_in_tiles,height_in_tiles,top_left_tile_position,bottom_right_tile_position)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	   
	var rect = self.get_used_rect()
	
	var top_left_tile_position = Vector2(rect.position.x, rect.position.y)
	var bottom_right_tile_position = Vector2(rect.position.x + rect.size.x, rect.position.y + rect.size.y)
	
	var tilemap_size_in_tiles = self.get_used_rect().size
	var width_in_tiles = tilemap_size_in_tiles.x
	var height_in_tiles = tilemap_size_in_tiles.y
	emit_signal("create_states",width_in_tiles,height_in_tiles,top_left_tile_position,bottom_right_tile_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
