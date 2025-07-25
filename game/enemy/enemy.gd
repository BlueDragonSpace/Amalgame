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

	#DAMAGE
	damage = abs(damage)

	#additional damage based on mass and speed of enemy colliding with weapon
	# say a 0.5 spring collided with axe at (300, 2200) velocity [forward, downward]
	# I want 300^2 + 2200^2 = c^2, c * .5, divide by 100 is the damage

	var added_damage = (linear_velocity.x * linear_velocity.x) \
	+ (linear_velocity.y * linear_velocity.y)

	added_damage = sqrt(added_damage) #Pythagorean Theorem
	added_damage *= mass #more mass, more damage
	added_damage /= 100.0 #Divide by 100 for good measure
	round(added_damage) # no decimal damage

	@warning_ignore("narrowing_conversion")
	damage += added_damage

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