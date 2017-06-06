//
//  ReversiModel.swift
//  Reversi
//
//  Created by Admin on 24.02.17.
//  Copyright © 2017 vaervo. All rights reserved.
//

import Foundation

class ReversiModel {
    private var cells: [Cell]
    private var player = CellValue.WHITE
    private let dimension: Int
    
    var currentPlayer : CellValue    { get { return player } }
    var availableCells: [(Int, Int)] { get { return cells.filter { cell in self.isAvailable(x: cell.x, y: cell.y) }.map { cell in (cell.x, cell.y) } } }

    init(withDimenison dimension: Int) {
        self.dimension = dimension
        
        cells = []
        for i in 1...dimension {
            for j in 1...dimension {
                cells.append(Cell(withValue: .EMPTY, onX: i - 1, andY: j - 1))
            }
        }
        getCell(dimension / 2 - 1, dimension / 2 - 1)?.value = .WHITE
        getCell(dimension / 2 - 1, dimension / 2    )?.value = .BLACK
        getCell(dimension / 2    , dimension / 2 - 1)?.value = .BLACK
        getCell(dimension / 2    , dimension / 2    )?.value = .WHITE
    }
    
    init(basedOn parent: ReversiModel, assumingTurn turn: (Int, Int)) {
        var tempCells: [Cell] = []
        parent.cells.forEach { cell in tempCells.append(Cell(withValue: cell.value, onX: cell.x, andY: cell.y)) }
        
        self.cells = tempCells
        self.player = parent.player
        self.dimension = parent.dimension
        
        getCell(turn.0, turn.1)!.value = currentPlayer
        switchPlayer()
    }
    
    func turn(x: Int, y: Int) -> Bool {
        if isAvailable(x: x, y: y) {
            changeCellsFromBestToCell(withX: x, andY: y)
            switchPlayer()
            if (hasAvailableCells()) {
                return false
            } else {
                player = determineWinner()
                return true
            }
        } else {
            return false
        }
    }
    
    func isAvailable(x: Int, y: Int) -> Bool {
        return (getCell(x, y)!.value == .EMPTY) && (findBestForCell(withX: x, andY: y) != nil)
    }
    
    func getCellValue(x: Int, y: Int) -> CellValue {
        return getCell(x, y)!.value
    }
    
    func findCellsToChange(fromCellWithX x: Int, andY y: Int) -> [(Int, Int)] {
        return findCellsToChange(from: findBestForCell(withX: x, andY: y)!, toCellWithX: x, andY: y).map { cell in (cell.x, cell.y) }
    }
    
    func convertedCellScore(_ pair: (Int, Int)) -> Int {
        return getScore(for: getCell(pair.0, pair.1)!)
    }
    
    func newCellScore(_ pair: (Int, Int)) -> Double {
        if (isCorner(pair)) {
            return 0.8
        } else if (pair.0 == 0 || pair.1 == 0 || pair.0 == dimension - 1 || pair.1 == dimension - 1) {
            return 0.4
        } else {
            return 0
        }
    }
    
    private func isCorner(_ pair: (Int, Int)) -> Bool {
        return (pair.0 == 0             && pair.1 == 0            ) ||
               (pair.0 == 0             && pair.1 == dimension - 1) ||
               (pair.0 == dimension - 1 && pair.1 == 0            ) ||
               (pair.0 == dimension - 1 && pair.1 == dimension - 1)
    }
    
    private func hasAvailableCells() -> Bool {
        for cell in cells {
            if isAvailable(x: cell.x, y: cell.y) {
                return true
            }
        }
        return false
    }
    
    private func determineWinner() -> CellValue {
        let totalScores = cells.reduce([CellValue.WHITE : 0, CellValue.BLACK : 0]) { prevRes, cell in
            var res = prevRes
            if let prevScore = res[cell.value] {
                res[cell.value] = prevScore + 1
            }
            return res
        }
        if totalScores[.WHITE]! > totalScores[.BLACK]! {
            return .WHITE
        } else if totalScores[.WHITE]! < totalScores[.BLACK]! {
            return .BLACK
        } else {
            return .EMPTY
        }
    }
    
