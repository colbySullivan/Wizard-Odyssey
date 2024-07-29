extends CharacterBody2D

@onready var fsm = $FSM
@onready var sprite = $Sprite

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var interest_timer = $InterestTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _on_attack_area_body_entered(body):
	if(body.name == "CharacterBody2D"):
		fsm.change_state("walk")


func _on_hit_box_body_entered(body):
	if(body.name == "CharacterBody2D"):
		fsm.change_state("hit")
		# Need to make this more efficient
		await sprite.animation_looped
		queue_free()


func _on_attack_area_body_exited(body):
	if(body.name == "CharacterBody2D"):
		interest_timer.start()


func _on_timer_timeout():
	fsm.change_state("idle")
