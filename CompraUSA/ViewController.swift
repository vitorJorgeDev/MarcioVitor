/*
***************************************
Developed by 
Marcio Paulo Soares Oliveira RM 31382
Vitor Cesar Hideo Jorge      RM 31624
*/

import UIKit
import CoreData

@available(iOS 10.0, *)
class ViewController: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var tfStatePurchase: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    @IBOutlet weak var imPoster: UIImageView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var scrolView: UIScrollView!

    var product: Product!
    var smallImage: UIImage!
    var fetchedResultController: NSFetchedResultsController<Product>!
    var stateTax: StateTax!
    var pickerView: UIPickerView!
    var fetchedResultControllerStateTax: NSFetchedResultsController<StateTax>!
    var dataSource: [StateTax]!
    var verification: Bool!

    // MARK: Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        let toolbarPrice = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btDonePrice = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePrice))
        toolbarPrice.items = [btSpace, btDonePrice]
        tfPrice.inputAccessoryView = toolbarPrice
        
        tfStatePurchase.inputView = pickerView
        tfStatePurchase.inputAccessoryView = toolbar

        if product != nil {
            tfProductName.text = product.name
            tfPrice.text = product.price
            
            if let stateTax = product.stateTax{
                tfStatePurchase.text =  stateTax.name
            }
            if product.image != nil {
                smallImage = product.image as! UIImage?
                imPoster.image = smallImage
            }
            swCard.isOn = product.card
            
            btnRegister.setTitle("Atualizar", for: .normal)
            
        }
      
        
        loadStateTax()
        verification = false
        
        
    }
    
    @IBAction func SvBecameFirstRep(_ sender: UITapGestureRecognizer) {
        tfProductName.resignFirstResponder()
        tfPrice.resignFirstResponder()
        tfStatePurchase.resignFirstResponder()
    
    }
    
    // MARK: Methods
    func loadStateTax(){
 
        let fetchRequest: NSFetchRequest<StateTax> = StateTax.fetchRequest()
       
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultControllerStateTax = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            
            try fetchedResultControllerStateTax.performFetch()
            
        }catch{
            print(error.localizedDescription)
        }
      
        dataSource = fetchedResultControllerStateTax.fetchedObjects!
 
    }

    func cancel() {
        tfStatePurchase.resignFirstResponder()
        
    }
    
    func done() {
        verification = true
       
        if dataSource.count != 0{
            tfStatePurchase.text = dataSource[pickerView.selectedRow(inComponent: 0)].name
        }
      
        cancel()
    }
    func donePrice(){
        
        tfPrice.resignFirstResponder()
        
    }
    
    // MARK: Actions
    @IBAction func RegisterProduct(_ sender: UIButton) {
        
        if tfProductName.text == "" || tfPrice.text == "" || tfStatePurchase.text == "" || smallImage == nil{
           showAlert()
        }else{
            if product == nil {
                
                product = Product(context: context)
                
            }

            if let name = tfProductName.text{product.name = name}
            if let price = tfPrice.text{product.price = price}
            product.card = swCard.isOn
            
            if smallImage != nil {
                product.image = smallImage
            }
            
                    
            if verification == true{
                if dataSource.count != 0 {
                product.stateTax = (dataSource[pickerView.selectedRow(inComponent: 0)])
                }
            }

            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }

            _ = navigationController?.popViewController(animated: true)
        }

    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Atenção", message: "Por favor insira todos os intens.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
   
    }
    
    @IBAction func addImage(_ sender: UIButton) {

        let alert = UIAlertController(title: "Selecione a Foto", message: "De onde você quer escolher a imagem?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
        
    }

}

    // MARK: Extension UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if product != nil{
            product.image = smallImage
        }
        imPoster.image = smallImage
        dismiss(animated: true, completion: nil)
    }
}

    // Extension UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return dataSource[row].name
    }

}


    // Extension UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let count = fetchedResultControllerStateTax.fetchedObjects?.count{
            return count
    }
        
        return 0
    }
}
    // Extension UITextFieldDelegate
extension ViewController: UITextFieldDelegate{
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 
            if textField.tag == 0{
                tfStatePurchase.becomeFirstResponder()
            }else if textField.tag == 2 {
                textField.resignFirstResponder()
            }

        return true
    }
}




