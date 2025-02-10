@tool
extends Paddle

var ball: Ball

var game_ready := false

func _ready() -> void:
	get_owner().game_ready.connect(_on_game_ready)
	set_process_input(false)
	super._ready()

func _on_game_ready() -> void:
	ball = get_owner().ball
	game_ready = true
	
func _physics_process(delta: float) -> void:
	if ball and game_ready:
		if ball.position.y > position.y:
			direction = 1.0
		elif ball.position.y < position.y:
			direction = -1.0
		else:
			direction = 0.0
		super._physics_process(delta)
