extends CharacterBody2D

@onready var weaponSlot: Node2D = %WeaponSlot
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var health: float = 100.0
@export var speed: float = 200.0
@export var gravity: float = 900.0
@export var jumpForce: float = 200.0


var slotOffset = 45.0


func _ready() -> void:
	add_to_group("player")
func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jumpForce

	# Horizontal movement
	var dir := 0
	if Input.is_action_pressed("ui_right"):
		dir = 1
	elif Input.is_action_pressed("ui_left"):
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
