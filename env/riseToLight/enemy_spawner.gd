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

	print(instance.name)

	#andddddd a swinger exeception
	if instance.name == "SwingPoint":
		pass
	else:
		instance.active = true

	Child_Path.add_child(instance)
