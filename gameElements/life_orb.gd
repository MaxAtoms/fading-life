extends Area2D

@export var life_zone: PackedScene

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play()

func destroy():
	var pos = global_position

	if life_zone:
		var new_instance = life_zone.instantiate()
		get_parent().add_child(new_instance)
		new_instance.global_position = pos
		
	queue_free()


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	destroy()
