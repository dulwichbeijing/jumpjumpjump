extends Node

const HIGH_SCORES_PATH = "user://high_scores.tres"

var high_scores: HighScores

func _ready():
	load_or_create()


func load_or_create():
	var file = FileAccess.open(HIGH_SCORES_PATH, FileAccess.READ)
	if file:
		high_scores = ResourceLoader.load(HIGH_SCORES_PATH)
		file.close()
	else:
		high_scores = HighScores.new()
		save_high_scores()


func save_high_scores():
	ResourceSaver.save(high_scores, HIGH_SCORES_PATH)


func add_score(player_name: String, score: int):
	var timestamp = Time.get_unix_time_from_system()
	var single_score = {
		"timestamp": timestamp,
		"name": player_name,
		"score": score
	}
	
	high_scores.scores.append(single_score) 
	save_high_scores()


# Function to sort scores and return the top 10
func get_top_10_scores() -> Array:
	# Sort the scores array in descending order by score
	high_scores.scores.sort_custom(_compare_scores)

	# Extract the top 10 scores
	var top_10_scores = high_scores.scores.slice(0, 10)
	
	return top_10_scores


func _compare_scores(a, b):
	return b["score"] < a["score"]


func get_high_scores() -> Array:
	return high_scores.scores
