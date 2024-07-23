extends State
class_name mob_idle
@onready var sprite = $"../../Sprite"

func Enter():
	sprite.play("idle")

func Exit():
	pass
	
func Update(_delat:float):
	pass