    private func getCell(_ x: Int, _ y: Int) -> Cell? {
        if (x >= 0 && x < dimension && y >= 0 && y < dimension) {
            return cells[x * dimension + y]
        } else {
            return nil
        }
    }
    
    private func changeCellsFromBestToCell(withX x: Int, andY y: Int) {
        let best = findBestForCell(withX: x, andY: y)! // best is /ourcell/
        let cellsToChange = findCellsToChange(from: best, toCellWithX: x, andY: y)
        for cell in cellsToChange {
            cell.value = currentPlayer
        }
        getCell(x, y)!.value = currentPlayer
    }
    
    private func findCellsToChange(from best: Cell, toCellWithX x: Int, andY y: Int) -> [Cell] {
        var res: [Cell] = []
        if best.x == x {
            for j in getRange(best.y, y) {
                if (j != best.y && j != y) {
                    res.append(getCell(x, j)!)
                }
            }
        } else if best.y == y {
            for i in getRange(best.x, x) {
                if (i != best.x && i != x) {
                    res.append(getCell(i, y)!)
                }
            }
        } else {
            for (i, j) in getDiagonalBetween(best.x, best.y, x, y) {
                if (i != best.x && j != best.y && i != x && j != y) {
                    res.append(getCell(i, j)!)
                }
            }
        }
        return res
    }
    
    private func switchPlayer() {
        switch currentPlayer {
        case .WHITE:
            player = .BLACK
        case .BLACK:
            player = .WHITE
        case .EMPTY:
            print("Something wrong")
        }
    }
    
    private func findBestForCell(withX x: Int, andY y: Int) -> Cell? {
        let (upX,        upY,        upScore       ) = searchFromCell(withX: x, andY: y, inDirection: .Up)        ?? (-1, -1, -1)
        let (upRightX,   upRightY,   upRightScore  ) = searchFromCell(withX: x, andY: y, inDirection: .UpRight)   ?? (-1, -1, -1)
        let (rightX,     rightY,     rightScore    ) = searchFromCell(withX: x, andY: y, inDirection: .Right)     ?? (-1, -1, -1)
        let (downRightX, downRightY, downRightScore) = searchFromCell(withX: x, andY: y, inDirection: .DownRight) ?? (-1, -1, -1)
        let (downX,      downY,      downScore     ) = searchFromCell(withX: x, andY: y, inDirection: .Down)      ?? (-1, -1, -1)
        let (downLeftX,  downLeftY,  downLeftScore ) = searchFromCell(withX: x, andY: y, inDirection: .DownLeft)  ?? (-1, -1, -1)
        let (leftX,      leftY,      leftScore     ) = searchFromCell(withX: x, andY: y, inDirection: .Left)      ?? (-1, -1, -1)
        let (upLeftX,    upLeftY,    upLeftScore   ) = searchFromCell(withX: x, andY: y, inDirection: .UpLeft)    ?? (-1, -1, -1)
        let hightScore = max(upScore, upRightScore, rightScore, downRightScore, downScore, downLeftScore, leftScore, upLeftScore)
        switch hightScore {
        case upScore:
            return getCell(upX, upY)
        case upRightScore:
            return getCell(upRightX, upRightY)
        case rightScore:
            return getCell(rightX, rightY)
        case downRightScore:
            return getCell(downRightX, downRightY)
        case downScore:
            return getCell(downX, downY)
        case downLeftScore:
            return getCell(downLeftX, downLeftY)
        case leftScore:
            return getCell(leftX, leftY)
        case upLeftScore:
            return getCell(upLeftX, upLeftY)
        default:
            print("Something wrong")
            return nil
        }
    }
    
    private func getRange(_ first: Int, _ second: Int) -> CountableClosedRange<Int> {
        if (first < second) {
            return first...second
        } else {
            return second...first
        }
    }
    
