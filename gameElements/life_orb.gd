extends Area2D

@export var radius = 3.2
@onready var tile_map: TileMapLayer = $"../ParallaxBackground/ParallaxLayer/GrassTileMap"

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play()

func destroy():
	var pos = global_position
	var positions = []
	for i in range(-radius, radius + 1):
		for j in range(-radius, radius + 1):
			if i * i + j * j <= radius * radius:
				positions.append(tile_map.local_to_map(pos) + Vector2i(i, j))

	Globals.score += 100
	tile_map.set_cells_terrain_connect(positions, 0, 0)
	queue_free()


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	destroy()
