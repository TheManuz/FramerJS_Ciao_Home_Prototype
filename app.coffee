# This imports all the layers for "Sketchat_home" into sketchat_homeLayers
layers = Framer.Importer.load "imported/Sketchat_home"
Framer.Device.contentScale = 2
#Framer.Device.background.image = "image.jpg"
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
#DEFAULTS VALUES
GRIDSIZE = 3
NUMBEROFCONTACTS = 11
MARGIN = 4

SHORTANIMTIME = 0.1
LONGANIMTIME = 0.4
AVATARFREQUENCY = 0.5
AVATARSIZE = Math.round((320 - MARGIN*(GRIDSIZE+1)) / GRIDSIZE)
AVATARPHOTOS = Utils.cycle([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
DRAWAVATARSIZE = Math.round((320 - MARGIN*(3+1)) / 3)
SENDPOSITION = 320-MARGIN-DRAWAVATARSIZE
SHEETSIZE = 320-MARGIN*2
LABELWIDTH = 320-DRAWAVATARSIZE-MARGIN*3
LABELHEIGHT = 48
COLORS900 = ["#b0120a", "#880e4f", "#4a148c", "#311b92", "#1a237e", "#2a36b1", "#01579b", "#006064", "#004d40", "#0d5302", "#33691e", "#827717", "#f57f17", "#ff6f00", "#e65100", "#bf360c"];
COLORS500 = ["#e51c23", "#e91e63", "#9c27b0", "#673ab7", "#3f51b5", "#5677fc", "#03a9f4", "#00bcd4", "#009688", "#259b24", "#8bc34a", "#cddc39", "#ffeb3b", "#ffc107", "#ff9800", "#ff5722"];
COLORS300 = ["#f36c60", "#f06292", "#ba68c8", "#9575cd", "#7986cb", "#91a7ff", "#4fc3f7", "#4dd0e1", "#4db6ac", "#42bd41", "#aed581", "#dce775", "#fff176", "#ffd54f", "#ffb74d", "#ff8a65"];
COLORSA400 = ["#ff2d6f", "#f50057", "#d500f9", "#651fff", "#3d5afe", "#4d73ff", "#00b0ff", "#00e5ff", "#1de9b6", "#14e715", "#76ff03", "#c6ff00", "#ffea00", "#ffc400", "#ff9100", "#ff3d00"];
COLORSA200 = ["#ff5177", "#ff4081", "#e040fb", "#7c4dff", "#536dfe", "#6889ff", "#40c4ff", "#18ffff", "#64ffda", "#5af158", "#b2ff59", "#eeff41", "#ffff00", "#ffd740", "#ffab40", "#ff6e40"];
LABELSTYLE =
		fontFamily: "Roboto", lineHeight: '48px',
		textAlign: "left", verticalAlign: "middle"
		fontSize: "16px", fontStyle: "normal",
		fontWeight: 500, color: '#fff',
		padding: "0 8px"

materialCurveMove = "cubic-bezier(0.4, 0, 0.2, 1)"
materialCurveEnter = "cubic-bezier(0, 0, 0.2, 1)"
materialCurveExit = "cubic-bezier(0.4, 0, 1, 1)"
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Framer.Defaults.Animation =
	curve: materialCurveMove
	time: 0.6
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
#INITIALIZATION
for b in ["menu_button", "add_button", "back_button"]
	layers[b].states.add
		hidden: {scale:0, opacity:0}
layers["back_button"].states.switchInstant "hidden"

navbarTitle = new Layer
	superLayer: layers["NavigationBar"]
	x: 44, y: 20, width: 232, height: 48, backgroundColor: "transparent"
navbarTitle.style = LABELSTYLE
navbarTitle.style = textAlign: "center"
navbarTitle.states.add
	out: {scaleY: 0, opacity: 0}
navbarTitle.states.switchInstant "out"

navbarLogo = layers["logo_white"]
navbarLogo.states.add
	out: {scaleY: 0, opacity: 0}

navbarSwitch = (title) ->
	if title is undefined
		navbarTitle.states.switch "out"
		navbarLogo.states.switch "default"
	else
		navbarTitle.html = title
		navbarTitle.states.switch "default"
		navbarLogo.states.switch "out"
	
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
#SUPPORT FUNCTIONS
navbarDrawingState = (title) ->
	layers["menu_button"].states.switch "hidden"
	layers["back_button"].states.switch "default"
	layers["back_button"].ignoreEvents = false
	Utils.delay 0.1, () ->
		navbarSwitch(title)
	Utils.delay 0.2, () ->
		layers["add_button"].states.switch "hidden"
	
navbarContactsState = () ->
	layers["menu_button"].states.switch "default"
	Utils.delay 0.1, () ->
		navbarSwitch()
	Utils.delay 0.2, () ->
		layers["add_button"].states.switch "default"
		layers["back_button"].states.switch "hidden"
	
makeAvatarForGrid = (position) ->
	column = position % GRIDSIZE
	row = (position / GRIDSIZE) | 0
	if Math.random() >= AVATARFREQUENCY
		avatarImage = "images/default_avatar.png"
	else
		avatarImage = "images/avatar"+AVATARPHOTOS()+".png"
	avatar = new Layer
		x: AVATARSIZE * column + MARGIN*(column+1)
		y: AVATARSIZE * row + MARGIN*(row+1)
		width: AVATARSIZE, height: AVATARSIZE, clip: false
		image: avatarImage,
	avatar.position = position
	avatar.states.add
		entering: {scale: 0, opacity: 0, rotationZ: 10}
		exiting: {scale: 0, opacity: 0, rotationZ: -10}
	avatar.states.switchInstant "entering"
	avatar.style =
		backgroundColor: COLORSA400[(Utils.randomNumber(0,16)|0)]
	avatar.label = new Layer
		superLayer: avatar
		x: 0, y:AVATARSIZE-48
		width: AVATARSIZE, height: 48
		backgroundColor: "transparent",
	avatar.label.html = "Nome "+position
	avatar.label.style = LABELSTYLE
	avatar.label.style = background: "linear-gradient(rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.5))"
	avatar

makeAvatarForDrawing = (gridAvatar) ->
	avatar = new Layer
		x: gridAvatar.x, y: gridAvatar.y
		width: AVATARSIZE, height: AVATARSIZE, clip: false
		image: gridAvatar.image,
		scale: 1.2
	avatar.position = gridAvatar.position
	avatar.style = backgroundColor: gridAvatar.style.backgroundColor
	avatar.draggable.enabled = true
	avatar.draggable.speedX = 0.5
	avatar.draggable.speedY = 0
	avatar.draggable.maxDragFrame = avatar.frame
	avatar.draggable.maxDragFrame.x = MARGIN
	avatar.draggable.maxDragFrame.y = 568-64-MARGIN-DRAWAVATARSIZE
	avatar.draggable.maxDragFrame.width = 320-MARGIN*2
	avatar.labelMax = new Layer
		superLayer: avatar
		x: 0, y:AVATARSIZE-LABELHEIGHT
		width: AVATARSIZE, height: LABELHEIGHT
		backgroundColor: "#e96503", opacity: 0
	avatar.label = new Layer
		superLayer: avatar
		x: 0, y:AVATARSIZE-LABELHEIGHT
		width: AVATARSIZE, height: LABELHEIGHT
		backgroundColor: "transparent",
	avatar.slideLabel = new Layer
		superLayer: avatar
		x: 0, y:0
		width: AVATARSIZE, height: LABELHEIGHT
		backgroundColor: "#e96503", opacity: 0
	avatar.shine = new Layer
		superLayer: avatar.slideLabel
		x: -LABELHEIGHT*1.5, y:0, width: LABELHEIGHT, height: LABELHEIGHT, opacity: 0.75
	avatar.shine.style = background: "linear-gradient(to right, rgba(255,255,255,0) 0%,rgba(255,255,255,1) 100%)"
	avatar.shine.animate
		properties:
			x: avatar.slideLabel.width+LABELHEIGHT*3
		repeat: 100000
		time: 5*LONGANIMTIME
	avatar.labelMax.html = gridAvatar.label.html
	avatar.label.html = gridAvatar.label.html
	avatar.slideLabel.html = "SEND"
	avatar.label.style = LABELSTYLE
	avatar.labelMax.style = LABELSTYLE
	avatar.slideLabel.style = LABELSTYLE
	avatar.label.style = background: "linear-gradient(rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.5))"
	avatar.on Events.DragMove, (e) ->
		avatarRange = [MARGIN, 320-MARGIN*2-DRAWAVATARSIZE]
		drawScreen.drawView.scale = Utils.modulate(avatar.minX
			avatarRange
			[1,(DRAWAVATARSIZE+MARGIN)/320])
		drawScreen.drawView.x = Utils.modulate(avatar.minX
			avatarRange
			[MARGIN,MARGIN+SHEETSIZE*0.5-DRAWAVATARSIZE*0.5])
		drawScreen.drawView.y = Utils.modulate(avatar.minX
			avatarRange
			[568-64-DRAWAVATARSIZE-MARGIN*2-SHEETSIZE,568-64-DRAWAVATARSIZE*1.5-MARGIN*2-SHEETSIZE*0.5])
		avatar.labelMax.x = Utils.modulate(avatar.minX, avatarRange, [DRAWAVATARSIZE+MARGIN, MARGIN])
		avatar.label.x = Utils.modulate(avatar.minX, avatarRange, [DRAWAVATARSIZE+MARGIN, MARGIN])
		avatar.labelMax.width = Utils.modulate(avatar.minX, avatarRange, [LABELWIDTH, DRAWAVATARSIZE])
		avatar.label.width = Utils.modulate(avatar.minX, avatarRange, [LABELWIDTH, DRAWAVATARSIZE])
		avatar.slideLabel.width = Utils.modulate(avatar.minX, avatarRange, [LABELWIDTH, 0])
		avatar.labelMax.opacity = Utils.modulate(avatar.minX, avatarRange, [1,0])
		avatar.label.opacity = Utils.modulate(avatar.minX, avatarRange, [0,1])
		
	avatar.on Events.DragEnd, (e) ->
		avatar.resetPosition()
	
	#SNAP WHEN THE USER LEAVE THE CONTACT SLIDER
	avatar.resetPosition = () ->
		value = Utils.modulate(avatar.x, [MARGIN, SENDPOSITION], [0, 1], true)
		if value < 0.66
			#SNAP BACK
			avatar.draggable.enabled = true
			avatar.ignoreEvents = false
			avatar.animate
				properties: x: MARGIN
			avatar.label.animate
				properties: x: DRAWAVATARSIZE+MARGIN, width: LABELWIDTH, opacity: 0
			avatar.labelMax.animate
				properties: x: DRAWAVATARSIZE+MARGIN, width: LABELWIDTH, opacity: 1
			avatar.slideLabel.animate
				properties: width: LABELWIDTH
			drawScreen.drawView.animate
				properties:
					x: MARGIN, y:568-64-DRAWAVATARSIZE-MARGIN*2-SHEETSIZE, scale: 1
		else
			#SNAP FORWARD
			avatar.draggable.enabled = false
			avatar.ignoreEvents = true
			animTime = Utils.modulate(value, [0.66, 1], [0.2, 0])
			snapAnimation = avatar.animate
				properties:	x: SENDPOSITION
				time: animTime
			avatar.label.animate
				properties:	x: 0, width: DRAWAVATARSIZE, opacity: 1
				time: animTime
			avatar.labelMax.animate
				properties: x: 0, width: DRAWAVATARSIZE, opacity: 0
				time: animTime
			avatar.slideLabel.animate
				properties: width: 0, opacity:0
				time: animTime
			drawScreen.drawView.animate
				properties:
					x: MARGIN+SHEETSIZE*0.5-DRAWAVATARSIZE*0.5
					y: 568-64-DRAWAVATARSIZE*1.5-MARGIN*2-SHEETSIZE*0.5
					scale: DRAWAVATARSIZE/SHEETSIZE
				time: animTime
			snapAnimation.on Events.AnimationEnd, avatar.sendMessage
		
	#ANIMATE THE DRAWING OVER THE CONTACT (SEND MESSAGE FEEDBACK)
	avatar.sendMessage = () ->
		drawScreen.drawView.bringToFront()
		slideAnim = drawScreen.drawView.animate
			properties: y: drawScreen.drawView.y + DRAWAVATARSIZE + MARGIN
			time: LONGANIMTIME
		slideAnim.on Events.AnimationEnd, () ->
			avatar.labelMax.opacity = 0;
			avatar.label.opacity = 1;
			avatar.label.x = 0;
			avatar.label.width = DRAWAVATARSIZE;
			sendAnim = drawScreen.drawView.animate
				properties: opacity: 0, scale: 0
				time: LONGANIMTIME
			sendAnim.on Events.AnimationEnd, () ->
				navbarContactsState()
				avatar.reposition()
				drawScreen.drawView.states.switchInstant "hidden"
			
	avatar.cancelSend = () ->
		layers["back_button"].ignoreEvents = true
		navbarContactsState()
		avatar.reposition()
		avatar.labelMax.animate
			properties:
				x: 0, y: AVATARSIZE-LABELHEIGHT
				width: AVATARSIZE, opacity: 0
			time: LONGANIMTIME
		avatar.slideLabel.animate
			properties:
				x: 0, y: AVATARSIZE-LABELHEIGHT
				width: AVATARSIZE, opacity: 0
			time: LONGANIMTIME
		drawScreen.drawView.animate
			properties: opacity: 0
			time: LONGANIMTIME
		
	#PUT THE AVATAR BACK IN ITS ORIGINAL POSITION (INSIDE THE CONTACTS GRID)
	avatar.reposition = () ->
		repositionAnim = avatar.animate
			properties:
				x: contactsScroll.subLayers[avatar.position].x
				y: contactsScroll.subLayers[avatar.position].y
				width: AVATARSIZE, height: AVATARSIZE
			time: LONGANIMTIME
		avatar.label.animate
			properties:
				x:0, y: AVATARSIZE-LABELHEIGHT, width: AVATARSIZE, opacity:1
			time: LONGANIMTIME
		repositionAnim.on Events.AnimationEnd, showAllContacts
	layers["back_button"].on Events.Click, avatar.cancelSend
	avatar

disableContactsEvents = (event) ->
	for i in this.subLayers
		i.ignoreEvents = true

enableContactsEvents = (event) ->
	for i in this.subLayers
		i.ignoreEvents = false
		i.animate
			properties:
				brightness: 100
				scale: 1
	
downFeedback = (event) ->
	this.bringToFront()
	this.animate
		properties:
			brightness: 150
			scale: 1.2

gridDistance = (posA, posB) ->
	colA = posA % GRIDSIZE
	rowA = (posA / GRIDSIZE) | 0
	colB = posB % GRIDSIZE
	rowB = (posB / GRIDSIZE) | 0
	Math.abs(colA - colB) + Math.abs(rowA - rowB)

#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
#CANVAS METHODS
canvasDown = (e) ->
	mouseX = e.pageX - this.offsetLeft
	mouseY = e.pageY - this.offsetTop
	canvas.paint = true
		
canvasMove = (e) ->
	if canvas.paint
		context.beginPath()
		context.arc e.offsetX, e.offsetY, 20, 0, 2*Math.PI
		context.fill()
		
canvasUp = (e) ->
	canvas.paint = false

canvasClear = () ->
	context.clearRect 0, 0, canvas.width, canvas.height
	
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
#AVATAR CALLBACK: HIDE ALL CONTACTS
hideContactsAndMaximize = (event) ->
	for i in this.superLayer.subLayers
		if i isnt this
			i.states.animationOptions =
				delay: gridDistance(this.position, i.position) * 0.05
			i.states.switch "exiting"
		else
			this.states.switchInstant "exiting"
			this.visible = false
			navbarDrawingState("Invia a "+this.label.html)
			openDrawScreen(this)
			
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
#SHOW ALL CONTACTS AGAIN
showAllContacts = () ->
	contactsScroll.visible = true
	for i in contactsScroll.subLayers
		if i.position isnt drawScreen.avatar.position
			i.states.animationOptions =
				delay: gridDistance(drawScreen.avatar.position, i.position) * 0.05
			i.states.switch "default"
		else
			i.states.switchInstant "default"
			i.visible = true
	drawScreen.avatar.destroy()

#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
#OPEN DRAW SCREEN
openDrawScreen = (clickedAvatar) ->
	canvasClear()
	drawScreen.avatar = makeAvatarForDrawing(clickedAvatar)
	drawScreen.avatar.y = drawScreen.avatar.y + clickedAvatar.superLayer.y - 64
	drawScreen.avatar.superLayer = drawScreen
	avatarAnim = drawScreen.avatar.animate
		properties:
			scale: 1
			x: SENDPOSITION, y: 568-64-MARGIN-DRAWAVATARSIZE
			width: DRAWAVATARSIZE, height: DRAWAVATARSIZE
		delay: SHORTANIMTIME
		time: LONGANIMTIME
	avatarAnim.on Events.AnimationEnd, ->
		drawScreen.avatar.animate
			properties:
				brightness: 100, scale: 1
				x: MARGIN, y: 568-64-MARGIN-DRAWAVATARSIZE
				width: DRAWAVATARSIZE, height: DRAWAVATARSIZE
			time: LONGANIMTIME
	labelMaxAnim = drawScreen.avatar.labelMax.animate
		properties:
			y: DRAWAVATARSIZE-48, width: DRAWAVATARSIZE,
		delay: SHORTANIMTIME
		time: LONGANIMTIME
	labelAnim = drawScreen.avatar.label.animate
		properties:
			y: DRAWAVATARSIZE-48, width: DRAWAVATARSIZE,
		delay: SHORTANIMTIME
		time: LONGANIMTIME
	labelMaxAnim.on Events.AnimationEnd, ->
		drawScreen.avatar.labelMax.animate
			properties:
				x: DRAWAVATARSIZE + MARGIN, y: DRAWAVATARSIZE - 48
				width: 320-DRAWAVATARSIZE-MARGIN*3, opacity: 1
			time: LONGANIMTIME
		drawScreen.avatar.slideLabel.animate
			properties:
				x: DRAWAVATARSIZE + MARGIN, y: 0
				width: 320-DRAWAVATARSIZE-MARGIN*3, opacity: 1
			time: LONGANIMTIME
	labelAnim.on Events.AnimationEnd, ->
		drawScreen.avatar.label.animate
			properties:
				x: DRAWAVATARSIZE + MARGIN, y: DRAWAVATARSIZE - 48
				width: 320-DRAWAVATARSIZE-MARGIN*3, opacity: 0
			time: LONGANIMTIME
	Utils.delay LONGANIMTIME, () ->
		contactsScroll.visible = false
	Utils.delay LONGANIMTIME + SHORTANIMTIME, () ->
		drawScreen.drawView.states.switch "default"

#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
#MAKE LAYERS
mainScreen = new Layer
	x: 0, y: 0, width: 320, height: 568
	backgroundColor: "#e6e6e6"
contactsScroll = new Layer
	x: 0, y: 64, width: 320, height: 0
	backgroundColor: "transparent"

contactsScroll.dragSnap = (event) ->
	snapfactor = AVATARSIZE+MARGIN
	velocity = this.draggable.calculateVelocity()
	clampedVelocity = Math.max(-snapfactor, Math.min(velocity.y*100, snapfactor))
	targetY = Math.round((this.y-64+clampedVelocity)/snapfactor) * snapfactor
	targetY = Math.min(0, Math.max(targetY, -contactsScroll.contentFrame().height + 568 - MARGIN - 64))
	this.animate
		properties:
			y: targetY + 64

contactsScroll.on Events.DragMove, disableContactsEvents
contactsScroll.on Events.DragEnd, contactsScroll.dragSnap
contactsScroll.on Events.DragEnd, enableContactsEvents

mainScreen.addSubLayer contactsScroll
contactsScroll.draggable.enabled = true
contactsScroll.draggable.speedX = 0
mainScreen.sendToBack()

for i in [0..NUMBEROFCONTACTS-1]
	avatar = makeAvatarForGrid(i)
	contactsScroll.addSubLayer avatar
	contactsScroll.height = contactsScroll.contentFrame().height
	avatar.states.animationOptions =
		curve: materialCurveEnter
		delay: gridDistance(0, i) * 0.05
	avatar.states.switch "default"
	avatar.on Events.TouchStart, downFeedback
	avatar.on Events.Click, hideContactsAndMaximize
	
drawScreen = new Layer
	superLayer: mainScreen
	x: 0, y: 64, width: 320, height: 568 - 64
	backgroundColor: "transparent"
	
drawScreen.drawView = new Layer
	superLayer: drawScreen
	x: MARGIN,
	y: 568-64-DRAWAVATARSIZE-MARGIN*2-SHEETSIZE
	width: SHEETSIZE, height: SHEETSIZE
	backgroundColor: "#ffffff"
drawScreen.drawView.shadowY = 2
drawScreen.drawView.shadowBlur = 1
drawScreen.drawView.shadowColor = "rgba(0,0,0,0.3)"

#CREATE CANVAS, ADD LISTENERS
canvas = document.createElement("canvas");
canvas.width = SHEETSIZE
canvas.height = SHEETSIZE
drawScreen.drawView._element.appendChild(canvas);
drawScreen.drawView.ignoreEvents = false
canvas.addEventListener("mousedown", canvasDown, false);
canvas.addEventListener("mousemove", canvasMove, false);
canvas.addEventListener("mouseup", canvasUp, false);
context = canvas.getContext("2d");

drawScreen.drawView.states.add
	hidden: {
		x: MARGIN+SHEETSIZE*0.5
		y: 568-64-DRAWAVATARSIZE-MARGIN*2-SHEETSIZE*0.5,
		scale: 0, opacity: 0
	}
drawScreen.drawView.states.animationOptions =
	curve: materialCurveEnter
	time: LONGANIMTIME
drawScreen.drawView.states.switchInstant "hidden"