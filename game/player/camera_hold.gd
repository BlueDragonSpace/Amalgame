extends Node2D

var current_length = 0 #length of timer currently shaking, measured in seconds
var shaking = false
var current_str = 0

func screenshake(Str, length) -> void:

	current_length += length
	shaking = true
	current_str = Str
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if shaking:

		var new_offset = Vector2(randi_range(-current_str, current_str), randi_range(-current_str, current_str))

		for child in get_children():
			child.offset = new_offset

		current_length -= 1 * delta
		
		if current_length <= 0:
			current_length = 0
			shaking = false
			current_str = 0

			for child in get_children():
				child.offset = Vector2.ZERO
