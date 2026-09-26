extends Camera2D

@export var dronePosition : Vector2 = Vector2(193, -37)
@export var tutorialPosition : Vector2 = Vector2(-440, -37)
@export var fixedZoom : Vector2 = Vector2(3.75, 3.75)

var player: Node2D
var exit: Node2D
var normalZoom : Vector2

func _ready() -> void:
	player = get_tree().get_first_node_in_group('Player')
	exit = get_tree().get_first_node_in_group('Exit')
	print('exit global position: ' + str(exit.global_position))
	normalZoom = zoom


func _process(delta: float) -> void:
	if exit.openingExit:
		global_position = global_position.lerp(exit.global_position, 7.0 * delta)
		print('camera at exit! gp: ' + str(global_position))
		if zoom != normalZoom:
			zoom = zoom.lerp(normalZoom, 2.5 * delta)
	elif player.global_position.y < 50 && player.global_position.x < 350 && player.global_position.x > 0:
		#handle position
		if not global_position == dronePosition:
			global_position = global_position.lerp(dronePosition, 2.5 * delta)
		
		#handle zoom
		if not zoom == fixedZoom:
			zoom = zoom.lerp(fixedZoom, 2.5 * delta)
	elif player.global_position.y < 50 && player.global_position.x < 0:
		#handle position
		if not global_position == tutorialPosition:
			global_position = global_position.lerp(tutorialPosition, 2.5 * delta)
		
		#handle zoom
		if not zoom == fixedZoom:
			zoom = zoom.lerp(fixedZoom, 2.5 * delta)
	else:
		global_position = global_position.lerp(player.global_position, 7.0 * delta)
		if zoom != normalZoom:
			zoom = zoom.lerp(normalZoom, 2.5 * delta)
