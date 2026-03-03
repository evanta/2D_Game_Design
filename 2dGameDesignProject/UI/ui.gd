class_name UI
extends CanvasLayer

@onready var progress_bar: ProgressBar = %ProgressBar

var currentPlayerHealth : float = 0.0 ##this should directly access the player health value, once the player exists
var maxPlayerHealth : float = 100.0

func _ready() -> void:
	#currentPlayerHealth = PlayerClass.currentHealth
	#maxPlayerHealth = PlayerClass.maxHealth
	pass

func _process(delta: float) -> void:
	## there are cleaner ways to do this but am waiting to see how archtecture plays out since player has not been set up yet
	progress_bar.value = currentPlayerHealth / maxPlayerHealth
