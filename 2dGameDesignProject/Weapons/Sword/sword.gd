class_name Sword
extends WeaponClass

@export var hitbox_scene : PackedScene
@export var hitbox_duration : float = 0.2
var baseRange
@onready var sword_pixel_art_radin: Sprite2D = $SwordPixelArtRadin
var isAttacking : bool = false
var isDownAttacking: bool = false

func _ready() -> void:
	baseRange = attackRange
	attackSpeed = 0.5
## remember, call the weapon classes attack function, which will then call this. 
func performAttack():
	var hitbox = hitbox_scene.instantiate()
	hitbox.setup(damage, baseRange, attackRange)
	# size the hitbox based on weapon_range
	# position it in front of the sword
	add_child(hitbox)
	$AudioStreamPlayer2D.play()



func startDownAttack():
	isDownAttacking = true
	var downHitbox = hitbox_scene.instantiate()
	downHitbox.persistent = true
	downHitbox.setup(damage, baseRange, attackRange)
	add_child(downHitbox)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(downHitbox, "rotation_degrees", 130, 0.2)
	tween.tween_callback(func():
		if is_instance_valid(downHitbox):
			downHitbox.queue_free()
		isDownAttacking = false
	)

func stopDownAttack():
	isDownAttacking = false
