class_name Sword
extends WeaponClass

@export var hitbox_scene : PackedScene
@export var hitbox_duration : float = 0.2
var baseRange
@onready var sword_pixel_art_radin: Sprite2D = $SwordPixelArtRadin
var isAttacking : bool = false
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
