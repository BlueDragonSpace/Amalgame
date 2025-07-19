extends CanvasLayer

@onready var pause_screen: Control = $Theme/PauseScreen

func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("pause"):
		pause_screen.visible = true
		get_tree().paused = true

	if Input.is_action_just_pressed("unpause") and get_tree().paused:
		pause_screen.visible = false
		get_tree().paused = false
