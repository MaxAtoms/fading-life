extends Area2D

@export var radius = 3.2
@onready var tile_map: TileMapLayer = $"../ParallaxBackground/ParallaxLayer/TileMapLayer"

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play()

func destroy():
	var pos = global_position
	for i in range(-radius, radius + 1):
		for j in range(-radius, radius + 1):
			if i * i + j * j <= radius * radius:
				tile_map.set_cell(tile_map.local_to_map(pos) + Vector2i(i, j), 3, Vector2i(0, 0))

	Globals.score += 100
	queue_free()


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	destroy()
