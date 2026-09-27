extends CharacterBody2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var HeldBottle: Marker2D = $HeldBottle
@onready var HeldChipBag: Marker2D = $HeldChipBag
@onready var HeldCanRings: Marker2D = $HeldCanRings
@onready var HeldBasketball: Marker2D = $HeldBasketball
@onready var HeldSponge: Marker2D = $HeldSponge
@onready var cooldown_timer: Timer = $CooldownTimer

@export var gravity : float = 120
@export var jump_force : float = 1.25
@export var rotation_rate : float = 4.5 #og 5
@export var speed: float = 120
@export var rotation_speed: float = 50
@export var nextLevelPath : String = 'res://Scenes/levels/level_1.tscn'
@export var firstLevel : bool = false

var rotation_direction : float
var move_direction : float
var held_item : CharacterBody2D = null
var current_area : CharacterBody2D = null
var movementDisabled : bool = true
var died : bool = false
var jumping : bool = false
var baseSpeed : float

func _ready() -> void:
	baseSpeed = speed
	
	#playing enter animation
	if firstLevel:
		anim.play("enter_stage_up")
	else:
		anim.play("enter_stage")

func _physics_process(delta: float) -> void:
	if movementDisabled:
		return
	
	if _in_water():
		jumping = false
		#new movement
		rotation_direction = Input.get_axis("move_left", "move_right")
		rotation += rotation_direction * rotation_rate * delta
		if rotation_direction != 0:
			velocity = Vector2.RIGHT.rotated(rotation) * rotation_speed

		move_direction = Input.is_action_pressed("move_up")
		
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
			if (global_position.x < 192 && global_position.x > -64) || (global_position.x < -690):
				#veer right
				velocity = Vector2(randi_range(10, 100), randi_range(-10, -100))
			elif (global_position.x > 192) || (global_position.x > -690 && global_position.x < -450):
				#veer left 
				velocity = Vector2(randi_range(-100, -10), randi_range(-10, -100))
			else:
				velocity = Vector2(randi_range(-100, 100), randi_range(-10, -100))
		#not in water, apply gravity with smooth rotation
		velocity.y += gravity * delta
		if velocity.length() > 0:
			var target_angle : float = velocity.angle()
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	
	if Input.is_action_just_pressed("claw"):
		if current_area != null && current_area != held_item:
			change_held_item(current_area)
		elif held_item != null:
			get_rid_of_held_item()
	
	move_and_slide()
	
func _process(_delta):
	if movementDisabled:
		return
	_manage_animation()

func _manage_animation():
	if move_direction != 0 || rotation_direction != 0:
		anim.play("move")
	else:
		anim.play("idle")

func _in_water() -> bool:
	return position.y >= 0
	
func change_area(area: CharacterBody2D):
	current_area = area

func change_held_item(item: CharacterBody2D):
	if held_item == item:
		return
	
	if held_item:
		await get_rid_of_held_item()
	
	call_deferred('set_item', item)

func set_item(item: CharacterBody2D):
	held_item = item
	held_item.stop_physics()
	
	var item_name = held_item.name
	if item_name.begins_with('Bottle'):
		held_item.reparent(get('HeldBottle'))
	elif item_name.begins_with('CanRings'):
		held_item.reparent(get('HeldCanRings'))
	elif item_name.begins_with('ChipBag'):
		held_item.reparent(get('HeldChipBag'))
	elif item_name.begins_with('Basketball'):
		held_item.reparent(get('HeldBasketball'))
	elif item_name.begins_with('Sponge'):
		held_item.reparent(get('HeldSponge'))
	else:
		held_item.reparent(get('HeldBasketball'))
	
	if held_item.crab:
		held_item.crab.trashHeld = false
	
	held_item.position = Vector2.ZERO
	held_item.rotation = 0

func drop_held_item():
	await get_rid_of_held_item()

func get_rid_of_held_item():
	held_item.reparent(get_tree().current_scene)
	held_item.start_physics()
	held_item = null

func kill_player():
	#play spin death animation
	disable_movement()
	died = true
	anim.play('exit_stage')

func start_exit():
	disable_movement()
	anim.play('exit_stage') #triggers exit_stage after animation finishes

func exit_stage():
	if died:
		died = false
		get_tree().reload_current_scene()
	else:
		get_tree().call_deferred("change_scene_to_file", nextLevelPath)

func disable_movement():
	movementDisabled = true

func enable_movement():
	movementDisabled = false

func enter_oil():
	speed = baseSpeed * 0.5

func exit_oil():
	speed = baseSpeed
