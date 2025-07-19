class_name Entity
extends CharacterBody2D

#an abstract class for entities (meaning player, enemies, objects, 
#things with HP and can be damaged)

@export var max_hp: int = 100
@onready var current_hp: int = max_hp
#did not know this... but use @onready to prepare for exported variables

func take_hit(damage: int) -> void:
	if current_hp - damage <= 0:
		current_hp = 0
		
		#add death particle effect
		queue_free()
	else:
		current_hp -= damage