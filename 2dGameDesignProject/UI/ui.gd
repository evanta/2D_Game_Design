class_name UI
extends CanvasLayer

@onready var progress_bar: ProgressBar = %ProgressBar

var currentPlayerHealth : float  ##this should directly access the player health value, once the player exists
var maxPlayerHealth : float 

var player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	currentPlayerHealth = player.currentHealth
	maxPlayerHealth = player.maxHealth

func _process(delta: float):
	if player:
		progress_bar.value = player.currentHealth / player.maxHealth * 100
