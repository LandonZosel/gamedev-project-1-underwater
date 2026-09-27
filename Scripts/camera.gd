extends Camera2D

@export var dronePosition : Vector2 = Vector2(192, -37)
@export var secondaryPosition : Vector2 = Vector2(-440, -37)
@export var fixedZoom : Vector2 = Vector2(3.75, 3.75)

var player: Node2D
var exit: Node2D
var normalZoom : Vector2

func _ready() -> void:
	player = get_tree().get_first_node_in_group('Player')
	exit = get_tree().get_first_node_in_group('Exit')
	normalZoom = zoom

func _process(delta: float) -> void:
	if exit.openingExit:
		global_position = global_position.lerp(exit.global_position, 7.0 * delta)
		if zoom != normalZoom:
			zoom = zoom.lerp(normalZoom, 2.5 * delta)
	elif player.global_position.y < 50 && player.global_position.x < 384 && player.global_position.x > 0:
		#handle position
		if not global_position == dronePosition:
			global_position = global_position.lerp(dronePosition, 2.5 * delta)
		
		#handle zoom
		if not zoom == fixedZoom:
			zoom = zoom.lerp(fixedZoom, 2.5 * delta)
	elif player.global_position.y < 50 && player.global_position.x < 0:
		#handle position
		if not global_position == secondaryPosition:
			global_position = global_position.lerp(secondaryPosition, 2.5 * delta)
		
		#handle zoom
		if not zoom == fixedZoom:
			zoom = zoom.lerp(fixedZoom, 2.5 * delta)
	else:
		global_position = global_position.lerp(player.global_position, 7.0 * delta)
		if zoom != normalZoom:
			zoom = zoom.lerp(normalZoom, 2.5 * delta)
