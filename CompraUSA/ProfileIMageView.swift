/*
 ***************************************
 Developed by
 Marcio Paulo Soares Oliveira RM 31382
 Vitor Cesar Hideo Jorge      RM 31624
 */

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
