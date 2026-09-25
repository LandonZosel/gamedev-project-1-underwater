extends CharacterBody2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var Trash: Marker2D = $Trash

@export var amplitude_x: float = 125
@export var frequency_x: float = 0.06
@export var amplitude_y: float = 15.0
@export var frequency_y: float = 0.2

var elapsed_time: float = 0
var start_pos: Vector2
var trash: Node2D
var trashAcceleration: float = 100

var returningToStart: bool = false

signal on_trash_deleted

func _ready() -> void:
	start_pos = global_position

func _physics_process(delta: float) -> void:
	if trash:
		velocity.y -= trashAcceleration * delta
		
		if position.y < -200:
			call_deferred("reset_drone")
			
	elif returningToStart:
		if position.y >= start_pos.y:
			global_position = start_pos
			elapsed_time = 0
			returningToStart = false
	else:
		elapsed_time += delta
		
		var forward_wave: float = sin(elapsed_time * frequency_x * (2.0 * PI)) * amplitude_x
		var side_wave: float = sin(elapsed_time * frequency_y * (2.0 * PI)) * amplitude_y
		
		var forward_vector: Vector2 = transform.x * forward_wave
		var side_vector: Vector2 = transform.y * side_wave
		
		global_position = start_pos + forward_vector + side_vector
	
	move_and_slide()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Trash"):
		return
	if not body.gravityEnabled:
		return
	collect_trash(body)

func collect_trash(body: Node2D):
	trash = body
	trash.stop_physics()
	call_deferred("change_parent")

func change_parent():
	trash.reparent(Trash)
	trash.position = Vector2.ZERO
	trash.rotation = 0
	velocity = Vector2(0, 20)
	
func reset_drone():
	if trash:
		on_trash_deleted.emit()
		trash.queue_free()
		trash = null
		returningToStart = true
		velocity = Vector2(0, 100)
		global_position = Vector2(start_pos.x, start_pos.y - 200)
	

func _process(_delta: float) -> void:
	_manage_animation()
	
func _manage_animation():
	anim.play("idle")
