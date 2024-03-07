class_name ItemDrop extends RigidBody2D

@onready var item: ItemNode = $Item
@onready var area: Area2D = $Area2D

var drops = [
	Inventory.Item.Bomb, Inventory.Item.Bomb, Inventory.Item.Bomb,
	Inventory.Item.Potion, Inventory.Item.Potion,
]


func _ready():
	(item.material as ShaderMaterial).set_shader_parameter("no_bg", true)


func randomize():
	item.item = drops.pick_random()


func _process(_delta):
	if Util.gui.inventory.is_full():
		return
	
	for body in area.get_overlapping_bodies():
		if body is Hero:
			var angle = (body.global_position - global_position).angle()
			apply_impulse(Vector2(cos(angle), sin(angle)) * 0.25)
	
	for body in get_colliding_bodies():
		if body is Hero:
			Util.gui.inventory.add_item(item.item)
			queue_free()
