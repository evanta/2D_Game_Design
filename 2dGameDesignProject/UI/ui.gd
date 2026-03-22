class_name UI
extends CanvasLayer

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var previous_score_label: Label = $Control/HBoxContainer2/PreviousScoreLabel
@onready var best_score_label: Label = $Control/HBoxContainer2/BestScoreLabel

var currentPlayerHealth : float  ##this should directly access the player health value, once the player exists
var maxPlayerHealth : float 

var player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	currentPlayerHealth = player.currentHealth
	maxPlayerHealth = player.maxHealth
	var levelPath = get_tree().current_scene.scene_file_path
	var prev = ScoreManager.getPreviousScore(levelPath)
	var best = ScoreManager.getBestScore(levelPath)
	previous_score_label.text = "Previous: " + str(snapped(prev, 0.1))
	previous_score_label.text = "Best: " + str(snapped(best, 0.1))

func _process(delta: float):
	if player:
		progress_bar.value = player.currentHealth / player.maxHealth * 100
