@tool
class_name Paddle
extends CharacterBody2D

var collision_shape : RectangleShape2D
var color_rect : ColorRect

func _ready() -> void:
	if Engine.is_editor_hint():
		collision_shape = $CollisionShape2D.shape
		color_rect = $ColorRect
		collision_shape.changed.connect(func ():
			color_rect.size = collision_shape.size
			)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var is_player : bool = false

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	if is_player and \
		event.is_action_released(&"move_up") or \
		event.is_action_released(&"move_down"):
		velocity = Vector2.ZERO
	else:
		if event.is_action_released(&"p2_move_up") or \
			event.is_action_released(&"p2_move_down"):
				velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var direction : float
	if is_player:
		direction = Input.get_axis(&"move_up", &"move_down")
	else:
		direction = Input.get_axis(&"p2_move_up", &"p2_move_down")
	
	if direction:
		velocity.y = direction * SPEED
	
	var collision := move_and_collide(velocity * delta)
	if collision:
		pass # this works as expected
	
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
