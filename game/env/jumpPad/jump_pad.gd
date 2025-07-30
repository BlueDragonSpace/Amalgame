extends StaticBody2D

@export var impulse_str = 15000.0

@onready var Pad: RigidBody2D = $Pad
@onready var ReleaseTimer: Timer = $Release

func _on_pad_body_entered(_body:Node) -> void:
	print("pressed")
	ReleaseTimer.start()


func _on_pad_body_exited(_body:Node) -> void:
	print("off of")
	ReleaseTimer.stop()


func _on_release_timeout() -> void:
	print("release")
	Pad.apply_central_impulse(Vector2(0,-impulse_str))