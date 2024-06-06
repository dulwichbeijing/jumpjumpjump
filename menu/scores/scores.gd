extends Control


func _ready():
	%MenuButton.grab_focus()
	
	var scores = HighScoreManager.get_top_10_scores()
	print("Printing scores")
	
	if len(scores) == 0:
		var no_scores: Label = Label.new()
		no_scores.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		no_scores.text = "No high scores found"
		%ScoresContainer.add_child(no_scores)
		return
	
	for score in scores:
		var score_row: HBoxContainer = HBoxContainer.new()
		var name_label: Label = Label.new()
		var score_label: Label = Label.new()
		score_label.text = str(score["score"])
		score_label.custom_minimum_size.x = 500
		name_label.text = score["name"]
		score_row.add_child(score_label)
		score_row.add_child(name_label)
		%ScoresContainer.add_child(score_row)


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
