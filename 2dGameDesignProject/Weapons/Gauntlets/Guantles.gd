class_name Gauntlets
extends WeaponClass

@export var hitbox_scene : PackedScene
var baseRange : float
var isLeftPunch : bool = true
@onready var left_gloves: Sprite2D = %LeftGloves
@onready var right_gloves: Sprite2D = %RightGloves
func _ready():
	baseRange = attackRange


func performAttack():
	if character == null:
		return
	var hitbox = hitbox_scene.instantiate()
	isLeftPunch = !isLeftPunch
	add_child(hitbox)
	var knockForce = character.gauntletKnockbackForce
	hitbox.setup(damage, baseRange, attackRange, isLeftPunch, knockForce)
	left_gloves.visible = false
	right_gloves.visible = false
	await get_tree().create_timer(attackSpeed).timeout
	left_gloves.visible = true
	right_gloves.visible = true
	$AudioStreamPlayer2D.play()
