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
	if body is Player:
		return 
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
	if body.has_method("applyKnockback"):
		var knockDir = (body.global_position - global_position).normalized()
		body.applyKnockback(knockDir, 200.0)
	# player recoil on hit
	# player recoil on hit
# player recoil on hit
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var recoilDir = (player.global_position - body.global_position).normalized()
		recoilDir.y = 0
		var tween = create_tween()
		tween.tween_property(player, "position", player.position + recoilDir * 15.0, 0.1)
