extends Node

var childName = "Name"

var cameramove = true

var grafspot = 0

var istrynt : Array
var istryntg : Array

var posiblequests = [[0,"Steal back wheat seeds \n",false],
[1,"Steal back flour \n",false],[2,"Steal back bread \n",false]]
var quests 
var questheight = 80

var day = 1

var camerapos = null

func AddName(Name):
	Global.childName = Name


