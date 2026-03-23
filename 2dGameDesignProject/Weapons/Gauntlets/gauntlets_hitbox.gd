extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var capow: Sprite2D = $Capow

@onready var left_sprite: Sprite2D = %LeftSprite
@onready var right_sprite: Sprite2D = %RightSprite

var damage : float = 0.0

func setup(dmg : float, base_range : float, current_range : float, isLeft : bool):
	damage = dmg
	var collision_shape = $CollisionShape2D
	if current_range > base_range:
		var scale_factor = current_range / base_range
		collision_shape.shape.size.x += scale_factor
		collision_shape.shape.size.y += scale_factor
	if isLeft:
		$LeftSprite.visible = true
		$RightSprite.visible = false
	else:
		$LeftSprite.visible = false
		$RightSprite.visible = true

func _ready():
	body_entered.connect(onBodyEntered)
	await get_tree().create_timer(0.15).timeout
	queue_free()

func onBodyEntered(body):
	if body is Player:
		return 
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
	if body.has_method("applyKnockback"):
		var knockDir = (body.global_position - global_position).normalized()
		body.applyKnockback(knockDir, 550.0)
