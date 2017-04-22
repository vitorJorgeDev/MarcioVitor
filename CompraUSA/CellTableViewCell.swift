

import UIKit

class CellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imPoster: UIImageView!
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbProductPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
