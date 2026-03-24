class_name Ladder
extends Area2D
@export var playerInLadder : bool = false 
@onready var label: Label = %Label

func _ready() -> void:
	body_entered.connect(onBodyEntered)
	body_exited.connect(onBodyExited)
	label.visible = false


func onBodyEntered(body):
	if body.is_in_group("player"):
		playerInLadder = true
		label.visible = true
		print(playerInLadder)

func onBodyExited(body):
	if body.is_in_group("player"):
		playerInLadder = false
		label.visible = false
