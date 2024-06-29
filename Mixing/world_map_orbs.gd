extends TileMap

func pick_orb():
	# Based on player position, get orb
	var offset = Vector2i(randi_range(-2, 2), randi_range(-2, 2))
	var cellCoords = local_to_map(to_local($".."/Player.global_position)) + offset
	
	var cellData = get_cell_tile_data(0, cellCoords)
	
	if (cellData == null):
		push_error("Failed to get cell data for %d, %d" % [cellCoords.x, cellCoords.y])
		return "AIR"
	
	var elements: PackedStringArray = cellData.get_custom_data("Elements")
	if (elements.size() > 0):
		return elements[randi_range(0, elements.size() - 1)]
	else:
		# todo dirt
		return "EARTH"
