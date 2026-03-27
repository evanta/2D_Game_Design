extends Control
@onready var start_game: Button = $VBoxContainer/StartGame
@onready var weapon_container: HBoxContainer = $VBoxContainer/WeaponContainer
@onready var show_gauntlets_levels: Button = $VBoxContainer/WeaponContainer/GauntletsLevelsContainer/ShowGauntletsLevels
@onready var gauntlets_levels: VBoxContainer = $VBoxContainer/WeaponContainer/GauntletsLevelsContainer/GauntletsLevels
@onready var show_sword_levels: Button = $VBoxContainer/WeaponContainer/SwordLevelsContainer/ShowSwordLevels
@onready var sword_levels: VBoxContainer = $VBoxContainer/WeaponContainer/SwordLevelsContainer/SwordLevels
@onready var show_bow_levels: Button = $VBoxContainer/WeaponContainer/BowLevelsContainer/ShowBowLevels
@onready var bow_levels: VBoxContainer = $VBoxContainer/WeaponContainer/BowLevelsContainer/BowLevels
@onready var quitbutton: Button = $VBoxContainer/Button
@onready var quit_label: Label = $VBoxContainer/Button/HBoxContainer/QuitLabel

var messages = ["Are you sure?", "YOUR PROGRESS WONT SAVE WE DONT SAVE TO DISC!", "Coward!", "Just play the game.", "Do you really wanna replay everything that you have done?", "Dropouttttt", "Just give up on this", "I wont let you quit", "Take no for an answer!", "Its for your own good!, I just want you to learn", "*yawn", "you could have played a whole level by now", "IT WONT WORK STOP PRESSING ME", "AHHHHHHHH"]
var messageIndex = 0

var weaponLevelContainers : Dictionary = {}

func _ready():
	weapon_container.visible = false
	hideAllLevels()
	
	start_game.pressed.connect(_on_start_game_pressed)
	show_sword_levels.pressed.connect(_on_show_sword_levels_pressed)
	show_bow_levels.pressed.connect(_on_show_bow_levels_pressed)
	show_gauntlets_levels.pressed.connect(_on_show_gauntlets_levels_pressed)
	quitbutton.pressed.connect(onQuitPressed)
	weaponLevelContainers = {
		"Sword": sword_levels,
		"Bow": bow_levels,
		"Gauntlets": gauntlets_levels,
	}
	
	setupLevelButtons()

func setupLevelButtons() -> void:
	for weapon : String in weaponLevelContainers:
		var container : VBoxContainer = weaponLevelContainers[weapon]
		var levels : Array = SceneManager.levelPaths[weapon]
		var buttons : Array = container.get_children()
		
		for i : int in range(mini(buttons.size(), levels.size())):
			var button : Button = buttons[i]
			var levelPath : String = levels[i]
			
			button.disabled = not SceneManager.isLevelUnlocked(levelPath)
			
			if button.pressed.is_connected(_onLevelSelected):
				button.pressed.disconnect(_onLevelSelected)
			button.pressed.connect(_onLevelSelected.bind(levelPath))
		
		# Disable any extra buttons that don't have a level path yet
		for i : int in range(levels.size(), buttons.size()):
			buttons[i].disabled = true

func _onLevelSelected(levelPath : String) -> void:
	ScoreManager.resetLevel()
	get_tree().change_scene_to_file(levelPath)


func _on_start_game_pressed():
	weapon_container.visible = !weapon_container.visible
	if not weapon_container.visible:
		hideAllLevels()

func hideAllLevels():
	sword_levels.visible = false
	bow_levels.visible = false
	gauntlets_levels.visible = false

func _on_show_sword_levels_pressed():
	var wasOpen = sword_levels.visible
	hideAllLevels()
	sword_levels.visible = !wasOpen

func _on_show_bow_levels_pressed():
	var wasOpen = bow_levels.visible
	hideAllLevels()
	bow_levels.visible = !wasOpen

func _on_show_gauntlets_levels_pressed():
	var wasOpen = gauntlets_levels.visible
	hideAllLevels()
	gauntlets_levels.visible = !wasOpen

func onQuitPressed():
	quit_label.text = messages[messageIndex]
	messageIndex = (messageIndex + 1) % messages.size()
