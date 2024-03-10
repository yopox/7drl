extends Node2D

@onready var item_drop: ItemDrop = $ItemDrop


func _ready():
	item_drop.item.item = Inventory.Item.Potion
