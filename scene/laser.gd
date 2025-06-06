extends Area2D

@export var speed := 500.0

var movement_vector := Vector2(0,-1)

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Asteroids:
		var asteroids = area
		asteroids.explode()
		queue_free()
