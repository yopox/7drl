class_name Joystick extends Node2D

@onready var knob = $ColorRect
var pressed: bool = false
var event: InputEventScreenDrag


func _process(delta):
	var ev_pos = event.position - position if event != null else Vector2.ZERO
	knob.update(delta, event != null, ev_pos)
	update(Vector2.ZERO if event == null else knob.disp)


func update(_pos):
	pass


func _input(ev):
	if ev is InputEventScreenDrag:
		if (ev.position - position).length() <= 24:
			event = ev
			return
		elif event != null and ev.index == event.index:
			event = ev
			return
	if event != null and ev is InputEventScreenTouch:
		if ev.index == event.index and not ev.is_pressed():
			event = null
