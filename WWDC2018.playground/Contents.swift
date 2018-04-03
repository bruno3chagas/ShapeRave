import PlaygroundSupport
import SpriteKit

/*:
 # Shape Rave

 Welcome to **Shape Rave**! This is a purely visual and interactive experience on which you can cause an effect to circles and their actions. Here are the interactions you can have with this scene:
 
 * **Touch**, **Hold** or **Drag** through the circles.
 
 * Toggling **Automatic Motion** will do the job of clicking for you. Activate this on the menu to see the changes you made in the attributes in realtime.
 
 * Some stuff here are generated randomly, so the scene will always be different when restarted.
 
 * There is a menu with properties you can change. Keep in mind most of the attributes are only seen when an interaction with a circle occurs, so I recommend toggling **Automatic Motion** to see the effect of each attribute.
 
 ## Keep in mind:
 The most important thing here is not to be afraid of clicking and testing new combinations.
 */
//: Case you have any doubts on what each attibute do, you can consult the list bellow.
let attributes = ChangableAttributes.shared()
//: **Maximum Circles**: This is the amount of circles that will be loaded on the scene. **You can change the value of this attribute before the scene starts, but I recommend letting it to 60**.
attributes.maxCircles = 60

//: **Propagation Quantity**: This property will influentiate on the wave effect, it indicates the amount of circles will recieve interaction per time.
attributes.propagationQuantity = 5

//: **Rotation Speed**: The circles have a perpetual eliptical movement, this property changes the velocity of this movement.
attributes.rotationSpeed = 1

//: **Knockback Distance**: This is the distance the circles are pushed when one is touched.
attributes.knockbackDistance = 20

//: **Knockback Time**: This is the time it takes for the circles to finish the knockback action when one is touched.
attributes.knockbackTime = 0.3

//: **Blend Mode**: This changes the blending mode used to mix the colors between layers.
attributes.blendMode = .screen

//: **Resize Variation**: When the circles suffer knockback, they also receive a resize. The smaller the number, the smaller circles will be when an interaction happens.
attributes.resizeVariation = 1.1




// Code you shouldn't interact with.
CircleFactory.shared()
let sceneView =  SKView(frame: CGRect(x: 0 , y: 0, width: 500, height: 450))
sceneView.presentScene(GlobalScene.shared())
GlobalScene.shared().prepareView()
GlobalScene.shared().createSongAction()
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView


