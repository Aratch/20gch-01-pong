@tool
class_name Ball extends CharacterBody2D

const SPEED = 500.0

var collision_shape : CircleShape2D
var ball_sprite : BallSprite
var vis_notifier : VisibleOnScreenNotifier2D

const START_DIRECTIONS := [Vector2.LEFT, Vector2.RIGHT]

signal ball_exited

func _set_up_setters():
	collision_shape.changed.connect(func ():
		var new_radius := collision_shape.radius
		ball_sprite.radius = new_radius
		vis_notifier.rect.size.x = new_radius
		vis_notifier.rect.size.y = new_radius
		vis_notifier.position.x = -(new_radius/2)
		vis_notifier.position.y = -(new_radius/2)
		)

func _set_to_initial_pos() -> void:
	var window_size := DisplayServer.window_get_size()
	position.x = window_size.x / 2
	position.y = window_size.y / 2

func _start_game() -> void:
	_set_to_initial_pos()
	velocity = START_DIRECTIONS.pick_random()

func _ready() -> void:
	collision_shape = $CollisionShape2D.shape
	ball_sprite = $BallSprite
	vis_notifier = $VisibleOnScreenNotifier2D
	if Engine.is_editor_hint():
		_set_up_setters()
	else:
		vis_notifier.screen_exited.connect(func():
			ball_exited.emit()
			)
		_start_game()
	

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var collision := move_and_collide(velocity * delta * SPEED)
	if collision:
		var normal := collision.get_normal()
		var collider := collision.get_collider()
		if collider:
			if collider is CharacterBody2D:
				var collider_velocity := (collider as CharacterBody2D).velocity
				velocity = (normal + 0.01 * collider_velocity).normalized()
			else:
				velocity = Vector2(velocity.x, -velocity.y)
	
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
