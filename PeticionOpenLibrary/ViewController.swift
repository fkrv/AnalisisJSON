//
//  ViewController.swift
//  PeticionOpenLibrary
//
//  Created by Angel Agustín Martínez on 18/12/15.
//  Copyright © 2015 Angel Agustín Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textISBN: UITextField!
    @IBOutlet weak var resultado: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.textISBN.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let texto = textISBN.text
        if(texto != nil && texto?.isEmpty == false) {
            buscar(texto!)
        }
        return true
    }

    func buscar(isbn:String) {
        if (isbn.isEmpty == false) {
            textISBN.resignFirstResponder()
            
            let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
            let url = NSURL(string: urls)

            let datos:NSData? = NSData(contentsOfURL: url!)
            if (datos != nil) {
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                if (texto != nil) {
                    self.resultado.text = texto as! String
                    print(texto)
                }
            } else {
                showSimpleAlert()
            }
        }
    }
    
    /// Show an alert with an "Okay" button.
    func showSimpleAlert() {
        let title = NSLocalizedString("Error de Internet", comment: "")
        let message = NSLocalizedString("No se puede establecer conexión a internet.", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("No se puede establecer conexión a internet.")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

