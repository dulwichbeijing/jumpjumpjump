extends Node

var last_score: int
var high_score_manager: HighScoreManager

func _ready():
	high_score_manager = get_tree().root.find_child("HighScoreManager")
