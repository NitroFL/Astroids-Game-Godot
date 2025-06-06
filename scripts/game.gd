extends Node2D
signal exploded

@onready var lasers = $Lasers
@onready var player = $Player
@onready var astroids = $Astroids
@onready var hud = $UI/HUD
@onready var player_spawn_pos = $PlayerSpawnpos
@onready var game_over_screen = $UI/GameOverScreen
@onready var player_spawn_area = $PlayerSpawnpos/PlayerSpawnArea

var asteroid_scene = preload("res://scene/astroid.tscn") 
var score := 0:
	set(value):
		score = value
		hud.score = score

var lives: int:
	set(value):
		lives = value
		hud.init_lives(lives)

func _ready() -> void:
	game_over_screen.visible = false
	score = 0
	lives = 3
	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)
	
	for astroid in astroids.get_children():
		if astroid.has_signal("exploded"):
			astroid.connect("exploded", _on_asteroid_exploded)

func _on_player_laser_shot(laser):
	$LaserSound.play()
	lasers.add_child(laser)

func _on_asteroid_exploded(pos,size,points):
	$AstroidHitsound.play()
	score += points
	for i in range(2):
		match size:
			Asteroids.AstroidSize.LARGE:
				spawn_asteroid(pos,Asteroids.AstroidSize.MEDIUM)
			Asteroids.AstroidSize.MEDIUM:
				spawn_asteroid(pos,Asteroids.AstroidSize.SMALL)
			Asteroids.AstroidSize.SMALL:
				pass

func spawn_asteroid(pos, size):
	var a = asteroid_scene.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("exploded",_on_asteroid_exploded)
	astroids.call_deferred("add_child", a)

func _on_player_died() -> void:
	$PlayerDieSound.play()
	lives -= 1
	if lives <= 0:
		player.global_position = player_spawn_pos.global_position
		await get_tree().create_timer(2).timeout
		game_over_screen.visible = true
	else:
		await get_tree().create_timer(1).timeout
		while !player_spawn_area.is_empty:
			await get_tree().create_timer(0.5).timeout
		player.respawn(player_spawn_pos.global_position)