    private func getDiagonalBetween(_ firstX: Int, _ firstY: Int, _ secondX: Int, _ secondY: Int) -> [(Int, Int)] {
        var res: [(Int, Int)] = []
        for d in 0...abs(firstX - secondX) {
            let resX: Int
            if (firstX < secondX) {
                resX = firstX + d
            } else {
                resX = firstX - d
            }
            let resY: Int
            if (firstY < secondY) {
                resY = firstY + d
            } else {
                resY = firstY - d
            }
            res.append((resX, resY))
        }
        return res
    }
    
    private func searchFromCell(withX x: Int, andY y: Int, inDirection direction: Direction) -> (Int, Int, Int)? {
        switch direction {
        case .Up:
            /*var i = x - 1
            while i >= 0 && getCell(i, y).value != .EMPTY {
                let cell = getCell(i, y)
                if (cell.value == currentPlayer) {
                    return (i, y, score)
                } else {
                    score += cell.score
                }
                i -= 1
            }*/
            return search(withInitialI: x - 1, andInitialJ: y, usingIMutator: { i in i - 1 }, andJMutator: nil)
        case .UpRight:
            /*var i = x - 1
            var j = y + 1
            while i >= 0 && j < dimension && getCell(i, j).value != .EMPTY {
                let cell = getCell(i, j)
                if (cell.value == currentPlayer) {
                    return (i, y, score)
                } else {
                    score += cell.score
                }
                i -= 1
                j += 1
            }*/
            return search(withInitialI: x-1, andInitialJ: y+1, usingIMutator: {i in i-1}, andJMutator: {j in j+1})
        case .Right:
            return search(withInitialI: x, andInitialJ: y+1, usingIMutator: nil, andJMutator: {j in j+1})
        case .DownRight:
            return search(withInitialI: x+1, andInitialJ: y+1, usingIMutator: {i in i+1}, andJMutator: {j in j+1})
        case .Down:
            return search(withInitialI: x+1, andInitialJ: y, usingIMutator: {i in i+1}, andJMutator: nil)
        case .DownLeft:
            return search(withInitialI: x+1, andInitialJ: y-1, usingIMutator: {i in i+1}, andJMutator: {j in j-1})
        case .Left:
            return search(withInitialI: x, andInitialJ: y-1, usingIMutator: nil, andJMutator: {j in j-1})
        case .UpLeft:
            return search(withInitialI: x-1, andInitialJ: y-1, usingIMutator: {i in i-1}, andJMutator: {j in j-1})
        }
    }
    
    private func search(withInitialI initialI: Int, andInitialJ initialJ: Int, usingIMutator iMutator: ((Int) -> Int)?, andJMutator jMutator: ((Int) -> Int)?) -> (Int, Int, Int)? {
        var i = initialI
        var j = initialJ
        var score = 0
        while getCell(i, j) != nil && getCell(i, j)?.value != .EMPTY {
            let cell = getCell(i, j)!
            if (cell.value == currentPlayer) {
                if score > 0 {
                    return (i, j, score)
                } else {
                    return nil
                }
            } else {
                score += getScore(for: cell)
            }
            if let change = iMutator {
                i = change(i)
            }
            if let change = jMutator {
                j = change(j)
            }
        }
        return nil
    }
    
    private func getScore(for cell: Cell) -> Int {
        if (cell.x == 0 || cell.y == 0 || cell.x == dimension - 1 || cell.y == dimension - 1) {
            return 2
        } else {
            return 1
        }
    }
}

private class Cell {
    var value: CellValue
    let x: Int
    let y: Int
    
    init(withValue value: CellValue, onX x: Int, andY y: Int) {
        self.value = value
        self.x = x
        self.y = y
    }
}

enum CellValue {
    case EMPTY
    case BLACK
    case WHITE
}

private enum Direction {
    case Up
    case UpRight
    case Right
    case DownRight
    case Down
    case DownLeft
    case Left
    case UpLeft
}
