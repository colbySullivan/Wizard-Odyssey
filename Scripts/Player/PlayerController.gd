extends CharacterBody2D

@export var key_speed = 5

@onready var animated_sprite = $AnimationPlayer
@onready var animated_tree = $AnimationTree

# use this for dashing and ghosting effect
var moving = false
var going_ghost = false

@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer

const GRAVITY = 200.0

func _ready():
	position = Vector2(0,0)

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	is_dashing()
	get_inputs()
	check_animation_orientation()
	move_and_slide()

func get_inputs():
	# left and right movement
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity += direction * key_speed
	if Input.is_action_pressed("regenerate"):
		get_tree().reload_current_scene()

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
	ghost.position = position + + Vector2(0,-6)
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
