extends State
class_name EnemyDead

func State_Physics_Update(delta):
	get_owner().queue_free()
	print(get_owner().name + " died!")
