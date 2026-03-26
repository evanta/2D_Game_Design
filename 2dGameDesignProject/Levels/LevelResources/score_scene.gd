extends CanvasLayer
@onready var titleLabel: Label = $Control/PanelContainer/VBoxContainer/TitleLable
@onready var enemiesLabel: Label = $Control/PanelContainer/VBoxContainer/EnemiesLabel
@onready var timeLabel: Label = $Control/PanelContainer/VBoxContainer/TimeLabel
@onready var healthLabel: Label = $Control/PanelContainer/VBoxContainer/HealthLabel
@onready var totalLabel: Label = $Control/PanelContainer/VBoxContainer/TotalLabel
@onready var restartButton: Button = $Control/ButtonContainer/RestartButton
@onready var styleKillsLabel: Label = $Control/PanelContainer/VBoxContainer/HeadshotsLabel
@onready var gradeLabel: Label = $Control/PanelContainer/VBoxContainer/GradeLabel
@export var currentLevelScene: String = ""
@onready var next_level_button: Button = $Control/ButtonContainer/NextLevelButton
@onready var main_menu: Button = $Control/ButtonContainer/MainMenu
@onready var gradeStamp: TextureRect = $Control/ColorRect
@onready var button_container: HBoxContainer = $Control/ButtonContainer
@onready var gotta_geta_b_label: Label = $Control/ButtonContainer/GottaGetaBLabel

var gradeImages : Dictionary = {
	"S": preload("res://Assets/Grade Screens/GradeA.png"),##change to S when finish
	"A": preload("res://Assets/Grade Screens/GradeA.png"),
	"B": preload("res://Assets/Grade Screens/GradeB.png"),
	"C": preload("res://Assets/Grade Screens/GradeC.png"),
	"D": preload("res://Assets/Grade Screens/GradeD.png"),
	"F": preload("res://Assets/Grade Screens/GradeF.png"),
}

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	restartButton.pressed.connect(_onRestartPressed)
	styleKillsLabel.visible = false
	gradeLabel.visible = false
	gradeStamp.visible = false
	button_container.visible = false
	next_level_button.pressed.connect(_onNextLevelPressed)
	next_level_button.disabled = true
	main_menu.pressed.connect(_onMainMenuPressed)
	gradeStamp.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	gradeStamp.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	gotta_geta_b_label.visible = false


func displayScore(scoreData: Dictionary):
	titleLabel.text = "LEVEL COMPLETE!"
	enemiesLabel.text = "Enemies Killed: " + str(scoreData.enemiesKilled) + "/" + str(scoreData.totalEnemies) + " = " + str(snapped(scoreData.enemyScore, 0.1)) + " pts"
	timeLabel.text = "Time: " + str(snapped(scoreData.timeTaken, 0.1)) + "s / " + str(scoreData.parTime) + "s = " + str(snapped(scoreData.timeScore, 0.1)) + " pts"
	healthLabel.text = "Health: " + str(scoreData.health) + "/" + str(scoreData.maxHealth) + " = " + str(snapped(scoreData.healthScore, 0.1)) + " pts"
	totalLabel.text = "TOTAL SCORE: " + str(snapped(scoreData.finalScore, 0.1))
	
	var labels = [titleLabel, enemiesLabel, timeLabel, healthLabel]
	
	if scoreData.styleKills > 0:
		styleKillsLabel.text = "Style Kills: " + str(scoreData.styleKills) + " = " + str(snapped(scoreData.styleKillScore, 0.1)) + " pts"
		styleKillsLabel.visible = true
		labels.append(styleKillsLabel)
	
	labels.append(totalLabel)
	
	## grade comes last for the big reveal
	if scoreData.has("grade"):
		gradeLabel.text = "GRADE: " + scoreData.grade
		gradeLabel.visible = true
		colorGrade(scoreData.grade)
		labels.append(gradeLabel)
		# Enable next level if grade is B or better and there IS a next level
		if SceneManager.canAdvance(scoreData.grade) and SceneManager.getNextLevel(currentLevelScene) != "":
			next_level_button.disabled = false
		else:
			next_level_button.disabled = true
	if SceneManager.getNextLevel(currentLevelScene) == "":
		next_level_button.visible = false
		gotta_geta_b_label.visible = true
		var weapon = _getWeaponName()
		gotta_geta_b_label.text = weapon + " course completed! Return to the main menu"
	elif SceneManager.canAdvance(scoreData.grade):
		next_level_button.disabled = false
		gotta_geta_b_label.visible = false
	else:
		next_level_button.disabled = true
		gotta_geta_b_label.visible = true
		gotta_geta_b_label.text = "Need a B or higher to advance..."
	
	visible = true
	
	for label in labels:
		label.visible_ratio = 0.0
	
	## step 1: Score labels print one by one -- then do the stamp 
	var tween = create_tween()
	for label in labels:
		tween.tween_property(label, "visible_ratio", 1.0, 0.5)
	
	## step 2: Stamp slams down after scores finish
	if scoreData.has("grade"):
		gradeStamp.texture = gradeImages[scoreData.grade] ## dictionary get
		gradeStamp.pivot_offset = gradeStamp.size / 2
		gradeStamp.scale = Vector2(3.0, 3.0)
		gradeStamp.modulate.a = 0.0
		
		tween.tween_callback(func():
			gradeStamp.visible = true
		)
		tween.tween_property(gradeStamp, "scale", Vector2(1.0, 1.0), 0.15)\
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
		tween.parallel().tween_property(gradeStamp, "modulate:a", 1.0, 0.15)
		
		# Small pause to let the stamp land
		tween.tween_interval(0.3)
	
	## step 3: button fade in on top
	tween.tween_callback(func():
		button_container.visible = true
		button_container.modulate.a = 0.0
	)
	tween.tween_property(button_container, "modulate:a", 1.0, 0.5)
func _getWeaponName() -> String:
	for weapon: String in SceneManager.levelPaths:
		if currentLevelScene in SceneManager.levelPaths[weapon]:
			return weapon
	return ""
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

func _onNextLevelPressed() -> void:
	SceneManager.goToNextLevel(currentLevelScene)

func _onMainMenuPressed():
	SceneManager.goToMainMenu()
