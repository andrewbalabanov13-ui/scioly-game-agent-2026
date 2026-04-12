extends TileMapLayer
signal create_states(width_in_tiles,height_in_tiles,left_most_pixel,right_most_pixel,top_most_pixel,bottom_most_pixel)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	   
	var rect = self.get_used_rect()
	
	var left_tile_x = rect.position.x
	var right_tile_x = rect.position.x + rect.size.x
	var top_tile_y = rect.position.y
	var bottom_tile_y = rect.position.y + rect.size.y
	
	var tilemap_size_in_tiles = self.get_used_rect().size
	var width_in_tiles = tilemap_size_in_tiles.x
	var height_in_tiles = tilemap_size_in_tiles.y
	emit_signal("create_states",width_in_tiles,height_in_tiles,abs(right_tile_x),abs(left_tile_x),abs(top_tile_y),abs(bottom_tile_y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
