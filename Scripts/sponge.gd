extends CharacterBody2D

@onready var Hitbox: CollisionShape2D = $PhysicsHitbox
@onready var area : Area2D = $Area
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var crab : Sprite2D = null

@export var buoyancy : float = 120
@export var waterResistance : float = 120
@export var gravity : float = 60
@export var gravityEnabled : bool = true
@export var oilCount : int = 1

var player_in_hitbox : CharacterBody2D = null
var filling : bool = false
var filled : bool = false

func _physics_process(delta: float) -> void:
	 #handle gravity
	if not gravityEnabled:
		velocity.y = 0
	
	if not is_on_floor() && gravityEnabled:
		if _in_water():
			if velocity.y > 20:
				velocity.y -= buoyancy * delta
			else:
				velocity.y += 4 * delta
			
			if velocity.x > 0:
				velocity.x -= waterResistance * delta
			elif velocity.x < 0:
				velocity.x += waterResistance * delta
			
		else:
			velocity.y += gravity * delta
			
	
	if is_on_floor() && not _in_water():
		#uh oh we need to unstuck the sponge
		if (global_position.x < 192 && global_position.x > -64) || (global_position.x < -690):
			#veer right
			velocity = Vector2(randi_range(10, 100), randi_range(-10, -100))
		elif (global_position.x > 192) || (global_position.x > -690 && global_position.x < -450):
			#veer left 
			velocity = Vector2(randi_range(-100, -10), randi_range(-10, -100))
		else:
			velocity = Vector2(randi_range(-100, 100), randi_range(-10, -100))
	
	#if sponge randomly gets flung fast, stop movement
	if velocity.y > 150 || velocity.x > 150 || velocity.x < -150 || velocity.y < -150:
		velocity.y = 0
		velocity.x = 0
	move_and_slide()

func _in_water() -> bool:
	return position.y >= 0

func _on_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	body.change_area(self)

func _on_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	body.change_area(null)

func stop_physics():
	gravityEnabled = false
	area.beingHeld = true
	velocity.x = 0
	Hitbox.set_deferred("disabled", true)

func start_physics():
	gravityEnabled = true
	area.beingHeld = false
	velocity.y = 10
	Hitbox.set_deferred("disabled", false)

func set_filled():
	filling = false
	filled = true

func _on_oil_child_exiting_tree(_node: Node) -> void:
	oilCount -= 1
	if oilCount == 0:
		#trigger sponge filling up
		filling = true
		anim.play('fill')
