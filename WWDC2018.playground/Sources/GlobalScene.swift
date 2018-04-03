//
//  GlobalScene
//  WWDC2018
//
//  Copyright © 2018 Bruno Chagas. All rights reserved.
//

import SpriteKit


/// Unique scene used by this project.
public class GlobalScene: SKScene {
    
    // MARK: - Attributes
    
    /// Indicates if menu is open
    public var isOnMenu: Bool = false
    
    /// Rect for the menu frame
    public var menuFrame: CGRect = CGRect()
    
    /// Menu View
    public var menuView: UIView = UIView()
    
    /// This is used to know if the screen is been touched and holded
    public var isHolding: Bool = false
    
    /// Case the user holds a click, the position will be stored in this attribute
    public var positionHolded: CGPoint = CGPoint.zero
    
    /// Indicates if automatic motion is activated
    public var isAutomaticOn: Bool = false
    
    /// This instance will be used to implement singleton in this class.
    private static var scene: GlobalScene = {
        let globalScene = GlobalScene(size: CGSize(width: 500, height: 450))
        globalScene.scaleMode = .aspectFit
        
        return globalScene
    }()
    
    // MARK: - Initialization
    
    private override init(size: CGSize) {
        super.init(size: size)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Class Methods
    
    open class func shared() -> GlobalScene {
        return scene
    }
    
    // MARK: - Touch Object Methods
    
    func touchUp(atPoint pos : CGPoint) {
        if !isOnMenu || isAutomaticOn {
            let circles = CircleFactory.shared().circles
            for circle in circles {
                if circle.shape.contains(pos) {
                    circle.propagateActions()
                }
            }
            
        }
        else if isOnMenu && !isAutomaticOn {
            if !(menuFrame.contains(pos)) {
                openChangablesMenu(UIButton())
            }
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHolding = true
        createNoiseAction()
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHolding = true
        for t in touches { positionHolded = t.location(in: self) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHolding = false
    }
    
    // MARK: - Update
    
    public override func update(_ currentTime: TimeInterval) {
        if isHolding {
            touchUp(atPoint: positionHolded)
        }
        if isAutomaticOn {
            let time = currentTime * 10
            if Int(time) % 3 == 0 {
                let x = CGFloat.random(min: 0, max: (self.view?.frame.size.width)!)
                let y = CGFloat.random(min: 0, max: (self.view?.frame.size.height)!)
                
                touchUp(atPoint: CGPoint(x: x, y: y))
            }
        }
    }
    
    // MARK: - Object Methods
    
    /// Responsable for preparing elements of UI on scene.
    public func prepareView() {
        createChangablesButton()
        createChangablesMenu()
    }
    
    /// Renders on scene a button responsable for opening or closing the changable attributes menu.
    private func createChangablesButton() {
        
        let changablesButtonView = UIView(frame: CGRect(x: (self.view?.frame.size.width)! / 2 - 30, y: (self.view?.frame.size.height)! - 55, width: 60, height: 50))
        changablesButtonView.layer.zPosition = 1000
        changablesButtonView.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.80)
        changablesButtonView.layer.cornerRadius = 10
        changablesButtonView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let changablesButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        changablesButton.addTarget(self, action: #selector(GlobalScene.shared().openChangablesMenu(_:)), for: .touchUpInside)
        changablesButton.setImage(UIImage(named: "BarsIcon")!.withRenderingMode(.alwaysOriginal), for: .normal)
        
        changablesButtonView.addSubview(changablesButton)
        self.view?.addSubview(changablesButtonView)
    }
    
    /// Action to be executed when the menu button is clicked.
    @objc func openChangablesMenu(_ sender: UIButton) {
        if self.isOnMenu == false {
            self.isOnMenu = true
            self.menuView.isHidden = false
        }
        else {
            self.isOnMenu = false
            self.menuView.isHidden = true
        }
    }
    
    /// Renders on scene everything needed for the changable attibutes menu.
    private func createChangablesMenu() {
        
        // Background view
        self.menuFrame = CGRect(x: 30, y: 35, width: (self.view?.frame.size.width)! - 60, height: (self.view?.frame.size.height)! - 90)
        self.menuView = UIView(frame: menuFrame)
        self.menuView.layer.zPosition = 1000
        self.menuView.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.8)
        self.menuView.layer.cornerRadius = 10
        self.menuView.isHidden = true
        self.view?.addSubview(self.menuView)
        
        // Sliders
        let attribute = ChangableAttributes.shared()
        
        let sliderPropagationQuantity = SliderView(frame: CGRect(x: 20, y: 40, width: 180, height: 80), minimumValue: 1, maximumValue: Float(attribute.maxCircles), value: Float(attribute.propagationQuantity), name: "Propagation Quantity", type: .propagationQuantity, format: "%.0f", isRoundNumber: true)
        self.menuView.addSubview(sliderPropagationQuantity)
        
        let sliderRotationSpeed = SliderView(frame: CGRect(x: self.menuView.frame.size.width - 210, y: 40, width: 180, height: 80), minimumValue: 0, maximumValue: 10, value: Float(attribute.rotationSpeed), name: "Rotation Speed", type: .rotationSpeed, format: "%.2f")
        self.menuView.addSubview(sliderRotationSpeed)
    
        let sliderKnockbackDistance = SliderView(frame: CGRect(x: 20, y: 130, width: 180, height: 80), minimumValue: 0, maximumValue: 60, value: Float(attribute.knockbackDistance), name: "Knockback Distance", type: .knockbackDistance, format: "%.2f")
        self.menuView.addSubview(sliderKnockbackDistance)
        
        let sliderKnockbackTime = SliderView(frame: CGRect(x: self.menuView.frame.size.width - 210, y: 130, width: 180, height: 80), minimumValue: 0, maximumValue: 3, value: Float(attribute.knockbackTime), name: "Knockback Time", type: .knockbackTime, format: "%.2f")
        self.menuView.addSubview(sliderKnockbackTime)
        
        let sliderResizeVariation = SliderView(frame: CGRect(x: 20, y: 220, width: 180, height: 80), minimumValue: 0, maximumValue: 1.5, value: Float(attribute.resizeVariation), name: "Resize Variation", type: .resizeVariation, format: "%.2f")
        self.menuView.addSubview(sliderResizeVariation)
        
        let sliderBlendMode = SliderView(frame: CGRect(x: self.menuView.frame.size.width - 210, y: 220, width: 180, height: 80), words: ["Alpha", "Add", "Subtract", "Multiply", "MultiplyX2", "Screen", "Replace"], name: "Blend Mode", positionValue: attribute.blendMode.rawValue, type: .blendMode)
        self.menuView.addSubview(sliderBlendMode)
        
        // Automatic Click
        let automaticClick = SwitchView(frame: CGRect(x: self.menuView.frame.size.width / 2 - 100, y: 300, width: 200, height: 30))
        self.menuView.addSubview(automaticClick)
        
    }
    
    /// Creates the action responsable for running the background song continuously.
    public func createSongAction() {
        let songAction = SKAction.playSoundFileNamed("BackgroundMusic.m4a", waitForCompletion: true)
        let repeatForever = SKAction.repeatForever(songAction)
        self.run(repeatForever)
    }
    
    /// Creates the action responsable for running the sound of a circle being clicked.
    public func createNoiseAction() {
        let noiseAction = SKAction.playSoundFileNamed("Noise.m4a", waitForCompletion: false)
        self.run(noiseAction)
    }
    
}
