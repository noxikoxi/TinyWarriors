extends Node

signal gold_change

var gold:int = 200:
	get:
		return gold
	set(value):
		gold = value
		gold_change.emit()
		
var goblin_house:StaticBody2D
var castle: StaticBody2D
var gold_mine: StaticBody2D

const knight_cost:int = 100
const pawn_cost:int = 120
const archer_cost:int = 150
