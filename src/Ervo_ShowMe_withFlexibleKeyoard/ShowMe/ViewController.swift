//
//  ViewController.swift
//  ShowMe
//
//  Created by Admin on 03.02.17.
//  Copyright © 2017 vaervo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textToSendField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        textToSendField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMe(_ sender: UIButton) {
        NSLog("User Wrote: \(textToSendField.text!)")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let messageController = segue.destination as! MessageViewController
        messageController.messageData = textToSendField.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
