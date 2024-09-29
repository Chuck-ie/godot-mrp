extends TileMapLayer

var stale_tiles: Array[Vector2i]
var latest_mouse_coords = Vector2i.ZERO

func _ready() -> void:
	for x in range(0, 10):
		for y in range(0, 6):
			set_cell(Vector2i(x-5, y-3), 0, Vector2i.ZERO)

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if stale_tiles.has(coords):
		tile_data.texture_origin += Vector2i(0, 64)
		stale_tiles.erase(coords)

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return stale_tiles.has(coords)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_coords = local_to_map(get_viewport().get_camera_2d().get_global_mouse_position())
		if latest_mouse_coords != mouse_coords:
			latest_mouse_coords = mouse_coords
			set_cell(latest_mouse_coords, 0, Vector2i.ZERO, 1)
			stale_tiles.append(latest_mouse_coords)
			call_deferred("notify_runtime_tile_data_update")
			#notify_runtime_tile_data_update()
