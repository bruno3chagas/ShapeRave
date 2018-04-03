//
//  SwitchView
//  WWDC2018
//
//  Copyright © 2018 Bruno Chagas. All rights reserved.
//

import UIKit

/// Personalized view containing a UISwitch.
public class SwitchView: UIView {

    // MARK: - Attribures
    
    public var label: UILabel
    public var switchComponent: UISwitch
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 30))
        self.label.text = "Automatic Motion"
        self.label.textColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.label.textAlignment = .left
        self.label.font = UIFont.systemFont(ofSize: 16)
        self.label.adjustsFontSizeToFitWidth = true
        
        self.switchComponent = UISwitch(frame: CGRect(x: 140, y: 0, width: 60, height: 30))
        self.switchComponent.contentVerticalAlignment = .center
        self.switchComponent.contentHorizontalAlignment = .center
        self.switchComponent.tintColor = .white
        
        super.init(frame: frame)
        
        self.switchComponent.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        self.addSubview(self.label)
        self.addSubview(self.switchComponent)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Object Methods
    
    /// Executes a routine when a switch is toggled.
    @objc func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            GlobalScene.shared().isAutomaticOn = true
        }
        else {
            GlobalScene.shared().isAutomaticOn = false
        }
    }
}
