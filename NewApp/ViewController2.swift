//
//  ViewController2.swift
//  NewApp
//
//  Created by Trycatch Classes on 15/02/22.
//


import UIKit

class ViewController2: UIViewController {
        
    @IBOutlet weak var doneEditingButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var executeButton: UIButton!
    
    
    var id = ""
    
    var name = ""
    
    var emailId = ""
    
    var gender = "male"
    
    var status = "active"
    
    var responseArrayVC2: [NSDictionary] = []
    
    var responseArrayPatchVC2: NSDictionary = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nameTextField.becomeFirstResponder()
                
        executeButton.backgroundColor = UIColor.green
        executeButton.layer.cornerRadius = 10
        executeButton.clipsToBounds = true
        
        genderSegmentControl.setFontColorToWhite()
        statusSegmentControl.setFontColorToWhite()
        
        nameTextField.text = name
        
        emailTextField.text = emailId
        
        
        if gender == "male"{
            genderSegmentControl.selectedSegmentIndex = 0
            genderSegmentControl.selectedSegmentTintColor = .systemTeal
        }else {
            genderSegmentControl.selectedSegmentIndex = 1
            genderSegmentControl.selectedSegmentTintColor = .systemPink
        }
        
        if status == "active"{
            statusSegmentControl.selectedSegmentIndex = 0
            statusSegmentControl.selectedSegmentTintColor = UIColor.green
        }else {
            statusSegmentControl.selectedSegmentIndex = 1
            statusSegmentControl.selectedSegmentTintColor = UIColor.red
        }
        
