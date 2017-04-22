

import UIKit

@IBDesignable class ProfileIMageView: UIImageView {

   @IBInspectable var cornerRadios: CGFloat = 0 {
        didSet {
            
            self.layer.cornerRadius = cornerRadios
            
        }
        
    }
    
    
    
   @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            
            self.layer.borderWidth = borderWidth
            
        }
        
    }
    
  @IBInspectable  var borderColor: UIColor = .white {
        didSet {
            
            self.layer.borderColor = borderColor.cgColor
            
        }
        
    }
    
    
    
}
