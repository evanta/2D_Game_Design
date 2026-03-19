extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0

@export var health: float = 100.0
@export var speed: float = 50.0
@export var gravity: float = 900.0
@export var jumpForce: float = 200.0 

var direction = 1

# walking cycle variables
var max_walk_distance = 50 
var start = 0 
var traveled_distance = 0



func _physics_process(delta: float) -> void:
	
	anim.play("Walking")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = speed * direction
	move_and_slide()
	
	traveled_distance += abs(velocity.x * delta)
	
	if traveled_distance >= max_walk_distance:
		direction *= -1
		traveled_distance = 0
		anim.flip_h = direction == -1
	
	
		
	
	
	
	
	
	

	
	
	
