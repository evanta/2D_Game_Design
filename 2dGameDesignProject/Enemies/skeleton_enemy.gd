extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 300.0
@export var health: float = 100.0
@export var speed: float = 50.0
@export var gravity: float = 900.0
@export var damage : float = 20.0
var direction = 1
# walking cycle variables
@export var max_walk_distance = 50
var start = 0
var traveled_distance = 0
@onready var headshot: Area2D = $Headshot
var knockbackVelocity = Vector2.ZERO
@onready var hitbox: Area2D = %Hitbox
@onready var headshot_label: RichTextLabel = $HeadshotLabel
var startingLabelPos : Vector2
var collisionBoxes : Array = [ $PhysicsCollision, $Hitbox/HitboxShape, $Headshot/HeadshotShape]
@onready var physics_collision: CollisionShape2D = $PhysicsCollision

func _ready():
	headshot_label.visible = false
	startingLabelPos = headshot_label.position
	add_to_group("enemy")
	hitbox.body_entered.connect(onBodyEntered)

func onBodyEntered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(damage)

func _physics_process(delta: float) -> void:
	anim.play("Walking")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = speed * direction + knockbackVelocity.x
	move_and_slide()
	
	# decay knockback over time
	knockbackVelocity = knockbackVelocity.move_toward(Vector2.ZERO, 500 * delta)
	
	traveled_distance += abs(speed * direction * delta)
	
	if traveled_distance >= max_walk_distance:
		direction *= -1
		traveled_distance = 0
		anim.flip_h = direction == -1

func applyKnockback(dir: Vector2, force: float):
	knockbackVelocity = dir.normalized() * force

func takeDamage(amount: float):
	health -= amount
	print("Enemy took ", amount, " damage! Health: ", health)
	flashRed()
	if health <= 0:
		physics_collision.set_deferred("disabled", true)
		die()

func onStyleKill(label: String = "STYLE KILL!"):
	set_physics_process(false)
	for shape in collisionBoxes:
		if shape is CollisionShape2D:
			shape.disabled = true
	headshot_label.text = "[center]" + label + "[/center]"
	headshot_label.position = startingLabelPos
	headshot_label.modulate.a = 1.0
	headshot_label.visible = true
	
	var tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(headshot_label, ^"position", startingLabelPos + Vector2(2.0, -4.0), 0.5)
	tween.tween_property(headshot_label, ^"modulate:a", 0.0, 0.5)
	flashRed()
	flashRed()
	tween.finished.connect(func():
		headshot_label.visible = false
		ScoreManager.styleKills += 1
		die())

func flashRed():
	modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	modulate = Color.WHITE

func die():
	anim.play("Death")
	
	# Make it stop walking
	set_physics_process(false)
	
	# Disable collisions
	$Hitbox/HitboxShape.set_deferred("disabled", true)
	$Headshot/HeadshotShape.set_deferred("disabled", true)
	
	# Remove it from the level
	await anim.animation_finished
	queue_free()
	ScoreManager.registerKill()
