extends Area2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
var damage : float = 0.0
var persistent: bool = false
@onready var bonk_2: AudioStreamPlayer2D = $Bonk2
@onready var bonk_1: AudioStreamPlayer2D = $Bonk1

func _ready():
	var swordPNG = get_parent().get_node("SwordPNG")
	body_entered.connect(onBodyEntered)
	if not persistent:
		swordPNG.visible = false
		await get_tree().create_timer(0.2).timeout
		swordPNG.visible = true
		queue_free()

func setup(dmg : float, base_range : float, current_range : float):
	damage = dmg
	if current_range > base_range:
		var scale_factor = current_range / base_range
		collision_shape_2d.shape.size.x += scale_factor
		collision_shape_2d.shape.size.y += scale_factor
func onBodyEntered(body):
	if body is Player:
		return
	if body.has_method("takeDamage"):
		var willKill = body.health - damage <= 0
		var isStyleKill = willKill and body.has_method("onStyleKill") and get_tree().get_first_node_in_group("player") and get_tree().get_first_node_in_group("player").downsmash
		if isStyleKill:
			body.health -= damage
			body.flashRed()
			bonk_2.play(0.5)
			body.onStyleKill("BONK!")
			
		else:
			body.takeDamage(damage)
		if body.has_method("applyKnockback"):
			var knockDir = (body.global_position - global_position).normalized()
			body.applyKnockback(knockDir, 200.0)
	# pogo or recoil
	var player = get_tree().get_first_node_in_group("player")
	if player and player.downsmash:
		if body.has_method("takeDamage"):
			player.pogo(450.0)
		else:
			player.pogo()
	elif player:
		var recoilDir = (player.global_position - body.global_position).normalized()
		recoilDir.y = 0
		var tween = create_tween()
		tween.tween_property(player, "position", player.position + recoilDir * 15.0, 0.1)
