//
//  ComputerPlayer.swift
//  Reversi
//
//  Created by Admin on 25.02.17.
//  Copyright © 2017 vaervo. All rights reserved.
//

import Foundation

protocol ComputerPlayer {
    func turn(_ model: ReversiModel) -> Bool
}

private func defaultTurn(_ model: ReversiModel, _ score: ((Int, Int), ReversiModel) -> Double) -> Bool {
    let bestPair = model.availableCells.max { score($0, model) < score($1, model) }
    return model.turn(x: (bestPair?.0)!, y: (bestPair?.1)!)
}

private func easyScore(_ pair: (Int, Int), _ model: ReversiModel) -> Double {
    return Double(model.findCellsToChange(fromCellWithX: pair.0, andY: pair.1).reduce(0) { prevRes, nextPair in prevRes + model.convertedCellScore(nextPair) }) + model.newCellScore(pair)
}

class EasyPlayer: ComputerPlayer {
    internal func turn(_ model: ReversiModel) -> Bool {
        return defaultTurn(model, easyScore)
    }
}

class HardPlayer: ComputerPlayer {
    internal func turn(_ model: ReversiModel) -> Bool {
        return defaultTurn(model) { pair, model in
            let res = easyScore(pair, model)
            let newModel = ReversiModel(basedOn: model, assumingTurn: pair)
            if let bestPair = newModel.availableCells.max(by: { easyScore($0, newModel) < easyScore($1, newModel) }) {
                return res - easyScore(bestPair, newModel)
            } else {
                return res
            }
        }
    }
}

class HardRecursivePlayer: ComputerPlayer {
    internal func turn(_ model: ReversiModel) -> Bool {
        return defaultTurn(model, recursiveScore)
    }
    
    private func recursiveScore(_ pair: (Int, Int), _ model: ReversiModel) -> Double {
        let res = easyScore(pair, model)
        let newModel = ReversiModel(basedOn: model, assumingTurn: pair)
        if let bestPair = newModel.availableCells.max(by: { recursiveScore($0, newModel) < recursiveScore($1, newModel) }) {
            return res - recursiveScore(bestPair, newModel)
        } else {
            return res
        }
    }
}

enum GameType {
    case PvP
    case PvE(ComputerPlayer)
}
