extends Node2D

@onready var Player: RigidBody2D = $testingPlayer
#@onready var AXE: RigidBody2D = $testingPlayer/axe
var AXE = 0
@onready var PewPew: Node2D = $testingPlayer/PewPew

@export var has_axe = false

@export var STR: float = 75.0 #how powerfully you can swing your weapon
@export var MAX_SWING : float = 25.0 #how fast you can swing at max 

func _process(delta: float) -> void:

	#changes rotation to point at mouse
	#however, this isn't good with the physics simulation
	#weapon_hold.rotation = position.angle_to_point(get_global_mouse_position())
	if has_axe:
		if Input.is_action_pressed("left"):
			AXE.angular_velocity -= STR  * delta
		elif Input.is_action_pressed("right"):
			AXE.angular_velocity += STR * delta
		else:
			AXE.angular_velocity = move_toward(AXE.angular_velocity, 0, 105.0 * delta)

		AXE.angular_velocity = clamp(AXE.angular_velocity, -MAX_SWING, MAX_SWING)
