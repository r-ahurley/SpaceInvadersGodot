extends Area2D

class_name Laser

@export var speed = 500
const SI_PLAYER_SHOOT = preload("res://Assets/Audio/SI_Player_Shoot.wav")

func _ready():
	$AudioStreamPlayer2D.stream = SI_PLAYER_SHOOT
	$AudioStreamPlayer2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= delta * speed
