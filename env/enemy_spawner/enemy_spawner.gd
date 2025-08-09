extends Node2D

@export var Spawned_Enemy : PackedScene
@export var Child_Path : Node

func spawn_enemy() -> void:
	var instance = Spawned_Enemy.instantiate()

	instance.global_position = global_position

	#alright, so for some stupid reason, I added an offset to the "environment" node, and now every
	#enemy without this offset ends up getting placed farther right than it should...
	#bleh I knew stuff like this would eventually come back to bite me...

	instance.global_position.x -= 3904
	instance.global_position.y += 192.0

	# adding an exception for the Swinger...
	if instance.name == "SwingPoint":
		var stupid_bird = instance.get_node("Node").get_node("Swinger")
		stupid_bird.active = true
	elif instance.name == "Jumper":
		instance.active = true
	#bull doesn't get activated until seen

	Child_Path.add_child(instance)
