
import Foundation
import UIKit

@IBDesignable
class BotaoPersonalizado:UIButton{
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
        self.backgroundColor=UIColor(red:0.10, green:0.12, blue:0.28, alpha:1.0)
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
    
}
