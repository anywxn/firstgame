extends Node2D

@onready var pointlight = $Shop/PointLight2D
@onready var pointlight2 = $Shop/PointLight2D2
@onready var light = $DirectionalLight2D
@onready var day_text = $CanvasLayer/Days
@onready var animPlayer = $CanvasLayer/AnimationPlayer
@onready var HealthBar = $CanvasLayer/HealthBar
@onready var player = $Player/Player

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT,
}

var state = MORNING
var daycount: int #счетчик дней

func _ready():
	HealthBar.max_value = player.MaxHealth
	HealthBar.value = HealthBar.max_value
	light.enabled = true
	daycount = 1
	setdays()
	day_text_fade()

func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light,"energy", 0.1, 10)#светлеет день
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointlight,"energy", 0, 20)#светлеет магаз свет
	var tween2 = get_tree().create_tween()
	tween2.tween_property(pointlight2,"energy", 0, 20)#светлеет магаз свет
func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light,"energy", 0.95, 10)#Темнеет ночь
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointlight,"energy", 1.5, 20)#Темнеет магаз свет
	var tween2 = get_tree().create_tween()
	tween2.tween_property(pointlight2,"energy", 1.5, 20)#Темнеет магаз свет
func _on_day_night_timeout():
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()
	if state < 3:
		state += 1
	else:
		state = MORNING
		daycount += 1
		setdays()
		day_text_fade()

func day_text_fade():
	animPlayer.play("days")
	await get_tree().create_timer(3).timeout
	animPlayer.play("daysvisibility")

func setdays():
	day_text.text = "DAY: " + str(daycount)


func _on_player_health_changed(new_health):
	HealthBar.value = new_health
