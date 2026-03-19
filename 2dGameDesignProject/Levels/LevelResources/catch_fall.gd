extends Area2D


func _ready():
	body_entered.connect(onBodyEntered)


func onBodyEntered(body):
	if body.has_method("fallRespawn"):
		body.fallRespawn()
	if body.is_in_group("enemy"):
		body.die()
