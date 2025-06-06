class_name Asteroids extends Area2D

signal exploded(pos,size,points)

var movement_vector := Vector2(0,-1)
var speed := 50.0

enum AstroidSize{LARGE,MEDIUM,SMALL}

@export var size = AstroidSize.LARGE

@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D

var points: int:
	get:
		match size:
			AstroidSize.LARGE:
				return 100
			AstroidSize.MEDIUM:
				return 50
			AstroidSize.SMALL:
				return 25
			_:
				return 0 

func _ready() -> void:
	rotation = randf_range(0,2*PI)
	match size:
		AstroidSize.LARGE:
			speed = randf_range(150,200)
			sprite.texture = preload("res://Textures/BigAstroid.png")
			cshape.set_deferred("shape", preload("res://scene/resources/astroid_cs_large.tres"))
		AstroidSize.MEDIUM:
			speed = randf_range(150,200)
			sprite.texture = preload("res://Textures/BigAstroid.png")
			cshape.set_deferred("shape", preload("res://scene/resources/astroid_cs_large.tres"))
		AstroidSize.SMALL:
			speed = randf_range(150,200)
			sprite.texture = preload("res://Textures/mediumAstroid.png")
			cshape.set_deferred("shape", preload("res://scene/resources/astroid_cs_medium.tres"))


func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * speed * delta
	var radius = cshape.shape.radius
	var screen_size = get_viewport_rect().size
	if (global_position.y+radius) < 0:
		global_position.y = (screen_size.y+radius)
	elif (global_position.y-radius) > screen_size.y:
		global_position.y = -radius
	if (global_position.x+radius) < 0:
		global_position.x = (screen_size.x+radius)
	elif (global_position.x-radius) > screen_size.x:
		global_position.x = -radius
func explode():
	emit_signal("exploded", global_position, size, points)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("Collision detected with:", body.name)
	if body is Player:
		print("It is the Player")
		body.die()
