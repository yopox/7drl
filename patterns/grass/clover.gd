extends Node2D

@onready var item: ItemDrop = $ItemDrop


func _ready():
	item.item.item = Inventory.Item.Clover
