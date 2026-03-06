extends Area2D

var damage : float = 0.0
var speed : float = 500.0
var direction : float = 1.0

func setup(dmg : float, dir : float):
	damage = dmg
	direction = dir
	if direction < 0:
		scale.x = -1

func _ready():
	body_entered.connect(onBodyEntered)
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _process(delta):
	position.x += speed * direction * delta

func onBodyEntered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
