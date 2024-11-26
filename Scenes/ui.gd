extends CanvasLayer

var life_texture = preload("res://Assets/Player/Player.png")

signal game_over

@onready var lifes_ui_container = $MarginContainer/HBoxContainer

@onready var center_container = %CenterContainer
@onready var center_container_2: CenterContainer = %CenterContainer2

@onready var points_label = $MarginContainer/Points
@onready var points_counter = $"../PointsCounter" as PointsCounter
@onready var label = $MarginContainer/CenterContainer/GameOverBox/Label
@onready var restart_button: Button = $MarginContainer/CenterContainer/GameOverBox/Restart
@onready var submit_score: Button = $"MarginContainer/CenterContainer2/Score Submit Box/SubmitScore"
@onready var text_edit: TextEdit = $"MarginContainer/CenterContainer2/Score Submit Box/TextEdit"
@onready var score_submission_screen: Button = $MarginContainer/CenterContainer/GameOverBox/ScoreSubmissionScreen

@export var invader_spawner: InvaderSpawner
@onready var ufo_spawner: Node2D = $"../UfoSpawner"

@export var life_manager: LifeManager
var timescore = 0
var lifescore = 150

var playername = ""

func _ready():
	points_label.text = "SCORE: %d" % 0
	points_counter.on_points_increased.connect(points_increased)
	invader_spawner.game_lost.connect(on_game_lost)
	invader_spawner.game_won.connect(on_game_won)
	restart_button.pressed.connect(on_restart_button_press)
	submit_score.pressed.connect(_on_submit_score_pressed)
	score_submission_screen.pressed.connect(_on_score_submission_screen_pressed)
	life_manager.on_life_lost.connect(on_life_lost)
	
	var lifes_count = life_manager.lifes
	lifescore = lifes_count * 50
	
	for i in range(lifes_count):
		var life_texture_rect = TextureRect.new()
		life_texture_rect.expand_mode = true
		life_texture_rect.custom_minimum_size = Vector2(40, 25)
		life_texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		life_texture_rect.texture = life_texture
		lifes_ui_container.add_child(life_texture_rect)
	

func points_increased(points: int):
	points_label.text = "SCORE: %d" % points
	
func on_game_lost():
	center_container.visible = true
	Globals.player_alive = false
	timescore = 0
	emit_signal("game_over")
	

	
func on_game_won():
	label.text = "You won!"
	label.add_theme_color_override("font_color", Color.GREEN)
	center_container.visible = true
	Globals.player_alive = false
	timescore = Globals.time_bonus
	emit_signal("game_over")


func on_restart_button_press():
	get_tree().reload_current_scene()
	
func _on_submit_score_pressed(): #submits score and returns to main menu
	if(text_edit.text != ""):
		playername = text_edit.text
		SilentWolf.Scores.save_score(playername,Globals.score + timescore)
		get_tree().change_scene_to_file("res://Addons/silent_wolf/Scores/Leaderboard.tscn")
		
func _on_score_submission_screen_pressed(): #Makes the restart/submit screen invisible and displays the submit score screen
	center_container.visible = false
	center_container_2.visible = true
	


func on_life_lost(lifes_left:int):
	print_debug(lifes_left)
	lifescore = lifes_left * 50
	if lifes_left != 0:
		var life_texture_rect: TextureRect =  lifes_ui_container.get_child(lifes_left)
		life_texture_rect.queue_free()
	else:
		on_game_lost()

	
