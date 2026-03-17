class_name WeaponClass
extends Node2D

## what i was thinking here is that these variables are universal across all weapon types. that means if we want upgrades 
## or perks in a run, we can make items that work for any weapons, like increasing attack speed wont
## break with a wepaon type 

@export_range(0.0, 10.0, 0.1) var damage : float = 0.0
@export_range(0.01, 2.0, 0.01) var attackSpeed : float = 1.5 ##the duration between attacks. Smaller = faster attacks, slower = longer reload time
@export_range(1.0, 100.0, 0.5) var attackRange : float = 1.0 ##for melee weapons, keep this shorter, for projectiles crank it 

var canAttack : bool = true
var character = null

func attack():
	if canAttack == false:
		return
	performAttack()
	setAttackStatus()

func setup(char):
	character = char

func setAttackStatus (): 
	## reate a timer, using the attackSpeed varaibale as the duration,
	## on that timers end (timeout) make can attack = true. this is why attackspeed at higher values makes attack speed slower
	canAttack = false
	await get_tree().create_timer(attackSpeed).timeout
	canAttack = true


func performAttack ():
	pass
	## individual weapons will controll have unique attack logic 

## this is just to test if it works 
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()
