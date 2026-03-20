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
	var hitbox = hitbox_scene.instantiate()
	isLeftPunch = !isLeftPunch
	add_child(hitbox)
	hitbox.setup(damage, baseRange, attackRange, isLeftPunch)
	left_gloves.visible = false
	right_gloves.visible = false
	await get_tree().create_timer(attackSpeed).timeout
	left_gloves.visible = true
	right_gloves.visible = true
	$AudioStreamPlayer2D.play()
