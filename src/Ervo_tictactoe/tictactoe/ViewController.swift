//
//  ViewController.swift
//  tictactoe
//
//  Created by Admin on 17.02.17.
//  Copyright © 2017 vaervo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let model = TicTacToeModel()
    private let labelTextFixedPart = "Current player: "
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = labelTextFixedPart + String(describing: model.currentPlayer)
        
        for fieldButton in findFieldButtons(in: view.subviews) {
            fieldButton.setUp()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFieldButtonPressed(_ sender: FieldButton) {
        if model.turn(x: sender.x!, y: sender.y!) {
            endGame()
        } else {
            redraw()
        }
    }
    
    private func endGame() {
        redraw()
        var message: String!
        if (model.currentPlayer != .Empty) {
            message = "\(model.currentPlayer) wins. Press OK to play again"
        } else {
            message = "Tie! Press OK to play again"
        }
        show(.alert, titled: "Game over", containing: message) {
            self.model.startNewGame()
            self.redraw()
        }
    }
    
    private func redraw() {
        if (model.currentPlayer != .Empty) {
            label.text = labelTextFixedPart + String(describing: model.currentPlayer)
        }
        
        for fieldButton in findFieldButtons(in: view.subviews) {
            fieldButton.value = model.getValueAt(x: fieldButton.x!, y: fieldButton.y!)
        }
    }
    
    private func show(_ style: UIAlertControllerStyle, titled title: String, containing message: String, completingWith completion: @escaping (() -> Void)) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
            completion()
        })
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func findFieldButtons(in collection: [UIView]) -> [FieldButton] {
        var res: [FieldButton] = []
        for view in collection {
            if let fieldButton = view as? FieldButton {
                res.append(fieldButton)
            } else if let stackView = view as? UIStackView {
                res.append(contentsOf: findFieldButtons(in: stackView.subviews))
            }
        }
        return res
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
        //return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}

class FieldButton: UIButton {
    var x: Int?
    var y: Int?
    var value: CellValue? {
        didSet {
            if (value != .Empty) {
                setTitle(String(describing: value!), for: .normal)
            } else {
                setTitle("", for: .normal)
            }
        }
    }
    
    func setUp() {
        x = Int((currentTitle?[0])!)
        y = Int((currentTitle?[1])!)
        value = .Empty
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    }
}
