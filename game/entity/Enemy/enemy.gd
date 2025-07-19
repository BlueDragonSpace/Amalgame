extends Entity

@onready var devLabel: Label = $DevLabel

@export var speed: int = 100
@export var deacceleration: int = 2 #for knockback

var velocity_offset = Vector2(0, 0) #also for knockback

var player_seen = false
var player_body :Entity = null

func _physics_process(_delta: float) -> void:
	if player_seen:
		var direction = (player_body.global_position - global_position).normalized()
		velocity = direction * speed
		velocity += velocity_offset
		move_and_slide()
	else:
		move_and_slide()
	
	velocity_offset.x = move_toward(velocity_offset.x, 0, deacceleration)
	velocity_offset.y = move_toward(velocity_offset.y, 0, deacceleration)
	
	devLabel.text = "Entity: " + str(self) + "\nSpeed: " + str(speed) + "\nHp: " + str(current_hp) + "\nPlayer Seen: " + str(player_seen)

func _on_sight_body_entered(body:Node2D) -> void:
	print("Sight body entered: " + str(body))
	player_seen = true
	player_body = body
