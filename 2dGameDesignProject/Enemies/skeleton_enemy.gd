extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0

@export var health: float = 100.0
@export var speed: float = 50.0
@export var gravity: float = 900.0
@export var damage : float = 20.0



var direction = 1

# walking cycle variables
var max_walk_distance = 50 
var start = 0 
var traveled_distance = 0

var knockbackVelocity = Vector2.ZERO
@onready var hitbox: Area2D = %Hitbox

func _ready():
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
		die()

func flashRed():
	modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	modulate = Color.WHITE

func die():
	queue_free()  # or play a death animation first
