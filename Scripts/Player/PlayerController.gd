extends CharacterBody2D

@export var speed = 20
@export var jump_force = 100
@export var gravity = 200
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0 , 1.0) var acceleration = 0.25

@onready var animated_sprite = $AnimationPlayer
@onready var animated_tree = $AnimationTree

# use this for dashing and ghosting effect
var moving = false
var going_ghost = false

@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer

func _ready():
	position = Vector2(0,0)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += delta * gravity
	is_dashing()
	get_inputs()
	check_animation_orientation()
	move_and_slide()

func get_inputs():
	# left and right movement
	var dir = Input.get_axis("move_left", "move_right") * speed
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	if Input.is_action_pressed("regenerate"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("move_up") and is_on_floor():
		velocity.y -= jump_force

# handle animations
func check_animation_orientation():
	if velocity.x == 0.0:
		animated_tree.get("parameters/playback").travel("idle")
	else:
		animated_tree.get("parameters/playback").travel("walking")
		animated_tree.set("parameters/idle/blend_position", velocity.x)
		animated_tree.set("parameters/walking/blend_position", velocity.x)

# TODO need a better way of doing
# Also there is a snapping back issue when user releases in the air
func check_ghosting_orientation(ghost):
	if velocity.x > 0:
		ghost.flip_h = false
	elif velocity.x < 0:
		ghost.flip_h = true
		
func add_ghost():
	var ghost = ghost_node.instantiate()
	# TODO need to fix this janky setup
	ghost.position = position + Vector2(0,-6)
	print("Ghost", ghost.position)
	print(position)
	check_ghosting_orientation(ghost)
	get_tree().current_scene.add_child(ghost)

func _on_ghost_timer_timeout():
	if going_ghost:
		add_ghost()
		
func is_dashing():
	if Input.is_action_pressed("dash"):
		going_ghost = true
	else:
		going_ghost = false
	slow_time(going_ghost)
		
func slow_time(toggle: bool):
	if toggle == true:
		Engine.time_scale = 0.25
	else:
		Engine.time_scale = 1