        if self.navigationItem.title == "Add New Record" {
            executeButton.setTitle("Add Record", for: .normal)
        }else{
            executeButton.setTitle("Update Record", for: .normal)
        }
    }
        
    
    @IBAction func doneEditingButtonPressed(_ sender: UIButton) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        }else {
            emailTextField.resignFirstResponder()
        }
    }
    
    @IBAction func genderSegmentControlValueChanged(_ sender: UISegmentedControl) {
                
        if sender.selectedSegmentIndex == 0 {
            genderSegmentControl.selectedSegmentTintColor = UIColor.systemTeal
            gender = "male"
        }else {
            genderSegmentControl.selectedSegmentTintColor = UIColor.systemPink
            gender = "female"
        }
    }
    
    @IBAction func statusSegmentControlValueChanged(_ sender: UISegmentedControl) {
                
        if sender.selectedSegmentIndex == 0 {
            statusSegmentControl.selectedSegmentTintColor = UIColor.green
            status = "active"
        }else {
            statusSegmentControl.selectedSegmentTintColor = UIColor.red
            status = "inactive"
        }
    }
    
    @IBAction func executeButtonPressed(_ sender: UIButton) {
        
        textFieldBlankAlert(sender: sender)
        
    }
    
    
    func textFieldBlankAlert(sender: UIButton){
        
        var alertTitle = ""
        var alertMessage = ""
        if sender.currentTitle == "Add Record" {
            if nameTextField.text == "" && emailTextField.text == "" {
                
                alertTitle = "Enter Name & Email"
                alertMessage = "Kindly enter a name & email id to add into the records."
                
            }else if nameTextField.text == "" {
                
                alertTitle = "Enter a Name"
                alertMessage = "Kindly enter a name to add into the records."
                
            }else if emailTextField.text == "" {
                
                alertTitle = "Enter an Email id"
                alertMessage = "Kindly enter an email id to add into the records."
                
            }else{
                name = nameTextField.text!
                emailId = emailTextField.text!
                print("name : \(name) \n email : \(emailId) \n gender : \(gender) \n status : \(status)")
                callNewApi(isAddButton: true, isUpdateButton: false)
            }
        }else {
            if nameTextField.text == "" && emailTextField.text == "" {
                
                alertTitle = "Enter Name & Email"
                alertMessage = "Kindly enter new name & email id to update into the records."
                
            }else if nameTextField.text == "" {
                
                alertTitle = "Enter a Name"
                alertMessage = "Kindly enter new name to update into the records."
                
            }else if emailTextField.text == "" {
                
                alertTitle = "Enter an Email id"
                alertMessage = "Kindly enter new email id to update into the records."
                
            }else {
                
                name = nameTextField.text!
                emailId = emailTextField.text!
                callNewApi(isAddButton: false, isUpdateButton: true)
            }
        }
        
        if alertTitle != "" && alertMessage != "" {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default) { _ in
                if self.nameTextField.text == "" && self.emailTextField.text == "" {
                    self.nameTextField.becomeFirstResponder()
                }else if self.nameTextField.text == "" || self.emailTextField.text == "" {
                    if self.nameTextField.text == "" {
                        self.nameTextField.becomeFirstResponder()
                    }else {
                        self.emailTextField.becomeFirstResponder()
                    }
                }
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func callNewApi(isAddButton: Bool, isUpdateButton: Bool) {
        //        actIndicator.startAnimating()
//        var alertTitle = ""
//        var alertMessage = ""
        
        var urlString = "https://gorest.co.in/public/v1/users"
        var url = URL(string: urlString)
        
        var urlReq = URLRequest(url: url!)
        
        if isAddButton {
            urlReq.httpMethod = "post"
            let postStr = "access-token=47fecd74178629902153a98ad60964a34d3cd8b89de1defd7e5542f8f15a8491&name=\(name)&email=\(emailId)&gender=\(gender)&status=\(status)"
            urlReq.httpBody = postStr.data(using: .utf8)
            
            URLSession.shared.dataTask(with: urlReq) { data, response, error in
                print("api call done")
                
                if let safeData = data {
                    do{
                        let mainData = try JSONSerialization.jsonObject(with: safeData, options: .mutableContainers) as! NSDictionary
                        if let safeMainData = mainData["data"] as? [NSDictionary] {
                            self.responseArrayVC2 = safeMainData
                            print(self.responseArrayVC2)
                        }
                    }catch{
                        print(error)
                    }
                }
                
                if let safeResponse = response as? HTTPURLResponse {
                    if safeResponse.statusCode == 201 {
                        
                        let alert = UIAlertController(title: "User successfully created.", message: "The user was successfully created and uploaded to server.", preferredStyle: .alert)
                        let createAnotherUser = UIAlertAction(title: "Create Another User", style: .default, handler: nil)
                        
                        let backToHome = UIAlertAction(title: "Back To Home", style: .default) { _ in
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        alert.addAction(createAnotherUser)
                        alert.addAction(backToHome)
                        
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                }
                
                if let safeError = error {
                    print(safeError.localizedDescription)
                }
            }.resume()
            
        }else if isUpdateButton {
            
            urlString = urlString + "/\(id)"
            
            url = URL(string: urlString)
            urlReq = URLRequest(url: url!)
            
            urlReq.httpMethod = "PATCH"
            
            let patchStr = "name=\(name)&email=\(emailId)&gender=\(gender)&status=\(status)"
            urlReq.httpBody = patchStr.data(using: .utf8)
            
            urlReq.allHTTPHeaderFields = ["Authorization":"Bearer 59fa6c69a4e660c85114fbd3073faad70cb1d8d1ee610ff2da8c353e7b565746"]
            
            URLSession.shared.dataTask(with: urlReq) { data, response, error in
                print("api call done")
                
                if let safeData = data {
                    do{
                        if let mainData = try JSONSerialization.jsonObject(with: safeData, options: .mutableContainers) as? NSDictionary{
                            if let safeMainData = mainData["data"] as? NSDictionary {
                                self.responseArrayPatchVC2 = safeMainData
                                print(self.responseArrayPatchVC2)
                            }
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
                
                if let safeResponse = response as? HTTPURLResponse {
                    if safeResponse.statusCode == 200 {
                        
                        let alert = UIAlertController(title: "User successfully updated.", message: "The user was successfully updated and uploaded to server.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default) { _ in
                            
                            self.navigationController?.popViewController(animated: true)
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
            
        }else {
            urlReq.httpMethod = "get"
        }
    }
    
}
extension UISegmentedControl {
    
    func setFontColorToWhite(){
        let defaultAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setTitleTextAttributes(defaultAttributes, for: .selected)
    }
    
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.white)
    {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
}
