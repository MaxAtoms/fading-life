extends Area2D

@export var heal_amount := 10.0
@export var heal_interval := 0.5

var player_in_zone: Node = null
@onready var timer: Timer = $HealTimer

func _ready():
	timer.wait_time = heal_interval
	timer.one_shot = false
	timer.autostart = false
	timer.timeout.connect(_on_heal_timer_timeout)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		player_in_zone = body
		body.stop_timer()
		timer.start()
		

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == player_in_zone:
		body.start_timer()
		player_in_zone = null
		timer.stop()


func _on_heal_timer_timeout() -> void:
	if player_in_zone and player_in_zone.is_inside_tree():
		if player_in_zone.has_method("heal"):
			player_in_zone.heal(heal_amount)
