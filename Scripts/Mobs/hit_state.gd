extends State
class_name mob_hit
@onready var sprite = $"../../Sprite"

func Enter():
	sprite.play("hit")

func Exit():
	pass
	
func Update(_delat:float):
	pass
