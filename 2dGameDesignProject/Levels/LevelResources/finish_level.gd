extends Area2D

@export var maxTime: float = 120.0  
@export var maxEnemies: int = 10     
@export var maxHealth: float = 100.0 

@export_group("Score Mulitpliers")
@export var timeMult : float = 1580
@export var healthMult : float = 740
@export var enemyMult : float = 680
@export var headshotMult : float = 800

func _ready():
	maxEnemies = get_tree().get_nodes_in_group("enemy").size()
	body_entered.connect(_onBodyEntered)
	

func _onBodyEntered(body):
	if body.is_in_group("player"):
		var score = calculateScore(body)
		get_tree().paused = true
		ScoreManager.showScore(score)

func calculateScore(player) -> Dictionary:
	var enemiesKilled = ScoreManager.enemiesKilled
	var timeTaken = ScoreManager.levelTime
	var currentHealth = player.currentHealth

	var enemyRatio = clampf(float(enemiesKilled) / maxEnemies, 0.0, 1.0)
	var timeRatio = clampf(1.0 - (timeTaken / maxTime), 0.0, 1.0)  # faster = higher
	var healthRatio = clampf(currentHealth / maxHealth, 0.0, 1.0)

	var finalScore = (enemyRatio * enemyMult) + (timeRatio * timeMult) + (healthRatio * healthMult) + (ScoreManager.headshots * headshotMult)

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
		"headshots" : ScoreManager.headshots,
		"headshotScore" : ScoreManager.headshots * headshotMult,
		"finalScore": finalScore
	}
