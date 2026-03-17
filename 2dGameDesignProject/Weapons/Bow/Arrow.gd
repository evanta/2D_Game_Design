extends Area2D

var damage : float = 0.0
var speed : float = 500.0
var direction : float = 1.0
var lifetime : float = 1.0

func setup(dmg : float, dir : float, rng : float):
	damage = dmg
	direction = dir
	lifetime = rng
	if direction < 0:
		scale.x = -1

func _ready():
	body_entered.connect(onBodyEntered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	
	print("Arrow children: ", get_children())
	for child in get_children():
		print(child.name, " visible: ", child.visible if child is CanvasItem else "n/a")
	
	body_entered.connect(onBodyEntered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	position.x += speed * direction * delta
	print("Arrow pos: ", global_position)
	var cam = get_viewport().get_camera_2d()
	if cam:
		print("Arrow global: ", global_position, " Camera: ", cam.global_position)
	else:
		print("Arrow global: ", global_position, " NO CAMERA")


func onBodyEntered(body):
	if body is CharacterBody2D:
		return  # ignore the player
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
