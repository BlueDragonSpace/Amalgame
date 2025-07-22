class_name Enemy
extends RigidBody2D

@export var HP: int = 40
@export var HP_offset = [-7, 10]
@export var Armor: int = 5 #minimum amount of velocity needed to get damaged

@onready var Player = get_tree().get_nodes_in_group("Player")[0]
var notif = preload("res://UI/damage_bubble.tscn")

var invincibility_timer = 0.0

func _ready() -> void:
	HP += randi_range(HP_offset[0],HP_offset[1]) #random hp offset

func _physics_process(_delta: float) -> void:

	var dir = position - get_global_mouse_position()

	if Input.is_action_just_pressed("debug2"):
		apply_central_impulse(-dir)

func take_hit(damage: int):

	var notif_bubble = notif.instantiate()
	notif_bubble.position = global_position

	if damage > Armor:
		HP -= damage
		notif_bubble.text = str(damage)
		notif_bubble.self_modulate = Color.GOLD
	else:
		notif_bubble.text = str(damage)
		notif_bubble.self_modulate = Color.RED
	

	Player.get_node("Notif").add_child(notif_bubble)