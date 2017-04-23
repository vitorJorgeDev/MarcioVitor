/*
 ***************************************
 Developed by
 Marcio Paulo Soares Oliveira RM 31382
 Vitor Cesar Hideo Jorge      RM 31624
 */

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
