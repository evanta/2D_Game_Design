extends Area2D

var damage : float = 0.0
var speed : float = 500.0
var direction : float = 1.0
var lifetime : float = 1.0
var hasHit = false

func setup(dmg : float, dir : float, rng : float):
	damage = dmg
	direction = dir
	lifetime = rng
	if direction < 0:
		scale.x = -1

func _ready():
	add_to_group("projectile")
	body_entered.connect(onBodyEntered)
	area_entered.connect(onAreaEntered)
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
	print("BODY HIT: ", body.name, " groups: ", body.get_groups())
	if hasHit:
		print("Already hit, ignoring")
		return
	if body.is_in_group("player"):
		print("Hit player, ignoring")
		return
	hasHit = true
	print("Processing hit on: ", body.name)
	
	var overlapping = get_overlapping_areas()
	print("Overlapping areas: ", overlapping)
	for area in overlapping:
		if area.name == "Headshot":
			area.get_parent().onHeadshot()
			queue_free()
			return
	
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
	queue_free()

func onAreaEntered(area):
	print("AREA HIT: ", area.name, " parent: ", area.get_parent().name)
	if hasHit:
		return
	if area.is_in_group("player"):
		return
	hasHit = true
	
	if area.name == "Headshot":
		area.get_parent().onHeadshot()
	elif area.name == "Hitbox":
		var overlapping = get_overlapping_areas()
		for a in overlapping:
			if a.name == "Headshot":
				a.get_parent().onHeadshot()
				queue_free()
				return
		area.get_parent().takeDamage(damage)
	
	queue_free()
