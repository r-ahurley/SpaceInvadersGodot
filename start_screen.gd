extends CanvasLayer

signal release_toggled(toggle)

@onready var invader_1_texture = %Invader1Texture
@onready var invader_1_label = %Invader1Label
@onready var invader_2_texture = %Invader2Texture
@onready var invader_2_label = %Invader2Label
@onready var invader_3_texture = %Invader3Texture
@onready var invader_3_label = %Invader3Label

@onready var timer = $Timer

@onready var Menu: MarginContainer = $MarginContainer
@onready var SettingsMenu: Panel = $Panel
@onready var Title: Label = $Label
@onready var help_panel: Panel = $HelpPanel

var node_array = []

func _ready():
	Configure_Si_wolf()
	configure_scores()
	node_array.append(invader_1_texture)
	node_array.append(invader_1_label)
	node_array.append(invader_2_texture)
	node_array.append(invader_2_label)
	node_array.append(invader_3_texture)
	node_array.append(invader_3_label)
	for element in node_array:
		(element as Control).modulate = Color.TRANSPARENT
	timer.timeout.connect(on_timer_timeout)
	

func on_timer_timeout():
	var node =  node_array.pop_front() as Control
	if node != null:
		node.modulate = Color.GHOST_WHITE
	else:
		timer.stop()
		timer.queue_free()
	
func Configure_Si_wolf():
	SilentWolf.configure({
		"api_key": "ewRnPDG0kN3wXLlgdp6RYCYtAl6Da9jaTsbWVSAd",
		"game_id": "spaceinvaders2",
		"log_level": 1
	})

func configure_scores():
	SilentWolf.configure_scores({
	"open_scene_on_close": "res://start_screen.tscn"
})

func load_game():
	Globals.score = 0
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func open_settings():
	Menu.hide()
	Title.hide()
	SettingsMenu.show()
	
func close_settings():
	SettingsMenu.hide()
	Title.show()
	Menu.show()
	
func open_Help():
	Menu.hide()
	Title.hide()
	help_panel.show()
	
func close_Help():
	help_panel.hide()
	Title.show()
	Menu.show()
	
func load_leaderboard():
	#get_tree().change_scene_to_file("res://Scenes/ReverseLeaderboard.tscn")
	get_tree().change_scene_to_file("res://Addons/silent_wolf/Scores/Leaderboard.tscn")
	
func quit_game():
	get_tree().quit()
	
	


func _on_check_button_toggled(toggled_on: bool) -> void:
	Globals.toggled = toggled_on
