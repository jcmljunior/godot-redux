extends Node

@warning_ignore("shadowed_variable_base_class")


func generate_people(state: String) -> String:
	var peoples: Array = [
		"Patrícia",
		"Letícia",
		"Marcela",
		"Adriane",
		"Renata",
		"Cláudia",
		"Mônica",
		"Viviane",
	]
	peoples = peoples.filter(func(name: String): return name != state)

	return peoples[randi() % peoples.size()]


func people_set_name(name: String) -> Dictionary:
	return {
		"type": PeopleConstants.PEOPLE_SET_NAME,
		"payload":
		{
			"people":
			{
				"name": generate_people(name),
			}
		}
	}
