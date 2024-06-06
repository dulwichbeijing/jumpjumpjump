extends Panel

var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!?*"
var num_chars = len(letters)
var active_letter = 0

var letter_indices = [0,0,0]

@onready var highlight_origin = %Highlight.global_position

func _ready():
	_update_letters()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible:
		return
	
	if Input.is_action_just_pressed("ui_left"):
		active_letter -= 1
		active_letter = clamp(active_letter, 0, 2)
		_move_highlight(-1)
	
	if Input.is_action_just_pressed("ui_right"):
		active_letter += 1
		active_letter = clamp(active_letter, 0, 2)
		_move_highlight(1)
		
	if Input.is_action_just_pressed("ui_accept") and active_letter == 2:
		hide()
		var name = ""
		
		for index in letter_indices:
			name += letters[index]
		
		HighScoreManager.add_score(name, Globals.last_score)
		get_tree().change_scene_to_file("res://menu/scores/scores.tscn")
	elif Input.is_action_just_pressed("ui_accept"):
		active_letter += 1
		active_letter = clamp(active_letter, 0, 2)
		_move_highlight(1)
	
	if Input.is_action_just_pressed("ui_up"):
		letter_indices[active_letter] = (letter_indices[active_letter] - 1) % num_chars
		
	if Input.is_action_just_pressed("ui_down"):
		letter_indices[active_letter] = (letter_indices[active_letter] + 1) % num_chars
	
	_update_letters()


func _update_letters():
	%Letter0/Letter.text = letters[letter_indices[0]]
	%Letter1/Letter.text = letters[letter_indices[1]]
	%Letter2/Letter.text = letters[letter_indices[2]]


func _move_highlight(direction):
	var tween = create_tween()
	tween.tween_property(%Highlight, "global_position", highlight_origin + Vector2(%Highlight.size.x * active_letter, 0), 0.4)
