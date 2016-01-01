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
    @IBOutlet weak var titulo: UITextView!
    @IBOutlet weak var autores: UITextView!
    @IBOutlet weak var portada: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.textISBN.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func comenzarAEscribir(sender: AnyObject) {
        self.portada.image = nil
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
                do {
                    let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                    if (texto != nil) {
                        self.resultado.text = texto as! String
                        print(texto)
                    }
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let objDiccionario1 = json as! NSDictionary
                    
                    if(objDiccionario1["ISBN:\(isbn)"] != nil) {
                        let objDiccionario2 = objDiccionario1["ISBN:\(isbn)"] as! NSDictionary
                        self.titulo.text = objDiccionario2["title"] as! NSString as String
                    
                        let arregloDiccionariosAutor = objDiccionario2["authors"] as! Array<NSDictionary>
                        var autor = ""
                        var i : Int = 0
                    
                        for diccionarioAutor in arregloDiccionariosAutor {
                            if( i != 0) {
                                autor += ", "
                            }
                            autor += diccionarioAutor["name"] as! NSString as String
                        
                            i++
                        }
                        self.autores.text = autor
                    
                        if(objDiccionario2["cover"] != nil) {
                            let objDiccionario3 = objDiccionario2["cover"] as! NSDictionary
                        
                            let cover = objDiccionario3["large"] as! NSString as String
                        
                            if(cover != "") {
                                if let checkedUrl = NSURL(string: cover) {
                                    portada.contentMode = .ScaleAspectFit
                                    downloadImage(checkedUrl)
                                }
                            }
                        }
                    }
                }
                catch _ {

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
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.portada.image = UIImage(data: data)
            }
        }
    }
    
}

