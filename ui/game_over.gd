extends Control


func _ready():
	var score_text = "Score: " + str(Globals.score)
	$VBoxContainer/Score.text = score_text
