extends Area2D
class_name Player

@export var speed = 200

signal player_destroyed

var direction = Vector2.ZERO
@onready var collision_rect: CollisionShape2D = $CollisionShape2D
@onready var  animation_player = $AnimationPlayer
@onready var midi_control: MidiControl = $"../MIDI Control"
@onready var shot_origin: Node2D = $ShotOrigin

@export var laser_scene:PackedScene


var bounding_size_x 
var start_bound
var end_bound

var midi_used = false

var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	midi_control.connect("note_pressed", _on_note_pressed)
	midi_control.connect("note_released", _on_note_released)
	bounding_size_x = collision_rect.shape.get_rect().size.x / 2
	var rect = get_viewport().get_visible_rect()
	var camera = get_viewport().get_camera_2d()
	var camera_position = camera.position
	start_bound = (camera_position.x - rect.size.x) / 2
	end_bound =  (camera_position.x + rect.size.x) / 2
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var screen_bounding_box = get_viewport_rect().end.x
	var input = Input.get_axis("move_left", "move_right")
	if input > 0:
		direction = Vector2.RIGHT
		midi_used = false
	elif  input < 0:
		direction = Vector2.LEFT
		midi_used = false
	elif !midi_used:
		direction = Vector2.ZERO
	
	
	var deltaMovement = speed * delta * direction.x
	# limit the movement to the screen
#	bounding_size_x * transform.get_scale().x
	if position.x + deltaMovement < start_bound + bounding_size_x * transform.get_scale().x  || position.x + deltaMovement > end_bound - bounding_size_x * transform.get_scale().x: 
		return
	position.x += deltaMovement

func _on_note_pressed(played_note: String):
	if played_note == "F":
		direction = Vector2.LEFT
		midi_used = true
	if played_note == "G" && can_shoot:
		can_shoot = false
		var laser = laser_scene.instantiate() as Area2D
		laser.global_position = shot_origin.global_position - Vector2(0, 20)
		get_tree().root.get_node("main").add_child(laser)
		laser.tree_exited.connect(on_laser_destroyed)
	if played_note == "A":
		direction = Vector2.RIGHT
		midi_used = true

func _on_note_released(played_note: String):
	if played_note == "F" || played_note == "A":
		direction = Vector2.ZERO

func on_laser_destroyed():
	can_shoot = true
		
	
	
	
	
func on_player_destroyed():
	speed = 0
	animation_player.play("destroy")
	


func _on_animation_player_animation_finished(anim_name):
	# TODO: lose life
	
	if anim_name == "destroy":
		await get_tree().create_timer(1).timeout
		player_destroyed.emit()
		queue_free()
