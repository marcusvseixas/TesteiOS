//
//  ContatoViewController.swift
//  TesteiOS
//
//  Created by marcus.v.seixas on 04/05/18.
//  Copyright (c) 2018 marcus.v.seixas. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ContatoDisplayLogic: class
{
  func displaySomething(viewModel: Contato.Something.ViewModel)
}

class ContatoViewController: UIViewController, ContatoDisplayLogic, UITextFieldDelegate
{
  var interactor: ContatoBusinessLogic?
  var router: (NSObjectProtocol & ContatoRoutingLogic & ContatoDataPassing)?
  let formLink = "https://floating-mountain-50292.herokuapp.com/cells.json"
    var formDict = [NSDictionary]()
    var phoneValid:Bool = false
    @IBOutlet weak var nameMessageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var addEmailCheckBox: CCheckbox!
    @IBOutlet weak var addEmailLabel: UILabel!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    // MARK: Object lifecycle
    
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = ContatoInteractor()
    let presenter = ContatoPresenter()
    let router = ContatoRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
    self.tabBarItem = UITabBarItem(title: "Contato", image: nil, selectedImage: nil)
    getJsonFromUrl()
   

  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    addEmailCheckBox.delegate = self
    telephoneTextField.delegate = self
    self.addEmailCheckBox.normalImage = UIImage(named: "ic_checkbox_empty")
    self.addEmailCheckBox.selectedImage = UIImage(named: "ic_checkbox_selected")
    doSomething()
  }
    
  func doSomething()
  {
    let request = Contato.Something.Request()
    interactor?.doSomething(request: request)
  }

  func displaySomething(viewModel: Contato.Something.ViewModel)
  {
    for cell in formDict{
        switch (cell.value(forKey: "id") as! Int){
        case 1:
            //name message
            self.nameMessageLabel.text = cell.value(forKey: "message") as? String
            break
        case 2:
            //name
            self.nameLabel?.text = cell.value(forKey: "message") as? String
            self.nameTextField.setBottomBorder(textfield: nameTextField)
            break
        case 3:
            //email checkbox
            self.addEmailLabel?.text = cell.value(forKey: "message") as? String
            break
        case 4:
            //email
            self.emailLabel?.text = cell.value(forKey: "message") as? String
            self.emailLabel?.isHidden = (cell.value(forKey: "hidden") as? Bool)!
            self.emailTextField?.isHidden = (cell.value(forKey: "hidden") as? Bool)!
            self.emailTextField.setBottomBorder(textfield: emailTextField)
            break
        case 6:
            //telephone
            self.telephoneLabel?.text = cell.value(forKey: "message") as? String
            self.telephoneTextField.setBottomBorder(textfield:  telephoneTextField)
            break
        case 7:
            //send button
            self.sendButtonOutlet.setTitle(cell.value(forKey: "message") as? String, for: UIControlState.normal)
            self.sendButtonOutlet.layer.cornerRadius = 25
            self.sendButtonOutlet.clipsToBounds = true
            break
        default:
            break
        }
    }
    //nameTextField.text = viewModel.name
  }
  func getJsonFromUrl(){
        //creating a NSURL
        let url = NSURL(string: formLink)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                self.formDict = jsonObj!.value(forKey: "cells")! as! [NSDictionary]
            }
        }).resume()
    }
    
// MARK: TextField functions
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var fullString = textField.text ?? ""
        fullString.append(string)
        //only digits
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        let test = allowedCharacters.isSuperset(of: characterSet)
        //format telephone number
        if range.length == 1 {
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
        } else if (test){
            textField.text = format(phoneNumber: fullString)
        }
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count >= 11 {
            let eleventhDigitIndex = number.index(number.startIndex, offsetBy: 11)
            number = String(number[number.startIndex..<eleventhDigitIndex])
        }
        
        if number.count > 10 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{2})(\\d{5})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
            
            phoneValid = true
        } else if (number.count == 10){
            phoneValid = true
        } else {
             phoneValid = false
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{2})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{2})(\\d{4})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

// MARK: Send Action
    @IBAction func sendButton(_ sender: UIButton) {
        var textValid :Bool = true
        self.view.endEditing(true)
        for cell in formDict{
        if ((cell.value(forKey: "required") as! Bool)) {
            switch (cell.value(forKey: "id") as! Int){
            case 2:
                // name
                if let text = self.nameTextField.text, text.isEmpty {
                    self.nameTextField.setBottomBorderRed()
                    textValid = false
                } else {
                    self.nameTextField.setBottomBorderGreen()
                }
                break
            case 4:
                // email
                if !self.emailTextField.isHidden {
                if let text = self.emailTextField.text, text.isEmpty {
                    self.emailTextField.setBottomBorderRed()
                    textValid = false
                } else {
                    if isValidEmail(testStr: self.emailTextField.text!){
                        self.emailTextField.setBottomBorderGreen()
                    } else {
                        self.emailTextField.setBottomBorderRed()
                        textValid = false
                    }
                }
                }
                break
            case 6:
                // telephone
                if let text = self.telephoneTextField.text, text.isEmpty {
                    self.telephoneTextField.setBottomBorderRed()
                    textValid = false
                } else if (phoneValid){
                    self.telephoneTextField.setBottomBorderGreen()
                } else {
                    self.telephoneTextField.setBottomBorderRed()
                }
                break
            default: break
            }
        }
            
        }
        if textValid {
            
        }
        
    }
}

// MARK: TextField Style

extension UITextField {
    
    func setBottomBorder(textfield: UITextField) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        textfield.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func setBottomBorderRed(){
        self.layer.shadowColor = UIColor.red.cgColor
    }
    func setBottomBorderGreen(){
        self.layer.shadowColor = UIColor.green.cgColor
    }
}
// MARK: Checkbox Functions
extension ContatoViewController: CheckboxDelegate {
    func didDeselect(_ checkbox: CCheckbox) {
        self.emailLabel.isHidden = true
        self.emailTextField.isHidden = true
        self.emailTextField.setBottomBorder(textfield: self.emailTextField)
        self.emailTextField.text = ""
    }
    
    func didSelect(_ checkbox: CCheckbox) {
        self.emailLabel.isHidden = false
        self.emailTextField.isHidden = false

        }
}
