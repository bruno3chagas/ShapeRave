//
//  Extentions
//  WWDC2018
//
//  Copyright © 2018 Bruno Chagas. All rights reserved.
//

import UIKit

extension CGFloat {
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / 0xFFFFFFFF * (max - min) + min
    }
}

extension UIColor {
    public static func randomColor(_ colors: [UIColor]) -> UIColor {
        let numberOfColors = colors.count
        return colors[Int(arc4random_uniform(UInt32(numberOfColors)))]
    }
}
