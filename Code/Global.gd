extends Node

var childName = "?Name?"

var MusicVol = 50
var SoundVol = 50

var cameramove = true
var turtorialcomplete = false
 #false
var firstchildturtorialcomplete = false
#false
var grafspot = 0
#vilkas = 7
#egle = 29
#robotas = 50
var autopereiti = false
var istrynt : Array
var istryntg : Array
#var posiblequests = [[0,"Steal back wheat \n",false,false],
#[1,"Return wheat to wolf \n",false,false],
#[2,"Steal back flour \n",false,false],
#[3,"Return flour to wolf \n",false,false],
#[4,"Steal back bread \n",false,false],
#[5,"Return bread to wolf \n",false,true],
#[6,"Steal back potions \n",false,false],
#[7,"Return potions to tree \n",false,true],
#[8,"Steal back flowers \n",false,false],
#[9,"Return flower to robot \n",false,true]]
var posiblequests = [[0,"Steal back wheat \n",false,false],
[1,"Return wheat to wolf \n",false,false],
[2,"Steal back flour \n",false,false],
[3,"Return flour to wolf \n",false,false],
[4,"Steal back bread \n",false,false],
[5,"Return bread to wolf \n",false,false],
[6,"Steal back potions \n",false,false],
[7,"Return potions to tree \n",false,false],
[8,"Steal back flowers \n",false,false],
[9,"Return flowers to robot \n",false,false]]
var quests
var questnr = []
var currentquest = 0
var questheight = 120

var health = 10;
var scrolls = []
var usedscrolls = 0;
var enemy = []

var day = 1

var camerapos = null

var bookbearer = true

var animationplaying = false

func AddName(Name):
	Global.childName = Name
func CompletedGame():
	bookbearer = true
	childName = "Emilija"
	turtorialcomplete = false
	firstchildturtorialcomplete = false
	grafspot = 0
	health = 10
	quests = ""
	questnr = []
	currentquest = 0
	questheight = 80
	scrolls = []
	usedscrolls = 0;
	enemy = []



func save_to_file(content):
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_string(content)

func load_from_file():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var content = file.get_as_text()
	return content

