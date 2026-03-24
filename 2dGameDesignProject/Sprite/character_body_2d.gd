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
@onready var camera_2d: Camera2D = $Camera2D
@export var cameraZoom : float = 1.1

@export var isdead = false

@export var plainPogoForce: float = 200.0
@export var enemyPogoForce : float = 600.0
@export var gauntletKnockbackForce := 450.0

var downsmash = false
var is_rolling = false

func _ready() -> void:
	add_to_group("player")
	lastSafePosition = global_position
	camera_2d.zoom = Vector2(cameraZoom, cameraZoom)
	anim.animation_finished.connect(_on_animation_finished)  # ADD THIS


func _physics_process(delta):
	#check if the player is dead 
	if isdead == true: 
		return
	
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
		
	#down movement
	if Input.is_action_just_pressed("moveDown") and (velocity.y > -200 and velocity.y < 250)and not is_on_floor(): 
		velocity.y = jumpForce * 2 
		downsmash = true
		var weapon = weaponSlot.get_child(0)
		if weapon and weapon.has_method("startDownAttack"):
			weapon.startDownAttack()

	velocity.x = dir * speed

	# Animation
	if is_rolling:
		pass
	elif dir != 0:
		anim.flip_h = (dir < 0)
		if anim.animation != "run":
			anim.play("run")
	else:
		if anim.animation != "idle":
			anim.play("idle")
	
	if downsmash: 
		is_rolling = true
		anim.play("roll")

	if dir != 0:
		anim.flip_h = (dir < 0)
		weaponSlot.scale.x = dir
		weaponSlot.position.x = slotOffset * dir
		
	if is_on_floor():
		safePositionTimer += delta
		downsmash = false
		var weapon = weaponSlot.get_child(0)
		if weapon and weapon.has_method("stopDownAttack"):
			weapon.stopDownAttack()
		if safePositionTimer >= 2.0:
			lastSafePosition = global_position
			safePositionTimer = 0.0
	move_and_slide()

func _on_animation_finished():
	if anim.animation == "roll": 
		is_rolling = false
		anim.speed_scale = 1.0

func equipWeapon(weaponScene: PackedScene):
	print("equipWeapon called with: ", weaponScene)
	for child in weaponSlot.get_children():
		child.queue_free()
	
	var weapon = weaponScene.instantiate()
	print("weapon instantiated: ", weapon)
	weaponSlot.add_child(weapon)
	print("weapon added to slot, calling setup")
	weapon.setup(self)

func flashRed():
	if isdead:
		return
	modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	if not isdead: 
		modulate = Color.WHITE

func takeDamage(amount: float):
	if isdead: 
		return
	currentHealth -= amount
	flashRed()
	if currentHealth <= 0:
		isdead = true
		die()

func die():
	modulate = Color.WHITE
	anim.play("death")
	var tween = create_tween()
	tween.tween_property(self, ^"self_modulate", Color.DARK_RED, 0.3)
	var tree = get_tree()
	await anim.animation_finished
	ScoreManager.resetLevel()
	get_tree().reload_current_scene()
	
func pogo(force: float = -1.0):
	if force < 0:
		force = plainPogoForce
	velocity.y = -force
	downsmash = false
	is_rolling = true
	anim.speed_scale = 0.7
	anim.play("roll")
	var weapon = weaponSlot.get_child(0)
	if weapon and weapon.has_method("stopDownAttack"):
		weapon.stopDownAttack() 


func fallRespawn():
	takeDamage(25.0)
	global_position = lastSafePosition
	velocity = Vector2.ZERO
