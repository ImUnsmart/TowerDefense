extends "res://scripts/tower/tower.gd"

func init():
	display_name = "Bank"
	description = "Produces a small amount of cash every round."
	upgrade_costs = [400, 650, 1000, 4000, 12000]
	upgrade_names = ["More Cash", "Better Banking", "Intelligence", "Monopoly", "Enterprise"]
	upgrade_descriptions = ["Produces an extra $25 per round.", "Produces $50 more every round.", "Produces $75 extra per round", "No one can compare, produces an extra $100 per round", "For when you're too large to fail..."]
	start_radius = 32
	cost = 1000
	value = cost

func upgrade():
	value += upgrade_costs[level]
	level += 1
	
func get_money_produced():
	var base = 50
	if level == 1:
		base += 25
	if level == 2:
		base += 50
	if level == 3:
		base += 75
	if level == 4:
		base += 100
	if level == 5:
		base *= 2
	return base