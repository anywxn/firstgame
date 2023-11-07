extends Node2D

var enemy = preload("res://Mobs/skeleton.tscn")
var ring = preload("res://items/ring.tscn")

func _on_timer_timeout():
	var enemytemp = enemy.instantiate()
	var ringtemp = ring.instantiate() 
	var rng = RandomNumberGenerator.new()
	var randint = randi_range(50, 1100)
	var randenemy = randi_range(50, 1100)
	enemytemp.position = Vector2(randenemy,400)
	ringtemp.position = Vector2(randint,485)
	add_child(ringtemp)
	add_child(enemytemp)
