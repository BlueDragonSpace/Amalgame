class_name Enemy
extends RigidBody2D

signal died
@export var HP: int = 40:
	set(new_HP):
		HP = new_HP
		if HP <= 0:
			died.emit()
			death()
@export var HP_offset = [-7, 10]
@export var Armor: int = 5 #minimum amount of velocity needed to get damaged

@onready var Player = get_tree().get_nodes_in_group("Player")[0]
var notif = preload("res://UI/damage_bubble.tscn")

func _ready() -> void:
	HP += randi_range(HP_offset[0],HP_offset[1]) #random hp offset

func _physics_process(_delta: float) -> void:

	var dir = position - get_global_mouse_position()

	if Input.is_action_just_pressed("debug2"):
		apply_central_impulse(-dir)

func take_hit(damage: int, body: Node):

	#KNOCKBACK
	var dir = global_position - body.global_position
	dir = dir.normalized()

	dir.y += -0.125 #adds a little upwards motion
	
	apply_central_impulse(dir * damage * 100)

	var notif_bubble = notif.instantiate()
	notif_bubble.position = global_position

	if damage > Armor:
		HP -= damage
		notif_bubble.text = str(damage)
		notif_bubble.self_modulate = Color.WHITE
	else:
		notif_bubble.text = str(damage)
		notif_bubble.self_modulate = Color.RED
	

	Player.get_node("Notif").add_child(notif_bubble)

func death() -> void:
	queue_free()

func find_x_direction(Point: Node2D) -> int:
	var dir = global_position.x - Point.global_position.x

	if dir < 0:
		return 1
	else:
		return -1
