extends Area2D

enum WeaponType { SWORD, BOW, GAUNTLETS }

@export var weaponType: WeaponType = WeaponType.SWORD

var weaponScenes = {
	WeaponType.SWORD: preload("res://Weapons/Sword/Sword.tscn"),
	WeaponType.BOW: preload("res://Weapons/Bow/Bow.tscn"),
	WeaponType.GAUNTLETS: preload("res://Weapons/Gauntlets/Gauntlets.tscn"),
}

var weaponScene: PackedScene

var playerInRange = false
var prompt: Label

func _ready():
	weaponScene = weaponScenes[weaponType]
	prompt = Label.new()
	prompt.text = "E to pick up"
	prompt.visible = false
	
	# Position it above the pickup
	prompt.position = Vector2(-40, -60)
	
	# Font size
	prompt.add_theme_font_size_override("font_size", 14)
	
	# Optional: add an outline so it's readable on any background
	prompt.add_theme_color_override("font_outline_color", Color.BLACK)
	prompt.add_theme_constant_override("outline_size", 4)
	
	add_child(prompt)
	
	# Spawn the weapon display
	if weaponScene:
		var display = weaponScene.instantiate()
		display.set_process(false)
		display.set_physics_process(false)
		add_child(display)
	print("Prompt created: ", prompt)
	print("Prompt visible: ", prompt.visible)
	print("Prompt position: ", prompt.position)
	print("Prompt in tree: ", prompt.is_inside_tree())

func _on_body_exited(body):
	playerInRange = false
	prompt.visible = false

func _input(event):
	if event.is_action_pressed("interact") and playerInRange:
		var player = get_tree().get_first_node_in_group("player")
		print("player found: ", player)
		if player:
			player.equipWeapon(weaponScene)
			queue_free()


func _on_body_entered(body) -> void:
	print("body entered: ", body.name, " has method: ", body.has_method("equipWeapon"))
	if body.has_method("equipWeapon"):
		playerInRange = true
		prompt.visible = true
		print("prompt should now be visible: ", prompt.visible)
