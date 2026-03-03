extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _process(_delta):
	var dir := 0
	if Input.is_action_pressed("ui_right"):
		dir = 1
	elif Input.is_action_pressed("ui_left"):
		dir = -1

	if dir != 0:
		anim.flip_h = (dir < 0)
		if anim.animation != "run":
			anim.play("run")
	else:
		if anim.animation != "idle":
			anim.play("idle")
