extends Control
@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value)

var uilife_scene = preload("res://scene/ui_life.tscn")
@onready var lives = $lives
func init_lives(amount):
	for ul in lives.get_children():
		ul.queue_free()
	for i in amount:
		var ul = uilife_scene.instantiate()
		lives.add_child(ul)
