class_name Player extends CharacterBody2D

signal laser_shot
signal died

@export var acceleration := 10.0
@export var max_speed := 350.0
@export var rotate_speed := 250.0

@onready var muzzle = $Muzzle
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D

var laser_scene = preload("res://scene/laser.tscn")
var shoot_cd = false
var rate_of_fire = 0.15
var alive := true

func _process(_delta):
	if !alive: return
	if Input.is_action_pressed("shoot") and !shoot_cd:
		shoot_cd = true
		shoot_laser()
		await get_tree().create_timer(rate_of_fire).timeout
		shoot_cd = false
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()

func _physics_process(delta):
	if !alive: return
	var input_vector = Vector2(0,Input.get_axis("move forward","move backward"))
	
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("rotate right"):
		rotate(deg_to_rad(rotate_speed*delta))
	if Input.is_action_pressed("rotate left"):
		rotate(deg_to_rad(-rotate_speed*delta))
	
	if input_vector == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	move_and_slide()
	
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0


func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	emit_signal("laser_shot", l)

func die():
	if alive == true:
		alive = false
		emit_signal("died")
		sprite.visible = false
		cshape.set_deferred("disabled",true)

func respawn(pos):
	if  alive==false:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		cshape.set_deferred("disabled",false)
