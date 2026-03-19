extends CanvasLayer

@onready var panel = $PanelContainer
@onready var titleLabel = $PanelContainer/VBoxContainer/TitleLabel
@onready var enemiesLabel = $PanelContainer/VBoxContainer/EnemiesLabel
@onready var timeLabel = $PanelContainer/VBoxContainer/TimeLabel
@onready var healthLabel = $PanelContainer/VBoxContainer/HealthLabel
@onready var totalLabel = $PanelContainer/VBoxContainer/TotalLabel
@onready var restartButton = $PanelContainer/VBoxContainer/HBoxContainer/RestartButton
@onready var menuButton = $PanelContainer/VBoxContainer/HBoxContainer/MenuButton

@export var currentLevelScene: String = ""

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS 
	restartButton.pressed.connect(_onRestartPressed)

func displayScore(scoreData: Dictionary):
	titleLabel.text = "LEVEL COMPLETE!"
	enemiesLabel.text = "Enemies Killed: %d/%d  —  %.1f pts" % [
		scoreData.enemiesKilled, scoreData.totalEnemies, scoreData.enemyScore
	]
	## if you are looking at this code and want to know how it works
	##the %d stuff are place holders that get replaced by the the stuff in the brackets in chronological order 
	timeLabel.text = "Time: %.1fs (par %.0fs)  —  %.1f pts" % [
		scoreData.timeTaken, scoreData.parTime, scoreData.timeScore
	]
	healthLabel.text = "Health: %.0f/%.0f  —  %.1f pts" % [
		scoreData.health, scoreData.maxHealth, scoreData.healthScore
	]
	totalLabel.text = "TOTAL SCORE: %.1f / 100" % scoreData.finalScore
	visible = true

func _onRestartPressed():
	get_tree().paused = false
	if currentLevelScene != "":
		get_tree().change_scene_to_file(currentLevelScene)
	else:
		get_tree().reload_current_scene()
	ScoreManager.resetLevel()
