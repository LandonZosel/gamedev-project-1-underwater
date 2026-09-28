extends Sprite2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction

@export var move_direction : Vector2
@export var move_speed : float = 10
@export var crabWallCrab : bool = false
@export var pumpAnimation : bool = false

var velocity : Vector2 = Vector2(0, 0)
var gravity : float = 60
var gravityEnabled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float):
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	if global_position == target_pos:
		if target_pos == start_pos:
			target_pos = start_pos + move_direction
		else:
			target_pos = start_pos

func _process(delta: float) -> void:
	if gravityEnabled:
		velocity.y += gravity * delta
		global_position += velocity * delta
		
		if global_position.y > 350:
			self.queue_free()
	
	_manage_animation()

func _manage_animation():
	if pumpAnimation:
		anim.play('pump')
	
	if move_direction.x != 0 || crabWallCrab:
		anim.play("walk")
