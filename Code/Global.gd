extends Node

var childName = "?Name?"

var cameramove = true
var turtorialcomplete = false
var firstchildturtorialcomplete = false
var grafspot = 0

var istrynt : Array
var istryntg : Array

var posiblequests = [[0,"Steal back wheat seeds \n",false,false],
[1,"Return wheat seeds to wolf \n",false,false],
[2,"Steal back flour \n",false,false],
[3,"Return flour to wolf \n",false,false],
[4,"Steal back bread \n",false,false],
[5,"Return bread to wolf \n",false,false],
[6,"Steal back potions \n",false,false],
[7,"Return potions to tree \n",false,false],
[8,"Steal back flower \n",false,false],
[9,"Return flower to robot \n",false,false]]
var quests
var questnr = []
var currentquest = 0
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


