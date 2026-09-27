extends Area2D

@export var shrinkingFactor : float = 0.9

var shrinking : bool = false

func _physics_process(_delta: float) -> void:
	if shrinking:
		scale *= shrinkingFactor
	
	if scale <= Vector2(0.3, 0.3):
		self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	body.call_deferred('enter_oil')

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	body.call_deferred('exit_oil')
	
	shrinking = false

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group('Sponge'):
		return
	
	if area.beingHeld:
		shrinking = true

func _on_area_exited(area: Area2D) -> void:
	if not area.is_in_group('Sponge'):
		return
	
	shrinking = false
