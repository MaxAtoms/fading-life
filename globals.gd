extends Node



var _score := 0

var score:
	get:
		return _score
	set(value):
		_set_score(value)

func _set_score(value):
	_score = value
	
