extends Control

var level : int
var quests : Array = []

func _on_food_button_pressed():
	get_tree().change_scene_to_file("res://scenes/food_screen.tscn")


func _on_weedometer_button_pressed():
	get_tree().change_scene_to_file("res://scenes/weed_module.tscn")
