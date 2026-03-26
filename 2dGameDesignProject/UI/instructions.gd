extends CanvasLayer

enum Weapon { SWORD, BOW, GAUNTLETS }

@export var currentWeapon: Weapon = Weapon.SWORD
@onready var instructionLabel: Label = $Control/VBoxContainer/InstructionsLabel
@onready var control: Control = $Control

var instructions: Dictionary = {
	Weapon.SWORD: "Press ENTER/SPACE to swing your sword\nPress DOWN while airborne to pogo",
	Weapon.BOW: "Press ENTER/SPACE to  fire arrows\nHeadshots are instant kills!",
	Weapon.GAUNTLETS: "Press ENTER/SPACE to punch\n Gauntlets knock enemies back",
}

func _ready():
	instructionLabel.text = instructions[currentWeapon]
	control.modulate.a = 1.0
	await get_tree().create_timer(5.0).timeout
	var tween = create_tween()
	tween.tween_property(control, "modulate:a", 0.0, 1.0)
	tween.tween_callback(queue_free)
