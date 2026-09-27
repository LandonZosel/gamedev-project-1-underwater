extends Label

var score : int = 0

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
