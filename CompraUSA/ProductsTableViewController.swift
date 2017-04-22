
import UIKit
import CoreData

class ProductsTableViewController: UITableViewController {
    
    
    var fetchedResultController: NSFetchedResultsController<Product>!
    var label: UILabel!
    
    // MARK: Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        label.textColor = .black

        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        loadMovies()
       
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "upDate"{
            
            if let vc = segue.destination as? ViewController{
                vc.product = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)

            }
        
        }
  
    }
    
   // MARK: Methods
    func loadMovies() {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        }else{
            tableView.backgroundView = label
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellTableViewCell

        let product = fetchedResultController.object(at: indexPath)
    
        cell.lbProductName.text = product.name
        cell.lbProductPrice.text = product.price
    
        
        
        if let image = product.image as? UIImage {
            cell.imPoster.image = image
           
        }
     
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fetchedResultController.object(at: indexPath)
            context.delete(product)
            do{
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }

}

    // MARK: Extension NSFetchedResultsControllerDelegate
extension ProductsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
