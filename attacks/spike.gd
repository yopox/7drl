extends Attack


func _on_lifetime_timeout():
	queue_free()
