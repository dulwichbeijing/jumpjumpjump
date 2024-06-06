extends Node2D

@onready var width: = get_viewport_rect().size.x
@onready var height: = get_viewport_rect().size.y

@export var platform: PackedScene
@onready var platformParent: = %Platforms
var platforms: = []
var platformCount: = 5

@onready var player: = %Player
@onready var treshold: = height * 0.5

var platform_x = width / 2

var scrollSpeed = 0.05
var points = 0
var gameOver = false


func _ready() -> void:
	player.global_position.y = treshold
	for i in platformCount:
		var inst: = platform.instantiate()
		inst.global_position.y = height / platformCount * i
		inst.global_position.x = rand_x()
		platformParent.add_child(inst)
		platforms.append(inst)
	#safety net - put lowest platform under player
	player.global_position.x = rand_x()
	platforms.back().global_position.x = player.global_position.x


func rand_x() -> float:
	platform_x = randi_range(28, width - 28)
	return platform_x


func _physics_process(_delta:float) -> void:
	if player.global_position.y < treshold:
		var move:float = lerp(0.0, treshold -player.global_position.y, scrollSpeed)
		player.global_position.y += move
		points += move
		%ScoreValue.text = str(int(points))
		
		for plat in platforms:
			plat.global_position.y += move
			if plat.global_position.y > height:
				plat.global_position.y -= height
				plat.global_position.x = rand_x()
	if player.global_position.y > height and !gameOver:
		game_over()


func game_over() -> void:
	gameOver = true
	$AudioStreamPlayer.play()
	
	var tween = create_tween()
	tween.tween_property(%Platforms, "modulate", Color(1, 1, 1, 0), 0.5)
	
	_check_high_score()


func _check_high_score():
	var top_scores = HighScoreManager.get_top_10_scores()
	var num_scores = len(top_scores)
	if num_scores == 0:
		_add_new_score()
		return
	
	
	if points > top_scores[num_scores - 1]["score"]:
		_add_new_score()
	else:
		%Timer.start()


func _add_new_score():
	Globals.last_score = points
	%NameEntry.show()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
