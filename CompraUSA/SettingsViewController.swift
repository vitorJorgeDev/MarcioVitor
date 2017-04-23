/*
 ***************************************
 Developed by
 Marcio Paulo Soares Oliveira RM 31382
 Vitor Cesar Hideo Jorge      RM 31624
 */

import UIKit
import CoreData

enum SettingsType: String{
    
    case dolar = "dolar"
    case iof = "iof"
}

enum CategoryAlertType {
    case add
    case edit
}
class SettingsViewController: UIViewController {
    
    // MARK: Outtlet's
    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var tfIosValue: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var OkButton: UIAlertAction!
    var fetchedResultController: NSFetchedResultsController<StateTax>!
    var stateTax: StateTax!
    var dataSource: [StateTax] = []
    var label: UILabel!
    var lettersValidation1: [Character] = []
    var lettersValidation2: [Character] = []
    var count1: Int = 0
    var count2: Int = 0
    
    // MARK: Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
        label.text = "Lista de Estados vazia!"
        label.textAlignment = .center
        label.textColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        loadStateTax()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDonePrice = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePrice))
        toolbar.items = [btSpace, btDonePrice]
        tfIosValue.inputAccessoryView = toolbar
        tfDolar.inputAccessoryView = toolbar
        
        if let dolar = UserDefaults.standard.string(forKey: SettingsType.dolar.rawValue){
            tfDolar.text = dolar
        }
        
        if let iof = UserDefaults.standard.string(forKey: SettingsType.iof.rawValue){
            
            tfIosValue.text = iof
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if (tfDolar.text == "") || (tfIosValue.text == ""){
            
            UserDefaults.standard.set("1", forKey: SettingsType.dolar.rawValue)
            UserDefaults.standard.set("0", forKey: SettingsType.iof.rawValue)
            
        }else{
            UserDefaults.standard.set(tfDolar.text, forKey: SettingsType.dolar.rawValue)
            UserDefaults.standard.set(tfIosValue.text, forKey: SettingsType.iof.rawValue)
        }
        
        
    }
    
    // MARK: Methods
    func donePrice(){
        tfDolar.resignFirstResponder()
        tfIosValue.resignFirstResponder()
        
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func loadStateTax(){
        
        let fetchRequest: NSFetchRequest<StateTax> = StateTax.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do{
         
            try fetchedResultController.performFetch()
            
        }catch{
            print(error.localizedDescription)
        }

    }
    
    // MARK: Actions
    @IBAction func addStateTax(_ sender: UIButton?) {
        count1 = 0
        count2 = 0
        lettersValidation1.removeAll()
        lettersValidation2.removeAll()
      
        let alert = UIAlertController(title: "Digite o nome da Cidade", message: nil, preferredStyle: .alert)
        OkButton = UIAlertAction(title: "Salvar", style: .default) { (action: UIAlertAction) in
            if sender != nil{
                
                self.stateTax = StateTax(context: self.context)
                
            }
            
            self.stateTax.name = alert.textFields!.first!.text
            
            self.stateTax.tax = Double((alert.textFields!.last!.text)!)!
            
            do{
                try self.context.save()
                
                
            }catch{
                print(error.localizedDescription)
            }
            
            self.loadStateTax()
        }
        
        
        alert.addTextField { (textField: UITextField) in
            
            if sender == nil{
                textField.text = self.stateTax.name
                let string: String = self.stateTax.name!
                let characters = Array(string.characters)
                self.lettersValidation1 = characters
                self.count1 = characters.count
            }
            textField.placeholder = "Insira o nome da Cidade"
           
            textField.tag = 2
            textField.delegate = (self as UITextFieldDelegate)
          

        }
        alert.addTextField { (textField: UITextField) in
            if sender == nil{
                textField.text = String(self.stateTax.tax)
                let string: String = String(self.stateTax.tax)
                let characters = Array(string.characters)
                self.lettersValidation2 = characters
                self.count2 = characters.count      
            }
            textField.placeholder = "Insira o valor da taxa"
            textField.keyboardType = .decimalPad
            textField.tag = 3
            
            textField.delegate = (self as UITextFieldDelegate)

        }
        OkButton.isEnabled = false
        
        alert.addAction(OkButton)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
        
    }

}


    // MARK: Extension UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = fetchedResultController.fetchedObjects?.count{
            tableView.backgroundView = (count == 0) ? label : nil
            
            return count
        }else{
            
            tableView.backgroundView = label
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        
        
        let stateTaxTable = fetchedResultController.object(at: indexPath)
        cell.textLabel?.text = stateTaxTable.name
        cell.detailTextLabel?.textColor = .red
        cell.detailTextLabel?.text = String(stateTaxTable.tax)
      
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{

            let alert = UIAlertController(title: "Atenção", message: "Todos produtos relacionados a esse estado serão excluidos. Deseja excluir?", preferredStyle: .alert)
            let okAlert = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                let stateTax: StateTax = self.fetchedResultController.object(at: indexPath)
                self.context.delete(stateTax)
                do{
                    try self.context.save()
                }catch{
                    print(error.localizedDescription)
                }

            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAlert)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
            
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        stateTax = fetchedResultController.object(at: indexPath)
        addStateTax(nil)
    }
    
}

    // MARK: Extension NSFetchedResultsControllerDelegate
extension SettingsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

}
    // MARK: Extension UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

       if textField.tag == 2 {
        if string.isEmpty{
            count1 = count1 - 1
            lettersValidation1.remove(at: count1)
            
        }else{
            lettersValidation1.append(Character(string))
            count1 = count1+1
            
            }
       }else if textField.tag == 3{
        if string.isEmpty{
            count2 = count2 - 1
            lettersValidation2.remove(at: count2)
            
        }else{
            lettersValidation2.append(Character(string))
            count2 = count2+1
            
            }
        
        }
        
        if !lettersValidation1.isEmpty && !lettersValidation2.isEmpty{
            OkButton.isEnabled = true
        }else{
            OkButton.isEnabled = false
        }
    
        return true
    }

}


