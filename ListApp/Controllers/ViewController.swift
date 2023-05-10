import UIKit

class ViewController: UIViewController {
    
    var alertController = UIAlertController()
 
    
    @IBOutlet weak var tableView : UITableView!
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
                self.data.append((text)!)
                self.tableView.reloadData()
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
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal
                                              , title: "Sil") { _, _, _ in
            self.data.remove(at: indexPath.row)
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
                    self.data[indexPath.row] = text!
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

