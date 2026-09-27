extends CharacterBody2D

@onready var anim : AnimationPlayer = $AnimationPlayer

@export var gravity : float = 120
@export var jump_force : float = 1.25
@export var rotation_rate : float = 4.5 #og 5
@export var speed: float = 120
@export var rotation_speed: float = 50

var timer : Timer = Timer.new()
var rotation_direction : float
var move_direction : float
var jumping : bool = false
var baseSpeed : float
var current_rotation_direction : float

func _ready() -> void:
	baseSpeed = speed
	current_rotation_direction = randi_range(-1, 1)
	
	add_child(timer)
	timer.wait_time = 1
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _physics_process(delta: float) -> void:
	if _in_water():
		jumping = false
		#fake movement
		rotation_direction = current_rotation_direction
		rotation += rotation_direction * rotation_rate * delta
		if rotation_direction != 0:
			velocity = Vector2.RIGHT.rotated(rotation) * rotation_speed

		move_direction = 1
		
		if move_direction != 0:
			velocity = Vector2.RIGHT.rotated(rotation) * (move_direction * speed)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, speed * delta * 5)
	elif not jumping:
		jumping = true
		velocity *= jump_force
	else:
		if is_on_floor():
			#uh oh we need to unstuck the player
			if (global_position.x < 192 && global_position.x > -64):
				#veer right
				velocity = Vector2(randi_range(10, 100), randi_range(-10, -100))
			elif global_position.x > 192:
				#veer left 
				velocity = Vector2(randi_range(-100, -10), randi_range(-10, -100))
			else:
				velocity = Vector2(randi_range(-100, 100), randi_range(-10, -100))
		#not in water, apply gravity with smooth rotation
		velocity.y += gravity * delta
		if velocity.length() > 0:
			var target_angle : float = velocity.angle()
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	
	move_and_slide()
	
func _process(_delta):
	_manage_animation()

func _manage_animation():
	if move_direction != 0 || rotation_direction != 0:
		anim.play("move")
	else:
		anim.play("idle")

func _in_water() -> bool:
	return position.y >= 0

func _on_timer_timeout() -> void:
	current_rotation_direction = randi_range(-1, 1)
