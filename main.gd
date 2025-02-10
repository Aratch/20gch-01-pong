extends Node2D

signal game_ready

var ball: Ball

func _restart_game() -> void:
	if $Ball.position.x < 0:
		$Player2ScoreLabel.add_point()
	else:
		$Player1ScoreLabel.add_point()
	$Paddle._start_game()
	$Paddle2._start_game()
	$Ball._start_game()

func _ready() -> void:
	ball = $Ball
	$Ball.ball_exited.connect(_restart_game)
	emit_signal(&"game_ready")
	
