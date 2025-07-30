extends Enemy

@export var HORT_SPD = 128.0 #HORizonTal move SPeeD (on the static body)

@export var MAX_SELF_PROPEL = 100.0
@export var SELF_PROPEL = 64.0 #flying on swing speed

@export var offset_initial_length = 1536.0 #how long the string binding it to the static body is
@export var offset_MIN = 1024.0
@export var offset_MAX = 2048.0
@export var offset_SPD = 96.0 #how quickly it goes up and down that string
var offset_dir = 1 #as according to the y-axis, 1 = down, -1 = up

@onready var Art: Sprite2D = $Art
#@onready var Offset: Node2D = $Offset
@onready var Swing: StaticBody2D = $Offset/SwingPoint

var current_force = 0.0
var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Swing.global_position = global_position
	Swing.position.x = offset_initial_length


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if active:
		
		print("------------------")
		var dir = Player.global_position.x - global_position.x

		if dir > 0:
			print('forbirds')
			Art.flip_h = false

			Swing.position.x += HORT_SPD * delta

			if current_force < MAX_SELF_PROPEL:
				current_force += SELF_PROPEL * delta

		else:
			print('wackbirds')
			Art.flip_h = true

			Swing.position.x -= HORT_SPD * delta
			

			if current_force > -MAX_SELF_PROPEL:
				current_force -= SELF_PROPEL * delta

		print(str(current_force) + "current_force")

		#apply_central_force(Vector2(current_force,0))

		#OFFSET
	#	if Offset.position.x > offset_MAX:
	#		offset_dir = -1
	#	elif Offset.position.x < offset_MIN:
	#		offset_dir = 1

	#	Offset.position.x += offset_SPD * offset_dir * delta

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	active = true
