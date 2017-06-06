//
//  ActionViewController.swift
//  Showcase
//
//  Created by Студент on 01/02/17.
//  Copyright © 2017 hse. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {
    let ALERT  = 0
    let ACTION = 1

    @IBOutlet weak var actionControl: UISegmentedControl!
    @IBOutlet weak var showMeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareShowMeButton()
        prepareGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareShowMeButton() {
        showMeButton.backgroundColor = UIColor(red: 9 / 255.0, green: 95 / 255.0, blue: 134 / 255.0, alpha: 1.0)
        showMeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        showMeButton.layer.cornerRadius = 4.0
    }
    
    func prepareGestures() {
        addSwipeGestureRecognizerForSwipeTo(UISwipeGestureRecognizerDirection.right)
        addSwipeGestureRecognizerForSwipeTo(UISwipeGestureRecognizerDirection.left)
    }
    
    func addSwipeGestureRecognizerForSwipeTo(_ direction: UISwipeGestureRecognizerDirection) {
        let swipeRecogizer = UISwipeGestureRecognizer(target: self, action: #selector(ActionViewController.swiped(_:)))
        swipeRecogizer.direction = direction
        self.view.addGestureRecognizer(swipeRecogizer)
    }
    
    func swiped(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                actionControl.selectedSegmentIndex = ACTION
            case UISwipeGestureRecognizerDirection.left:
                actionControl.selectedSegmentIndex = ALERT
            default:
                break
            }
        }
    }
    
    @IBAction func performAction(_ sender: UIButton) {
        switch actionControl.selectedSegmentIndex {
        case ALERT:
            /*let controller = UIAlertController(title: "This is an alert", message: "You've created an alert view", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (alert:UIAlertAction!) in controller.dismiss(animated: true, completion: nil)
            })
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)*/
            show(UIAlertControllerStyle.alert, titled: "This is an alert", containing: "You've created an alert view")
        case ACTION:
            show(UIAlertControllerStyle.actionSheet, titled: "This is an action sheet", containing: "You've created an action sheet")
        default: break
        }
    }
    
    func show(_ style: UIAlertControllerStyle, titled title: String, containing message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (alert:UIAlertAction!) in controller.dismiss(animated: true, completion: nil)
        })
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
}
