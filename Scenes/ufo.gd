extends Area2D

class_name Ufo

signal on_ufo_destroyed(points: int)

@export var speed = 200
@onready var sprite = $Sprite2D
@onready var shooting_point = $ShootingPoint 
var explosion_texture = preload("res://Assets/Ufo/Ufo-explosion.png")
@onready var points_counter: PointsCounter = $PointsCounter

func _process(delta):
	position.x -= delta * speed


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area is Laser:
		if is_instance_valid(shooting_point):
			shooting_point.queue_free()
		speed = 0
		sprite.texture = explosion_texture
		ufo_destroyed()
		await get_tree().create_timer(1.5).timeout
		queue_free()

func ufo_destroyed():
	on_ufo_destroyed.emit(100)
