extends Label

var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_basketball_net_right_body_entered(body: Node2D) -> void:
	if not body.is_in_group('Basketball'):
		return
	if body.global_position.y < -37:
		_score()


func _on_basketball_net_left_body_entered(body: Node2D) -> void:
	if not body.is_in_group('Basketball'):
		return
	if body.global_position.y < -37:
		_score()

func _score():
	score += 1
	self.text = 'Score: ' + str(score)
