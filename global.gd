extends Node

#Gonna write some junk here so that Hackatime Tracks something
#Today is 5:17 PM 10/17/2023 (and I realize that time is not part of a day, but I don't care) (Go eat rocks)

#anywayyyyyyy

var dev_mode = false

var time := 0.0
var time_string := ''

#bleh remembering UI elements
#this is the wrong way to do it... but hey
var timer_visible = false
var muted = false

var checkpoint_pos = Vector2(0,0) #0 is the start, 1,2,3 and so on are real checkkpoints

@onready var Player = get_tree().get_nodes_in_group("Player")[0]


func _ready() -> void:
	check_checkpoint()

func check_checkpoint() -> bool:
	if checkpoint_pos == Vector2(0,0):
		return false
	else:
		call_deferred("set_pos")
		return true


func set_pos():
	Player = get_tree().get_nodes_in_group("Player")[0]
	Player.global_position = checkpoint_pos

	#... fixes a music problem, I know this is a terrible way to do it, bleh...
	# Fail fast, fail often. Just trying to get a game out and working

	var CameraHold = get_tree().get_nodes_in_group("Player")[1]
	CameraHold.get_node("StartCamera").enabled = false
	
	#Ignore this warning, forgot the code for it
	var UI = get_tree().get_nodes_in_group("UI")[0]
	UI.started.emit()

func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("retry"):

		Player.is_dead = true
