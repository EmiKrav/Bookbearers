extends Node

var childName = "?Name?"

var MusicVol = 50
var SoundVol = 50

var cameramove = true
var turtorialcomplete = true
 #false
var firstchildturtorialcomplete = true
#false
var grafspot = 59
var autopereiti = true
var istrynt : Array
var istryntg : Array

var posiblequests = [[0,"Steal back wheat \n",false,false],
[1,"Return wheat to wolf \n",false,false],
[2,"Steal back flour \n",false,false],
[3,"Return flour to wolf \n",false,false],
[4,"Steal back bread \n",false,false],
[5,"Return bread to wolf \n",false,false],
[6,"Steal back potions \n",false,false],
[7,"Return potions to tree \n",false,false],
[8,"Steal back flowers \n",false,false],
[9,"Return flower to robot \n",false,false]]
var quests
var questnr = []
var currentquest = -1
var questheight = 80

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
	childName = "?Name?"
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

