//
//  SliderViewController.swift
//  Showcase
//
//  Created by Студент on 01/02/17.
//  Copyright © 2017 hse. All rights reserved.
//

import UIKit

let RED   = "red"
let GREEN = "green"
let BLUE  = "blue"

class SliderViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redValue: UITextField!
    @IBOutlet weak var greenValue: UITextField!
    @IBOutlet weak var blueValue: UITextField!
    
    /*var redColor  : CGFloat = 1.0
    var greenColor: CGFloat = 1.0
    var blueColor : CGFloat = 1.0*/
    
    var colors:[String : CGFloat] = [
        RED  : 1.0,
        GREEN: 1.0,
        BLUE : 1.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redValue.delegate = self
        greenValue.delegate = self
        blueValue.delegate = self
        updateColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func changeRed(_ sender: UISlider) {
        /*redColor = CGFloat(redSlider.value)
        redValue.text = String(format: "%.0f", Float(redColor*255.0))
        updateColor()*/
        change(colorNamed: RED, usingValueFrom: redSlider, andUpdate: redValue)
    }

    @IBAction func changeGreen(_ sender: UISlider) {
        change(colorNamed: GREEN, usingValueFrom: greenSlider, andUpdate: greenValue)
    }
    
    @IBAction func changeBlue(_ sender: UISlider) {
        change(colorNamed: BLUE, usingValueFrom: blueSlider, andUpdate: blueValue)
    }
    
    func change(colorNamed colorName: String, usingValueFrom slider: UISlider, andUpdate value: UITextField) {
        let color = CGFloat(slider.value)
        colors[colorName] = color
        value.text = String(format: "%.0f", Float(color*255.0))
        updateColor()
    }
    
    func updateColor() {
        view.backgroundColor = UIColor(red: colors[RED]!, green: colors[GREEN]!, blue: colors[BLUE]!, alpha: 1.0)
    }
}

