//
//  ViewController.swift
//  Reversi
//
//  Created by Admin on 24.02.17.
//  Copyright © 2017 vaervo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var dimension: Int!
    var type: GameType!
    var model: ReversiModel!
    
    @IBOutlet weak var startButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start(_ sender: Any) {
        start()
    }
    
    private func start() {
        showActionSheet(for: "Field size", withVariants: [4, 6, 8, 10], applying: { variant in
            self.dimension = variant
            self.showActionSheet(for: "Game type", withVariants: [GameType.PvP, GameType.PvE(EasyPlayer()), GameType.PvE(HardPlayer())/*, GameType.PvE(HardRecursivePlayer())*/], applying: { variant in
                self.type = variant
                if self.startButton != nil {
                    self.startButton?.isHidden = true
                }
                
                self.model = ReversiModel(withDimenison: self.dimension)
                
                let side = min(self.view.frame.size.width  - 20, self.view.frame.size.height - 20) / CGFloat(self.dimension)
                let xOffset = (self.view.frame.size.width  - CGFloat(self.dimension)*side) / 2
                let yOffset = (self.view.frame.size.height - CGFloat(self.dimension)*side) / 2
                
                
                self.view = UIView(frame: self.view.frame)
                for i in 1...self.dimension {
                    for j in 1...self.dimension {
                        let x   = xOffset + CGFloat(j - 1)*side
                        let y   = yOffset + CGFloat(i - 1)*side
                        let btn = CellButton(line: i - 1, column: j - 1, frame: CGRect(x: x, y: y, width: side, height: side))
                        btn.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                        self.view.addSubview(btn)
                    }
                }
                
                self.redrawField()
            })
        })
    }
    
    private func showActionSheet<Variant>(for title: String, withVariants variants: [Variant], applying apply: @escaping (Variant) -> Void) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        /*let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
            if (completion != nil) {
                completion!()
            }
        })
        controller.addAction(okAction)*/
        for variant in variants {
            let action = UIAlertAction(title: String(describing: variant), style: .default) { (alert:UIAlertAction!) in
                controller.dismiss(animated: true, completion: nil)
                apply(variant)
            }
            controller.addAction(action)
        }
        present(controller, animated: true, completion: nil)
    }
    
    @objc private func buttonAction(_ sender: CellButton) {
        if model.turn(x: sender.x, y: sender.y) {
            redrawField()
            endGame()
        } else {
            redrawField()
            switch type! {
            case .PvP:
                currentPlayerAlert()
            case .PvE(let player):
                sleep(1)
                if (player.turn(model)) {
                    redrawField()
                    endGame()
                } else {
                    redrawField()
                }
            }
        }
    }
    
    private func endGame() {
        var message: String!
        if (model.currentPlayer != .EMPTY) {
            message = "\(model.currentPlayer) wins. Press OK to play again"
        } else {
            message = "Tie! Press OK to play again"
        }
        show(.alert, titled: "Game over", containing: message) {
            self.start()
        }
    }
    
    private func redrawField() {
        for subview in view.subviews {
            if let cellButton = subview as? CellButton {
                if model.isAvailable(x: cellButton.x, y: cellButton.y) {
                    cellButton.backgroundColor = UIColor.green
                } else {
                    switch model.getCellValue(x: cellButton.x, y: cellButton.y) {
                    case .BLACK: cellButton.backgroundColor = UIColor.black
                    case .WHITE: cellButton.backgroundColor = UIColor.white
                    case .EMPTY: cellButton.backgroundColor = UIColor.gray
                    }
                }
            }
        }
        CATransaction.flush()
    }
    
    private func currentPlayerAlert() {
        show(.alert, titled: "Current player", containing: String(describing: model.currentPlayer), completingWith: nil)
    }
    
    private func show(_ style: UIAlertControllerStyle, titled title: String, containing message: String, completingWith completion: (() -> Void)?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
            if (completion != nil) {
                completion!()
            }
        })
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    @objc private func rotated() {
        if dimension != nil {
            let width:  CGFloat
            let height: CGFloat
            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
                height = min(self.view.frame.size.width, self.view.frame.size.height)
                width  = max(self.view.frame.size.width, self.view.frame.size.height)
            } else {
                height = max(self.view.frame.size.width, self.view.frame.size.height)
                width  = min(self.view.frame.size.width, self.view.frame.size.height)
            }
            
            let side = min(width  - 20, height - 20) / CGFloat(self.dimension)
            let xOffset = (width  - CGFloat(self.dimension)*side) / 2
            let yOffset = (height - CGFloat(self.dimension)*side) / 2
            
            print("height: \(height); width: \(width); xOffset: \(xOffset); yOffset: \(yOffset)")
            
            for subview in self.view.subviews {
                if let cellButton = subview as? CellButton {
                    let x = xOffset + CGFloat(cellButton.y)*side
                    let y = yOffset + CGFloat(cellButton.x)*side
                    cellButton.frame = CGRect(x: x, y: y, width: side, height: side)
                }
            }
            
            self.redrawField()
        }
    }
}

private class CellButton: UIButton {
    private let line: Int
    private let column: Int
    
    var x: Int { get { return line   } }
    var y: Int { get { return column } }
    
    init(line x: Int, column y: Int, frame: CGRect) {
        self.line   = x
        self.column = y
        super.init(frame: frame)
        layer.borderWidth = 1
        backgroundColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

