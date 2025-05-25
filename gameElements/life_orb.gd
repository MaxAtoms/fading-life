extends Area2D

@export var score = 100
@export var radius = 3.2
@export var radius_randomness = 1.0
@export var decay_probability = 0.2
@export var decay_delay = 5
@export var decay_interval = 1
@export var decay_interval_randomness = 0.05
@onready var decay_timer = $LifeOrbTimer
@onready var object_tile_map: TileMapLayer = $"../Control/ObjectTileMap"
@onready var grass_tile_map: TileMapLayer = $"../Control/GrassTileMap"

@export var orb_scene = preload("res://gameElements/life_orb.tscn")

const GRASS_TERRAIN_SET_ID = 0
const GRASS_TERRAIN_ID = 0
const GRASS_TILE_ID = 1
const DEAD_OBJECT_ID = 2
const ALIVE_OBJECT_ID = 3

var active = false
var grass_positions = []
var object_positions = []

func _ready() -> void:
	$AnimatedSprite2D.frame = randi() % $AnimatedSprite2D.sprite_frames.get_frame_count("default")

	var final_radius = radius + randf_range(-radius_randomness, radius_randomness)
	var max_radius = ceil(final_radius)

	for x in range(-max_radius, max_radius + 1):
		for y in range(-max_radius, max_radius + 1):
			if x * x + y * y <= final_radius * final_radius:
				var grass_pos = grass_tile_map.local_to_map(global_position) + Vector2i(x, y)
				var object_pos = object_tile_map.local_to_map(global_position) + Vector2i(x, y)
				grass_positions.append(grass_pos)
				object_positions.append(object_pos)

func _physics_process(delta: float) -> void:
	if not active:
		$AnimatedSprite2D.play()

func activate():
	$AudioStreamPlayer.play(0)
	
	grass_tile_map.set_cells_terrain_connect(grass_positions, GRASS_TERRAIN_SET_ID, GRASS_TERRAIN_ID, false)
	for pos in object_positions:
		object_tile_map.set_cell(pos, ALIVE_OBJECT_ID, object_tile_map.get_cell_atlas_coords(pos))

	var parent = get_parent()
	if parent.name == "Map":
		parent.score += score

	active = true
	visible = false
	decay_timer.start(decay_delay)
	decay_timer.wait_time = decay_interval + randf_range(-decay_interval_randomness, decay_interval_randomness)
	
	var max_x = 1280
	var max_y = 800

	var orb = orb_scene.instantiate()
	orb.position = Vector2(randf_range(0, max_x), randf_range(0, max_y))
	
	if parent.name == "Map":
		parent.add_child(orb)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not active:
		activate()

func _on_life_orb_timer() -> void:
	var num_grass = 0
	var grass_to_remove = []
	var objects_to_remove = []

	for i in range(0, len(grass_positions)):
		var grass_pos = grass_positions[i]
		var object_pos = object_positions[i]
		if grass_tile_map.get_cell_source_id(grass_pos) == GRASS_TILE_ID:
			if randf() < decay_probability:
				grass_to_remove.append(grass_pos)
				objects_to_remove.append(object_pos)
			else:
				num_grass += 1

	grass_tile_map.set_cells_terrain_connect(grass_to_remove, GRASS_TERRAIN_SET_ID, -1, false)
	for pos in objects_to_remove:
		object_tile_map.set_cell(pos, DEAD_OBJECT_ID, object_tile_map.get_cell_atlas_coords(pos))

	if num_grass == 0:
		grass_tile_map.set_cells_terrain_connect(grass_positions, GRASS_TERRAIN_SET_ID, -1, false)
		for pos in object_positions:
			object_tile_map.set_cell(pos, DEAD_OBJECT_ID, object_tile_map.get_cell_atlas_coords(pos))
		decay_timer.stop()
		queue_free()
