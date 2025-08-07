extends StaticBody2D

@export var impulse_str = 15000.0

@onready var Pad: RigidBody2D = $Pad
@onready var ReleaseTimer: Timer = $Release

@onready var PressureRising: AudioStreamPlayer2D = $PressureRising
@onready var SpringAudio: AudioStreamPlayer2D = $Spring

func _on_pad_body_entered(_body:Node) -> void:
	ReleaseTimer.start()
	PressureRising.play()


func _on_pad_body_exited(_body:Node) -> void:
	ReleaseTimer.stop()
	PressureRising.stop()


func _on_release_timeout() -> void:
	Pad.apply_central_impulse(Vector2(0,-impulse_str))
	SpringAudio.play()
