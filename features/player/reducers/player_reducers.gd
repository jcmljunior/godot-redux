extends Node

@onready var initial_setup: Dictionary = {
	"state": {
		"player": {
			"name": "",
			"age": 0,
		},
	},
	"method": player_reducer,
	"accept_action": [
		PlayerConstants.PLAYER_SET_NAME,
		PlayerConstants.PLAYER_SET_AGE,
	],
	"listeners": [],
	"middlewares": [
		{
			"type": PlayerConstants.PLAYER_SET_NAME,
			"method": PlayerMiddlewares.show_player_set_name,
			"on": "load",
		},
		{
			"type": PlayerConstants.PLAYER_SET_AGE,
			"method": PlayerMiddlewares.show_player_set_age,
			"on": "load",
		},
	],
}

func player_reducer(state: Dictionary, action: Dictionary) -> Dictionary:
	match(action.get("type")):
		PlayerConstants.PLAYER_SET_NAME:
			var names = [
				"Patrícia",
				"Letícia",
				"Marcela",
				"Adriane",
				"Renata",
				"Cláudia",
				"Mônica",
				"Viviane",
				"Sônia",
				"Cristiane",
				"Marcela",
				"Rebeca",
				"Sâmia",
				"Pâmela",
				"Bárbara",
				"Roberta",
				"Paula",
				"Ingrid",
				"Mariangela",
				"Rosangela",
				"Monique",
				"Verônica",
				"Márcia",
				"Angela",
				"Ester",
				"Gisele",
				"Luciane",
				"Sheila",
				"Jade",
				"Keithy",
				"Elaine",
				"Keila",
				"Maria",
				"Catarina",
				"Bruna",
				"Milene",
				"Solange",
				"Fernanda",
				"Vanessa",
				"Edilene",
				"Marlene",
				"Carla",
				"Suzana",
				"Tatiana",
				"Darlene",
				"Valdirene",
				"Adriana",
				"Fabiana",
				"Luana",
				"Soraya",
				"Jaqueline",
				"Marcele",
				"Ludmila",
				"Ana",
				"Ana Claudia",
				"Kelly",
				"Priscila",
				"Bia",
				"Juliana",
				"Amanda",
				"Yolanda",
				"Jennifer",
				"Marta",
				"Vanda",
				"Sandra",
				"Eliana",
				"Sarah",
				"Mara",
				"Paula",
				"Kimberlly",
				"Tatiane",
				"Jussara",
				"Yara",
				"Mayara",
				"Daiane",
				"Beth",
				"Rosane",
				"Ivone",
				"Gabriela",
				"Margarete",
			]
			var index = randi() % names.size()
			
			return PlayerActions.player_set_name(names[index])
		
		PlayerConstants.PLAYER_SET_AGE:
			return PlayerActions.player_set_age(randi() % 50)
		
		_:
			return {
				"type": "",
				"payload": {
					"player": state,
				}
			}
