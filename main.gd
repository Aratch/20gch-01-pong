class_name Main
extends Node2D

signal game_ready
signal game_paused
signal game_unpaused

var paused := false
var ball: Ball

var started := false

func _start_new_round() -> void:
	if $Ball.position.x < 0:
		$Player2ScoreLabel.add_point()
	else:
		$Player1ScoreLabel.add_point()
	$Paddle._start_game()
	$Paddle2._start_game()
	$Ball._start_game()

func pause() -> void:
	paused = true
	game_paused.emit()
	%MenuLayer.show()

func unpause() -> void:
	paused = false
	%MenuLayer.hide()
	game_unpaused.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"menu_esc") and started:
		if not paused:
			pause()
		else:
			unpause()

func _ready() -> void:
	ball = $Ball
	$Ball.ball_exited.connect(_start_new_round)
	
	game_paused.connect($Ball.pause)
	game_paused.connect($Paddle.pause)
	game_paused.connect($Paddle2.pause)
	
	game_unpaused.connect($Ball.unpause)
	game_unpaused.connect($Paddle.unpause)
	game_unpaused.connect($Paddle2.unpause)
	
	%StartGameButton.pressed.connect(func():
		game_ready.emit()
		%MenuLayer.hide()
		started = true
		%StartGameButton.disabled = true
		%ResumeButton.disabled = false)
	%ResumeButton.pressed.connect(func():
		unpause())
	%QuitButton.pressed.connect(func():
		get_tree().quit())
