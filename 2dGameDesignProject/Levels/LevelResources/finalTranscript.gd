extends CanvasLayer

@onready var title_label: Label = $Control/OverallVBox/TitleLabel

@onready var sword_header: Label = $Control/OverallVBox/SwordVbox/SwordHeader
@onready var sword_labels: Array = [
	$Control/OverallVBox/SwordVbox/SwordHbox/SwordLabel,
	$Control/OverallVBox/SwordVbox/SwordHbox/SwordLabel2,
	$Control/OverallVBox/SwordVbox/SwordHbox/SwordLabel3,
	$Control/OverallVBox/SwordVbox/SwordHbox/SwordLabel4,
]

@onready var bow_header: Label = $Control/OverallVBox/BowVbox/BowHeader
@onready var bow_labels: Array = [
	$Control/OverallVBox/BowVbox/BowHBox/BowLabel,
	$Control/OverallVBox/BowVbox/BowHBox/BowLabel2,
	$Control/OverallVBox/BowVbox/BowHBox/BowLabel3,
	$Control/OverallVBox/BowVbox/BowHBox/BowLabel4,
]

@onready var gauntlets_header: Label = $Control/OverallVBox/GauntletsVBox/GauntletsHeader
@onready var gauntlets_labels: Array = [
	$Control/OverallVBox/GauntletsVBox/GauntletsHbox/GauntLabel,
	$Control/OverallVBox/GauntletsVBox/GauntletsHbox/GauntLabel2,
	$Control/OverallVBox/GauntletsVBox/GauntletsHbox/GauntLabel3,
	$Control/OverallVBox/GauntletsVBox/GauntletsHbox/GauntLabel4,
]

@onready var gpaLabel: Label = $Control/OverallVBox/GPAlabel

## Map weapon names to their label arrays
var weaponLabels : Dictionary = {}

func _ready() -> void:
	weaponLabels = {
		"Sword": sword_labels,
		"Bow": bow_labels,
		"Gauntlets": gauntlets_labels,
	}
	buildTranscript()

func buildTranscript():
	title_label.text = "FINAL TRANSCRIPT"
	
	var allLabels : Array = [title_label]
	var totalGPA : float = 0.0
	var levelCount : int = 0
	
	for weapon : String in SceneManager.levelPaths:
		var levels : Array = SceneManager.levelPaths[weapon]
		var labels : Array = weaponLabels[weapon]
		
		## Fill in labels that have a corresponding level
		for i : int in range(levels.size()):
			var levelPath : String = levels[i]
			var grade : String = ScoreManager.getBestGrade(levelPath)
			var gpa : float = ScoreManager.gradeToGPA(grade)
			
			totalGPA += gpa
			levelCount += 1
			
			labels[i].text = "Lvl " + str(i + 1) + ": " + grade
			colorLabel(labels[i], grade)
			allLabels.append(labels[i])
		
		## Hide any extra labels that don't have a level yet
		for i : int in range(levels.size(), labels.size()):
			labels[i].visible = false
	
	var finalGPA : float = totalGPA / levelCount if levelCount > 0 else 0.0
	gpaLabel.text = "FINAL GPA: " + str(snapped(finalGPA, 0.01))
	colorGPA(gpaLabel, finalGPA)
	allLabels.append(gpaLabel)
	
	## Tween them in one by one like the score screen
	for label in allLabels:
		label.visible_ratio = 0.0
	var tween : Tween = create_tween()
	for label in allLabels:
		tween.tween_property(label, "visible_ratio", 1.0, 0.4)

func colorLabel(label : Label, grade : String):
	match grade:
		"S":
			var colorTween = create_tween().set_loops()
			colorTween.tween_method(func(h): label.modulate = Color.from_hsv(h, 1.0, 1.0), 0.0, 1.0, 2.0)
		"A": label.modulate = Color.GREEN
		"B": label.modulate = Color.CYAN
		"C": label.modulate = Color.YELLOW
		"D": label.modulate = Color.ORANGE
		"F": label.modulate = Color.RED

func colorGPA(label : Label, gpa : float):
	if gpa >= 3.5:
		var colorTween = create_tween().set_loops()
		colorTween.tween_method(func(h): label.modulate = Color.from_hsv(h, 1.0, 1.0), 0.0, 1.0, 2.0)
	elif gpa >= 3.0: label.modulate = Color.GREEN
	elif gpa >= 2.0: label.modulate = Color.CYAN
	elif gpa >= 1.0: label.modulate = Color.YELLOW
	else: label.modulate = Color.RED
