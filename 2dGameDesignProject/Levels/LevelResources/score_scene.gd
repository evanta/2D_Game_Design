extends CanvasLayer

@onready var titleLabel: Label = $Control/PanelContainer/VBoxContainer/TitleLable
@onready var enemiesLabel: Label = $Control/PanelContainer/VBoxContainer/EnemiesLabel
@onready var timeLabel: Label = $Control/PanelContainer/VBoxContainer/TimeLabel
@onready var healthLabel: Label = $Control/PanelContainer/VBoxContainer/HealthLabel
@onready var totalLabel: Label = $Control/PanelContainer/VBoxContainer/TotalLabel
@onready var restartButton: Button = $Control/PanelContainer/VBoxContainer/HBoxContainer/RestartButton


@export var currentLevelScene: String = ""

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS 
	restartButton.pressed.connect(_onRestartPressed)

func displayScore(scoreData: Dictionary):
	titleLabel.text = "LEVEL COMPLETE!"
	enemiesLabel.text = "Enemies Killed: " + str(scoreData.enemiesKilled) + "/" + str(scoreData.totalEnemies)
	timeLabel.text = "Time: " + str(snapped(scoreData.timeTaken, 0.1)) + "s"
	healthLabel.text = "Health: " + str(scoreData.health) + "/" + str(scoreData.maxHealth)
	totalLabel.text = "TOTAL SCORE: " + str(snapped(scoreData.finalScore, 0.1))
	visible = true
	
	var labels = [titleLabel, enemiesLabel, timeLabel, healthLabel, totalLabel]
	for label in labels:
		label.visible_ratio = 0.0

	var tween = create_tween()
	for label in labels:
		tween.tween_property(label, "visible_ratio", 1.0, 0.5)

func _onRestartPressed():
	get_tree().paused = false
	if currentLevelScene != "":
		get_tree().change_scene_to_file(currentLevelScene)
	else:
		get_tree().reload_current_scene()
	ScoreManager.resetLevel()
