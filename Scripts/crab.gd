extends Sprite2D

@onready var anim : AnimationPlayer = $AnimationPlayer

var velocity : Vector2 = Vector2(0, 0)
var gravity : float = 60
var gravityEnabled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if gravityEnabled:
		velocity.y += gravity * delta
		global_position += velocity * delta
		
		if global_position.y > 350:
			self.queue_free()
	
	_manage_animation()

func _manage_animation():
	anim.play("walk")
