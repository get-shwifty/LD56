extends TileMapLayer

func _ready():
	randomize_tiles()

# Function to randomize tiles
func randomize_tiles():
	var used_cells = get_used_cells()  # Get all used cells in this layer

	for cell in used_cells:
		var source_id = get_cell_source_id(cell)  # Get the source ID of the tile at this position
		if source_id != -1:
			var alt_tile_count = get_cell_alternative_tile(cell)  # Get the count of alternative tiles for the cell

			if alt_tile_count > 0:  # If there are alternatives
				var random_index = randi() % alt_tile_count  # Get a random index for the alternative tile
				var new_alt_tile = get_cell_alternative_tile(cell, random_index)  # Get the alternative tile ID
				set_cell(cell, source_id, Vector2i(-1, -1), new_alt_tile)  # Set the new random alternative tile
