extends Node2D

@export var KICKBACK = 10.0 #how far sling knocks back

@onready var Player = get_tree().get_nodes_in_group("Player")[0]

func _process(_delta: float) -> void:

	var dir = global_position - Player.global_position
	dir.normalized()

	if Input.is_action_just_pressed("weapon_use"):
		dir.y *= 2 #gravity is funky
		Player.apply_central_impulse(-dir * KICKBACK)
