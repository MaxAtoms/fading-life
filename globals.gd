extends Node

signal score_changed(new_score)

var _score := 0

var score:
	get:
		return _score
	set(value):
		_set_score(value)

func _set_score(value):
	score_changed.emit(value)
	_score = value
	
