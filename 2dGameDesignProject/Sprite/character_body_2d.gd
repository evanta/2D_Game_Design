class_name Player
extends CharacterBody2D

@onready var weaponSlot: Node2D = %WeaponSlot
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var currentHealth: float = 100.0
@export var maxHealth: float = 100.0
@export var speed: float = 200.0
@export var gravity: float = 900.0
@export var jumpForce: float = 100.0

var lastSafePosition: Vector2 = Vector2.ZERO
var safePositionTimer: float = 0.0
var slotOffset = 45.0


func _ready() -> void:
	add_to_group("player")
	lastSafePosition = global_position

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jumpForce

	# Horizontal movement
	var dir := 0
	if Input.is_action_pressed("moveRight"):
		dir = 1
	elif Input.is_action_pressed("moveLeft"):
		dir = -1

	velocity.x = dir * speed

	# Animation
	if dir != 0:
		anim.flip_h = (dir < 0)
		if anim.animation != "run":
			anim.play("run")
	else:
		if anim.animation != "idle":
			anim.play("idle")

	if dir != 0:
		anim.flip_h = (dir < 0)
		weaponSlot.scale.x = dir
		weaponSlot.position.x = slotOffset * dir
		
	if is_on_floor():
		safePositionTimer += delta
		if safePositionTimer >= 2.0:
			lastSafePosition = global_position
			safePositionTimer = 0.0
	move_and_slide()

func equipWeapon(weaponScene: PackedScene):
	print("equipWeapon called with: ", weaponScene)
	for child in weaponSlot.get_children():
		child.queue_free()
	
	var weapon = weaponScene.instantiate()
	print("weapon instantiated: ", weapon)
	weaponSlot.add_child(weapon)
	print("weapon added to slot, calling setup")
	weapon.setup(self)


func takeDamage(amount: float):
	currentHealth -= amount
	if currentHealth <= 0:
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(self, ^"self_modulate", Color.DARK_RED, 1.0 )
		tween.tween_property(self, ^"modulate", 0.5, 1.0)
		tween.finished.connect(die)
func die():
	get_tree().reload_current_scene()

func fallRespawn():
	takeDamage(25.0)
	global_position = lastSafePosition
	velocity = Vector2.ZERO
