extends CanvasLayer

signal start_HUD_appear
@onready var hp_bar: HBoxContainer = $Theme/HUD/HpBar
@onready var audio_off: TextureRect = $Theme/HUD/AudioOff

@onready var speedrun_timer: Label = $SpeedrunTimer
var time := 0.0

@onready var pause_screen: Control = $Theme/PauseScreen
var pausable = true #can go to pause screen


var has_started = false
signal started
@onready var start_screen: Control = $Theme/StartScreen

@onready var death_screen: Control = $Theme/DeathScreen

signal won
@onready var win_screen: Control = $Theme/WinScreen
var has_won = false

@onready var Animate: AnimationPlayer = $AnimationPlayer
@onready var EnterSound: AudioStreamPlayer = $EnterSound

@onready var Player = get_tree().get_nodes_in_group("Player")[0]

var HP = preload("res://UI/hp.tscn")

var death_text = ["You have been\n is are now unalived", "Wow that was terrible", "Hello, please take a number", "What have you done?", "The Axe was felled.", "Hitherforth where whence came!", "Birds don't have teeth", "Insert death text here"]

func _ready() -> void:
	connect("start_HUD_appear", HUD_appear)
	connect("won", win_trigger)
	Player.connect("player_hit",change_hp)
	Player.connect("player_dead", player_death)

	Global.check_checkpoint()
	if Global.check_checkpoint():
		
		start_screen.visible = false
		has_started = true
		Animate.play("death_reset_out")
		time = Global.time

		speedrun_timer.visible = Global.timer_visible
		audio_off.visible = Global.muted
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), Global.muted)



	death_screen.get_node("Label").text = death_text[randi_range(0,death_text.size()-1)]

func _process(delta: float) -> void:

	if pausable:
		if Input.is_action_just_pressed("pause"):
			pause_screen.visible = true
			get_tree().paused = true
			EnterSound.play()

		if Input.is_action_just_pressed("unpause") and get_tree().paused:
			pause_screen.visible = false
			get_tree().paused = false
		
	if Player.is_dead:
		Engine.time_scale -= 0.3 * delta
	
	if start_screen.visible and Input.is_action_just_pressed("unpause") and not has_started:
		started.emit()
		Animate.play("start_fade")
		has_started = true
	
	if death_screen.visible and Input.is_action_just_pressed("unpause"):
		Engine.time_scale = 1.0
		Animate.play("death_reset")
		EnterSound.play()
		Music.pitch_up()

	if Input.is_action_just_pressed("debug5") and Global.dev_mode:

		Animate.play("death_reset_out")

	if has_won:
		Engine.time_scale = 1.0
		if Input.is_action_just_pressed("unpause"):
			_on_restart_button_pressed()
	
	#mute button
	if Input.is_action_just_pressed("mute"):
		if audio_off.visible:
			audio_off.visible = false
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
			Global.muted = false
		else:
			audio_off.visible = true
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
			Global.muted = true
	
	#Speedrun Timer
	#On/Off
	if Input.is_action_just_pressed("timer"):
		if speedrun_timer.visible:
			speedrun_timer.visible = false
			Global.timer_visible = false
		else:
			speedrun_timer.visible = true
			speedrun_timer.text = Global.time_string
			Global.timer_visible = true
	#Recording Time
	if has_started and !has_won:
		var msec = fmod(time, 1) * 100
		var sec = fmod(time,60)
		var minute = fmod(time,3600) / 60

		speedrun_timer.text = "%02d" % minute + ":" + "%02d" % sec + "." + "%02d" % msec
		time += delta
		Global.time = time
	elif has_won:
		speedrun_timer.modulate = Color.GOLD


func change_hp() -> void:
	for child in hp_bar.get_children():
		child.queue_free()
	for num in Player.HP:
		var new_child = HP.instantiate()
		hp_bar.add_child(new_child)

func player_death() -> void:
	Animate.play("fade_to_death")
	death_screen.visible = true
	pausable = false
	

func HUD_appear() -> void:
	Animate.play("HUD_appear")

func win_trigger() -> void:
	win_screen.get_node("AnimationPlayer").play("Finale")
	
	AudioServer.set_bus_mute(1,true)

	Engine.time_scale = 1.0 #would sometimes die before the cutscene ends...
	has_won = true

#retry from death
func retry() -> void:
	get_tree().reload_current_scene()
	death_screen.visible = false

	Engine.time_scale = 1.0
	pausable = true

#retry from winning
func _on_restart_button_pressed() -> void:

	Music.FinaleForest.stop()
	Global.checkpoint_pos = Vector2(0,0)
	AudioServer.set_bus_mute(1,false)
	retry()
