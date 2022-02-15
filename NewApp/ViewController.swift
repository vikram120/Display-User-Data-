//
//  ViewController.swift
//  NewApp
//
//  Created by Trycatch Classes on 15/02/22.
//

import UIKit
//import SVProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
    var responseArray: [NSDictionary] = []
    
    var id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        SVProgressHUD.show(withStatus: "working...")
//        callApi()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callApi()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTVC
        
        if let gender = responseArray[indexPath.row]["gender"] as? String {
            if gender == "male"{
                cell.genderImageView.image = UIImage.init(named: "Male")
            }else{
                cell.genderImageView.image = UIImage.init(named: "Female")
            }
        }
        
        if let name = responseArray[indexPath.row]["name"] {
            cell.nameLabel.text = "\(name)"
        }
        
        if let email = responseArray[indexPath.row]["email"] {
            cell.emailButton.setTitle("\(email)", for: .normal)
        }
        
        if let status = responseArray[indexPath.row]["status"] as? String {
            if status == "active"{
                cell.statusView.backgroundColor = UIColor.green
            }else{
                cell.statusView.backgroundColor = UIColor.red
            }
            
        }
        
        cell.emailButton.addTarget(self, action: #selector(emailButtonpressed(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            let alert = UIAlertController(title: "Would you like to edit this record ?", message: "", preferredStyle: .actionSheet)
            let edit = UIAlertAction(title: "Edit", style: .default) { alertAction in
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2 {
                    vc.navigationItem.title = "Edit Record"
                    vc.id = "\(self.responseArray[indexPath.row]["id"]!)"
                    vc.name = "\(self.responseArray[indexPath.row]["name"]!)"
                    vc.emailId = "\(self.responseArray[indexPath.row]["email"]!)"
                    vc.gender = "\(self.responseArray[indexPath.row]["gender"]!)"
                    vc.status = "\(self.responseArray[indexPath.row]["status"]!)"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(edit)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
            completionHandler(true)
        }
        edit.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            
            let alert = UIAlertController(title: "Would you like to delete this record?", message: "", preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { alertAction in
                
                self.id = "\(self.responseArray[indexPath.row]["id"]!)"
                
                self.callDeleteApi()
                self.mainTableView.reloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
            completionHandler(true)
        }
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2 {
            vc.navigationItem.title = "Add New Record"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func callApi(){
        URLSession.shared.dataTask(with: URL(string: "https://gorest.co.in/public/v2/users?access-token=47fecd74178629902153a98ad60964a34d3cd8b89de1defd7e5542f8f15a8491")!) { data, resp, err in
            print("api call complete \(data)")
            
            if let respData = data{
                do{
                    self.responseArray = try JSONSerialization.jsonObject(with: respData, options: .mutableContainers) as! [NSDictionary]
                    
                    print("Arr Length \(self.responseArray.count)")
                    
                    DispatchQueue.main.async {
                        self.mainTableView.reloadData()
                    }
                    
                    
                }catch{
                    print("Exception")
                    
                }
            }
        }.resume()
    }
    func callDeleteApi() {

        let url = URL(string: "https://gorest.co.in/public/v2/users/\(id)/")
        var urlReq = URLRequest(url: url!)

        urlReq.httpMethod = "DELETE"

        urlReq.allHTTPHeaderFields = ["Authorization":"Bearer 47fecd74178629902153a98ad60964a34d3cd8b89de1defd7e5542f8f15a8491"]

        URLSession.shared.dataTask(with: urlReq) { data, response, error in

            print("api call done")

            if let safeResponse = response as? HTTPURLResponse {

                if safeResponse.statusCode == 204 {
                    let alert = UIAlertController(title: "User successfully deleted.", message: "The user was successfully deleted from server", preferredStyle: .alert)

                    let ok = UIAlertAction(title: "OK", style: .default) { _ in
                        self.callApi()
                    }

                    alert.addAction(ok)

                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }

            if let safeError = error {
                print(safeError.localizedDescription)
            }
        }.resume()

    }
    
    
    @objc func emailButtonpressed(sender: UIButton) {
        if let url = URL(string: "mailto:\(sender.currentTitle!)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Cannot open URL")
                let alert = UIAlertController(title: "Cannot Open Email Client", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

