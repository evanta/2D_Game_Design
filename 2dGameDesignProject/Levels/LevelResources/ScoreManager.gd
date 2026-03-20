extends Node

var enemiesKilled: int = 0
var levelTime: float = 0.0
var tracking: bool = false
var scoreScreen: PackedScene = preload("res://Levels/LevelResources/ScoreScene.tscn")
var headshots: int = 0

func _ready():
	resetLevel()

func _process(delta):
	if tracking:
		levelTime += delta

func resetLevel():
	enemiesKilled = 0
	levelTime = 0.0
	tracking = true
	headshots = 0

func registerKill():
	enemiesKilled += 1


func showScore(scoreData: Dictionary):
	var screen = scoreScreen.instantiate()
	get_tree().current_scene.add_child(screen)
	screen.currentLevelScene = get_tree().current_scene.scene_file_path
	screen.displayScore(scoreData)
