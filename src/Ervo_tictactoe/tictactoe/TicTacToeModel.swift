//
//  TicTacToeModel.swift
//  tictactoe
//
//  Created by Admin on 17.02.17.
//  Copyright © 2017 vaervo. All rights reserved.
//

import UIKit

class TicTacToeModel: NSObject {
    private var player = CellValue.X
    
    var currentPlayer: CellValue { get { return player } }
    
    private var field = [
        [CellValue.Empty, .Empty, .Empty],
        [CellValue.Empty, .Empty, .Empty],
        [CellValue.Empty, .Empty, .Empty]
    ]
    
    private let winningCombinations = [
        [(0, 0), (0, 1), (0, 2)],
        [(1, 0), (1, 1), (1, 2)],
        [(2, 0), (2, 1), (2, 2)],
        
        [(0, 0), (1, 0), (2, 0)],
        [(0, 1), (1, 1), (2, 1)],
        [(0, 2), (1, 2), (2, 2)],

        [(0, 0), (1, 1), (2, 2)],
        [(0, 2), (1, 1), (2, 0)]
    ]
    
    func turn(x: Int, y: Int) -> Bool {
        if getValueAt(x: x, y: y) != CellValue.Empty {
            return false;
        }
        field[x][y] = player
        if didWin() {
            return true
        } else if isTie() {
            player = .Empty
            return true
        } else {
            switchPlayer()
            return false
        }
    }
    
    func getValueAt(x: Int, y: Int) -> CellValue {
        return field[x][y]
    }
    
    func startNewGame() {
        field = [
            [CellValue.Empty, .Empty, .Empty],
            [CellValue.Empty, .Empty, .Empty],
            [CellValue.Empty, .Empty, .Empty]
        ]
        // winner of the last game starts
        // if tie then X
        if player == .Empty {
            player = .X
        }
    }
    
    private func getValueAt(coordinates: (Int, Int)) -> CellValue {
        return getValueAt(x: coordinates.0, y: coordinates.1)
    }
    
    private func didWin() -> Bool {
        for winningCombination in winningCombinations {
            if didWin(with: winningCombination) {
                return true
            }
        }
        return false
    }
    
    private func didWin(with combination: [(Int, Int)]) -> Bool {
        return getValueAt(coordinates: combination[0]) != CellValue.Empty
            && getValueAt(coordinates: combination[0]) == getValueAt(coordinates: combination[1])
            && getValueAt(coordinates: combination[1]) == getValueAt(coordinates: combination[2])
    }
    
    private func isTie() -> Bool {
        for row in field {
            for cell in row {
                if cell == .Empty {
                    return false
                }
            }
        }
        return true
    }
    
    private func switchPlayer() {
        switch currentPlayer {
        case .O:
            player = .X
        case .X:
            player = .O
        case .Empty:
            print("Something wrong")
        }
    }
}

enum CellValue {
    case Empty
    case X
    case O
}
