extends CanvasLayer


func _ready():
	visible = false


func _on_player_dead() -> void:
	visible = true


func _on_map_score_changed(new_score: Variant) -> void:
	var score_text = "Score: " + str(new_score)
	$VBoxContainer/Score.text = score_text
