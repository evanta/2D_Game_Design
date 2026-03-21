extends CanvasLayer

@onready var titleLabel: Label = $Control/PanelContainer/VBoxContainer/TitleLable
@onready var enemiesLabel: Label = $Control/PanelContainer/VBoxContainer/EnemiesLabel
@onready var timeLabel: Label = $Control/PanelContainer/VBoxContainer/TimeLabel
@onready var healthLabel: Label = $Control/PanelContainer/VBoxContainer/HealthLabel
@onready var totalLabel: Label = $Control/PanelContainer/VBoxContainer/TotalLabel
@onready var restartButton: Button = $Control/PanelContainer/VBoxContainer/HBoxContainer/RestartButton
@onready var headshots_label: Label = $Control/PanelContainer/VBoxContainer/HeadshotsLabel
@onready var gradeLabel: Label = $Control/PanelContainer/VBoxContainer/GradeLabel

@export var currentLevelScene: String = ""

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS 
	restartButton.pressed.connect(_onRestartPressed)
	headshots_label.visible = false
	gradeLabel.visible = false

func displayScore(scoreData: Dictionary):
	titleLabel.text = "LEVEL COMPLETE!"
	enemiesLabel.text = "Enemies Killed: " + str(scoreData.enemiesKilled) + "/" + str(scoreData.totalEnemies) + " = " + str(snapped(scoreData.enemyScore, 0.1)) + " pts"
	timeLabel.text = "Time: " + str(snapped(scoreData.timeTaken, 0.1)) + "s / " + str(scoreData.parTime) + "s = " + str(snapped(scoreData.timeScore, 0.1)) + " pts"
	healthLabel.text = "Health: " + str(scoreData.health) + "/" + str(scoreData.maxHealth) + " = " + str(snapped(scoreData.healthScore, 0.1)) + " pts"
	totalLabel.text = "TOTAL SCORE: " + str(snapped(scoreData.finalScore, 0.1))
	
	var labels = [titleLabel, enemiesLabel, timeLabel, healthLabel]
	
	if scoreData.headshots > 0:
		headshots_label.text = "Headshots: " + str(scoreData.headshots) + " = " + str(snapped(scoreData.headshotScore, 0.1)) + " pts"
		headshots_label.visible = true
		labels.append(headshots_label)
	
	labels.append(totalLabel)
	
	## grade comes last for the big reveal
	if scoreData.has("grade"):
		gradeLabel.text = "GRADE: " + scoreData.grade
		gradeLabel.visible = true
		colorGrade(scoreData.grade)
		labels.append(gradeLabel)
	
	visible = true
	
	for label in labels:
		label.visible_ratio = 0.0
	var tween = create_tween()
	for label in labels:
		tween.tween_property(label, "visible_ratio", 1.0, 0.5)

func colorGrade(grade : String):
	match grade:
		"S": 
			var colorTween = create_tween().set_loops()
			colorTween.tween_method(func(h): gradeLabel.modulate = Color.from_hsv(h, 1.0, 1.0), 0.0, 1.0, 2.0)
		"A": gradeLabel.modulate = Color.GREEN
		"B": gradeLabel.modulate = Color.CYAN
		"C": gradeLabel.modulate = Color.YELLOW
		"D": gradeLabel.modulate = Color.ORANGE
		"F": gradeLabel.modulate = Color.RED

func _onRestartPressed():
	get_tree().paused = false
	if currentLevelScene != "":
		get_tree().change_scene_to_file(currentLevelScene)
	else:
		get_tree().reload_current_scene()
	ScoreManager.resetLevel()
