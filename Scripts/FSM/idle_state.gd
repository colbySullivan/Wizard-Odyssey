extends State
class_name mob_idle
@onready var sprite = $"../../Sprite"

func Enter():
	sprite.play("walking")

func Exit():
	pass
	
func Update(_delat:float):
	pass
