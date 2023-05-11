import UIKit
import CoreData

class ViewController: UIViewController {
    
    var alertController = UIAlertController()
    
    
    @IBOutlet weak var tableView : UITableView!
    
    var data = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        fetch()
    }
    
    @IBAction func removeButtonTapped(_ sender : UIBarButtonItem){
        presentAlert(title: "Uyarı!", message: "Listedeki bütün öğeleri silmek istediğinize emin misinz?",
                     defaultButtonTitle: "Evet",
                     cancelButtonTitle: "İptal") {
            _ in
            self.data.removeAll()
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func addButtonTapped(_ sender : UIBarButtonItem){
        print("deneme")
        presentAddAlert()
        
    }
    func presentAddAlert(){
        presentAlert(title: "Yeni içerik gir",
                     message: "",
                     defaultButtonTitle: "Ekle",
                     cancelButtonTitle: "Vazgeç",
                     isTextfieldAvaible: true,
                     defaultButtonHandler: { _ in
            let text = self.alertController.textFields?.first?.text
            if text != ""{
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedObjectContext!)
                
                let listItem = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                
                listItem.setValue(text, forKey: "title")
                
                try? managedObjectContext?.save()
                
                
                self.fetch()
            } else {
                self.presentWarningAlert()
            }
        }
        )
    }
    func presentWarningAlert(){
        presentAlert(title: "Uyarı",
                     message: "Boş içerik giremezsiniz!",
                     cancelButtonTitle: "Tamam")
    }
    func presentAlert(title: String?,
                      message: String?,
                      prefferredStyle: UIAlertController.Style = .alert,
                      defaultButtonTitle : String? = "",
                      cancelButtonTitle : String?,
                      isTextfieldAvaible : Bool = false,
                      defaultButtonHandler : ((UIAlertAction) -> Void)? = nil
                      
    ){
        alertController = UIAlertController(title: title, message: message, preferredStyle: prefferredStyle)
        
        if defaultButtonTitle != "" {
            let defaultButton = UIAlertAction(title: defaultButtonTitle,
                                              style: .default,
                                              handler: defaultButtonHandler
            )
            alertController.addAction(defaultButton)
        }
        
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel)
        
        if isTextfieldAvaible{
            alertController.addTextField()
        }
        present(alertController, animated: true)
        
        alertController.addAction(cancelButton)
    }
    
    func fetch(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        
        data = try! managedObjectContext!.fetch(fetchRequest)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal
                                              , title: "Sil") { _, _, _ in
            // self.data.remove(at: indexPath.row)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            
            managedObjectContext?.delete(self.data[indexPath.row])
            
            try? managedObjectContext?.save()
            
            self.fetch()
            
            tableView.reloadData()
        }
        
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { _, _, _ in
            
            self.presentAlert(title: "İçeriği Düzenle",
                         message: "",
                         defaultButtonTitle: "Düzenle",
                         cancelButtonTitle: "Vazgeç",
            isTextfieldAvaible: true,
                         defaultButtonHandler: { _ in
                let text = self.alertController.textFields?.first?.text
                if text != ""{
                    
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    
                    let managedObjectContext = appDelegate?.persistentContainer.viewContext
                    
                    self.data[indexPath.row].setValue(text, forKey: "title")
                    
                    if managedObjectContext!.hasChanges {
                        try? managedObjectContext?.save()
                    }
                    
                    self.tableView.reloadData()
                } else {
                    self.presentWarningAlert()
                }
        }
)}
                              
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return config
    }
}

