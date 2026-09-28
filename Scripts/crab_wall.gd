extends Area2D

var crabs : Array = []
var wallEntered : bool = false
var thrownCrabs : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crabs = get_children().filter(func(child): return child.is_in_group('Crab'))

func _process(_delta: float) -> void:
	if not wallEntered:
		return
	
	if not thrownCrabs:
		throw_crabs()
		return
	

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group('Player'):
		return
	wallEntered = true
	body.crab.visible = true
	body.crabHitbox.set_deferred('disabled', false)

func throw_crabs():
	for crab in crabs:
		crab.velocity = Vector2(randi_range(10, 100), randi_range(-100, 100))
		crab.gravityEnabled = true
	thrownCrabs = true
