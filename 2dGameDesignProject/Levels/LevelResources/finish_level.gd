extends Area2D
@export var maxTime: float = 120.0
@export var maxEnemies: int = 10
@export var maxHealth: float = 100.0
@export_group("Score Mulitpliers")
@export var timeMult : float = 1580
@export var healthMult : float = 740
@export var enemyMult : float = 680
@export var styleKillMult : float = 800
@export_group("Grade Thresholds")
@export var sMinScore : float = 3500
@export var aMinScore : float = 2800
@export var bMinScore : float = 2000
@export var cMinScore : float = 1200
@export var dMinScore : float = 600

func _ready():
	maxEnemies = get_tree().get_nodes_in_group("enemy").size()
	body_entered.connect(_onBodyEntered)

func _onBodyEntered(body):
	if body.is_in_group("player"):
		var score = calculateScore(body)
		var grade = getGrade(score.finalScore)
		score["grade"] = grade
		get_tree().paused = true
		var levelPath = get_tree().current_scene.scene_file_path
		ScoreManager.saveScore(levelPath, score.finalScore)
		ScoreManager.showScore(score)
		if SceneManager.canAdvance(grade):
			SceneManager.unlockNextLevel(levelPath)

func getGrade(score : float) -> String:
	if score >= sMinScore:
		return "S"
	elif score >= aMinScore:
		return "A"
	elif score >= bMinScore:
		return "B"
	elif score >= cMinScore:
		return "C"
	elif score >= dMinScore:
		return "D"
	else:
		return "F"

func calculateScore(player) -> Dictionary:
	var enemiesKilled = ScoreManager.enemiesKilled
	var timeTaken = ScoreManager.levelTime
	var currentHealth = player.currentHealth
	var enemyRatio = clampf(float(enemiesKilled) / maxEnemies, 0.0, 1.0)
	var timeRatio = clampf(1.0 - (timeTaken / maxTime), 0.0, 1.0)
	var healthRatio = clampf(currentHealth / maxHealth, 0.0, 1.0)
	var finalScore = (enemyRatio * enemyMult) + (timeRatio * timeMult) + (healthRatio * healthMult) + (ScoreManager.styleKills * styleKillMult)
	return {
		"enemiesKilled": enemiesKilled,
		"totalEnemies": maxEnemies,
		"timeTaken": timeTaken,
		"parTime": maxTime,
		"health": currentHealth,
		"maxHealth": maxHealth,
		"enemyScore": enemyRatio * enemyMult,
		"timeScore": timeRatio * timeMult,
		"healthScore": healthRatio * healthMult,
		"styleKills": ScoreManager.styleKills,
		"styleKillScore": ScoreManager.styleKills * styleKillMult,
		"finalScore": finalScore
	}
