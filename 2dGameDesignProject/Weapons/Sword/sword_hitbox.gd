extends Area2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

var damage : float = 0.0

func setup(dmg : float, base_range : float, current_range : float):
	damage = dmg
	if current_range > base_range:
		var scale_factor = current_range / base_range
		collision_shape_2d.shape.size.x += scale_factor
		collision_shape_2d.shape.size.y += scale_factor

func _ready():
	var swordPNG = get_parent().get_node("SwordPNG")
	swordPNG.visible = false
	body_entered.connect(onBodyEntered)
	await get_tree().create_timer(0.2).timeout
	swordPNG.visible = true
	queue_free()

func onBodyEntered(body):
	## to be reevaluated
	if body.has_method("take_damage"):
		body.take_damage(damage)
