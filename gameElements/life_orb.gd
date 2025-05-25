extends Area2D

@export var score = 100
@export var radius = 3.2
@export var radius_randomness = 1.0
@export var decay_probability = 0.2
@export var decay_delay = 5
@export var decay_interval = 1
@export var decay_interval_randomness = 0.05
@onready var decay_timer = $LifeOrbTimer
@onready var tile_map: TileMapLayer = $"../Control/ParallaxBackground/ParallaxLayer/GrassTileMap"

const GRASS_TERRAIN_SET_ID = 0
const GRASS_TERRAIN_ID = 0
const GRASS_TILE_ID = 1

var active = false
var grass_positions = []

func _ready() -> void:
	var final_radius = radius + randf_range(-radius_randomness, radius_randomness)
	var max_radius = ceil(final_radius)

	for x in range(-max_radius, max_radius + 1):
		for y in range(-max_radius, max_radius + 1):
			if x * x + y * y <= final_radius * final_radius:
				grass_positions.append(tile_map.local_to_map(global_position) + Vector2i(x, y))

func _physics_process(delta: float) -> void:
	if not active:
		$AnimatedSprite2D.play()

func activate():
	tile_map.set_cells_terrain_connect(grass_positions, GRASS_TERRAIN_SET_ID, GRASS_TERRAIN_ID, false)
	Globals.score += score
	active = true
	visible = false
	decay_timer.start(decay_delay)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not active:
		activate()

func _on_life_orb_timer() -> void:
	decay_timer.wait_time = decay_interval + randf_range(-decay_interval_randomness, decay_interval_randomness)
	var num_grass = 0
	var to_temove = []

	for pos in grass_positions:
		if tile_map.get_cell_source_id(pos) == GRASS_TILE_ID:
			if randf() < decay_probability:
				to_temove.append(pos)
			else:
				num_grass += 1

	tile_map.set_cells_terrain_connect(to_temove, GRASS_TERRAIN_SET_ID, -1, false)

	if num_grass == 0:
		tile_map.set_cells_terrain_connect(grass_positions, GRASS_TERRAIN_SET_ID, -1, false)
		decay_timer.stop()
		queue_free()
