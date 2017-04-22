

import UIKit
import CoreData

class TotalPurchaseViewController: UIViewController {

    @IBOutlet weak var lbTotalDolar: UILabel!
    @IBOutlet weak var lbTotalReal: UILabel!
    var fetchedResultController: NSFetchedResultsController<Product>!
    var dataSource: [Product]!

    
    // MARK - System Class
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        var taxValue: Double!
        var price: Double!
        var dolar2: Double!
        var iof2: Double!
        var count2: Int!
        var totalDolarValue: Double = 0
        loadMovies()
        if let _ = fetchedResultController.fetchedObjects?.count {

            let dataSource = fetchedResultController.fetchedObjects
          
  
            if let dolar = UserDefaults.standard.string(forKey: SettingsType.dolar.rawValue){
                dolar2 = Double(dolar)!
            }
            
            if let iof = UserDefaults.standard.string(forKey: SettingsType.iof.rawValue){
                
                iof2 = Double(iof)
            }

            if let count = dataSource?.count{
                
                count2 = count
            }
            
            for i in 0..<count2{
                
                if let stateTax = dataSource?[i].stateTax{
                    taxValue =  stateTax.tax
                }
                
                price = Double((dataSource?[i].price)!)

                var priceWithTax: Double = 0

                if (dataSource?[i].card)!{
                    
                    priceWithTax = price * ((iof2 / 100) + 1) * ((taxValue / 100) + 1)

                    
                }else{
                    
                    priceWithTax = price * ((taxValue / 100) + 1)

                }
                
                totalDolarValue = totalDolarValue + priceWithTax

            }
            lbTotalDolar.text = String(format: "%.2f", totalDolarValue)
            lbTotalReal.text = String(format: "%.2f", (totalDolarValue * dolar2))
            
        }
    }

    
    func loadMovies() {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
 
}
