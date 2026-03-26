extends Node
var enemiesKilled: int = 0
var levelTime: float = 0.0
var tracking: bool = false
var scoreScreen: PackedScene = preload("res://Levels/LevelResources/ScoreScene.tscn")
var styleKills: int = 0
var previousScores : Dictionary = {}  ## levelPath : last score
var bestScores : Dictionary = {}      ## levelPath : best score
var currentLevel : String = ""

var bestGrades : Dictionary = {} ## levelPath : grade letter
func _ready():
	resetLevel()

func _process(delta):
	if tracking:
		levelTime += delta

func resetLevel():
	enemiesKilled = 0
	levelTime = 0.0
	tracking = true
	styleKills = 0

func registerKill():
	enemiesKilled += 1
	print("something just used me")

func showScore(scoreData: Dictionary):
	var screen = scoreScreen.instantiate()
	get_tree().current_scene.add_child(screen)
	screen.currentLevelScene = get_tree().current_scene.scene_file_path
	screen.displayScore(scoreData)


func saveScore(levelPath : String, score : float, grade : String):
	previousScores[levelPath] = score
	if not bestScores.has(levelPath) or score > bestScores[levelPath]:
		bestScores[levelPath] = score
		bestGrades[levelPath] = grade

func getPreviousScore(levelPath : String) -> float:
	if previousScores.has(levelPath):
		return previousScores[levelPath]
	return 0.0

func getBestScore(levelPath : String) -> float:
	if bestScores.has(levelPath):
		return bestScores[levelPath]
	return 0.0

func getBestGrade(levelPath : String) -> String:
	if bestGrades.has(levelPath):
		return bestGrades[levelPath]
	return ""


func gradeToGPA(grade : String) -> float:
	match grade:
		"S": return 4.2
		"A": return 4.0
		"B": return 3.0
		"C": return 2.0
		"D": return 1.0
		"F": return 0.0
		_: return 0.0
