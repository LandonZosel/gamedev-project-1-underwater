extends CharacterBody2D

@onready var Hitbox: CollisionShape2D = $PhysicsHitbox
@onready var crab : Sprite2D = null

@export var buoyancy : float = 160
@export var waterResistance : float = 120
@export var gravity : float = 60
@export var gravityEnabled : bool = true
@export var throwForce : float = 80

var player_in_hitbox : CharacterBody2D = null

func _physics_process(delta: float) -> void:
	 #handle gravity
	if not gravityEnabled:
		velocity = Vector2(0, 0)
	
	if not _in_water() && is_on_floor():
		#uh oh we need to unstuck the basketball
		velocity = Vector2(randi_range(-30, 30), randi_range(-10, -30))
	
	if not is_on_floor() && gravityEnabled:
		if _in_water():
			if velocity.y > 0:
				velocity.y -= buoyancy * delta
			else:
				velocity.y += 4 * delta
			
			if velocity.x > 0:
				velocity.x -= waterResistance * delta
			elif velocity.x < 0:
				velocity.x += waterResistance * delta
			
		else:
			velocity.y += gravity * delta
			
	
	var collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		velocity *= 0.2
	
	#if basketball randomly gets flung fast, stop it
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
	velocity = Vector2(0, 0)
	Hitbox.set_deferred("disabled", true)

func start_physics():
	gravityEnabled = true
	velocity = Vector2.RIGHT.rotated(rotation) * throwForce
	Hitbox.set_deferred("disabled", false)
