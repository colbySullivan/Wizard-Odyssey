extends State
class_name mob_walk

func Enter():
	sprite.play("walk")

func Exit():
	pass
	
func Update(_delat:float):
	boar.position.x -= 1
