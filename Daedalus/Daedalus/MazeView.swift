//
//  MazeView.swift
//  Daedalus
//
//  Created by Eric Eddy on 2017-02-07.
//  Copyright © 2017 ericeddy. All rights reserved.
//

import UIKit

class MazeView: UIView {
    
    var navBar = UINavigationBar()
    
    var cells = [[Cell]]()
    var frontier = [Cell]()
    var userPath = [Cell]()
    var solutionPath = [Cell]()
    var paths = [[Cell]]()
    var searchedPath = [Cell]()
    var vCN:Int = 0
    var hCN:Int = 0
    var cellSize = CGFloat(16)
    let rbMax:Int = 100
    
    let solveBtn = UINavigationItem(title: "Daedalus")
    
    var beginPath:UIBezierPath? = nil
    var endPath:UIBezierPath? = nil
    
    var animating = false
    var mazeReady = false
    var userSolved = false
    var isIPad = false
    
    convenience init(frame: CGRect, vCell: Int, hCell: Int) {
        self.init(frame: frame)
        vCN = vCell
        hCN = hCell
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        clearsContextBeforeDrawing = true
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            //cellSize = CGFloat(32)
            //isIPad = true
        }
        
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 64))
        navBar.barStyle = .default
        
        solveBtn.rightBarButtonItems = [UIBarButtonItem](arrayLiteral:
            UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(doSolve)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(redo)))
        navBar.items = [solveBtn]
        
        addSubview(navBar)
        
        //addSwipe()
        
        makeMaze()
    }
    
    func addSwipe() {
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
            gesture.direction = direction
            self.addGestureRecognizer(gesture)
        }
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        if mazeReady {
            switch sender.direction {
            case UISwipeGestureRecognizerDirection.up:
                userMove(Direction.North)
                break
            case UISwipeGestureRecognizerDirection.down:
                userMove(Direction.South)
                break
            case UISwipeGestureRecognizerDirection.right:
                userMove(Direction.East)
                break
            case UISwipeGestureRecognizerDirection.left:
                userMove(Direction.West)
                break
            default: break
            }
        }
    }
    
    func userMove(_ d: Direction) {
        let lastCell = userPath[userPath.count - 1]
        var nextCell = Cell()
        var w  = 0
        switch d {
        case .North:
            if !lastCell.walls[0] || lastCell.y - 1 < 0 { return }
            nextCell = cells[lastCell.y - 1][lastCell.x]
            w = 0
            break
        case .South:
            if !lastCell.walls[1] || lastCell.y + 1 >= vCN { return }
            nextCell = cells[lastCell.y + 1][lastCell.x]
            w = 1
            break
        case .East:
            if !lastCell.walls[2] || lastCell.x + 1 >= hCN { return }
            nextCell = cells[lastCell.y][lastCell.x + 1]
            w = 2
            break
        case .West:
            if !lastCell.walls[3] || lastCell.x - 1 < 0 { return }
            nextCell = cells[lastCell.y][lastCell.x - 1]
            w = 3
            break
        }
        
        if nextCell.userTravelled {
            
            lastCell.userTravelled = false
            lastCell.rnbw = -2
            cells[lastCell.y][lastCell.x] = lastCell
            
            userPath.removeLast()
            /*
            if nextCell.hasCorridors() || !nextCell.walls[w] {
                // Stop Moving
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    print("Wall/Junction Hit, Stop Slide")
                    self.setNeedsDisplay()
                })
            } else {
                var keepGoing = true
                var i = 1
                while keepGoing {
                    let anotherCell = getCellDistanceFromCell(nextCell, direction: d, distance: i)
              
                    if anotherCell != nil {
                        let priorCell = getCellDistanceFromCell(nextCell, direction: d, distance: i-1)
                        
                        priorCell!.userTravelled = false
                        cells[priorCell!.y][priorCell!.x] = priorCell!
                        
                        userPath.removeLast()
                        
                        if anotherCell!.hasCorridors() || !anotherCell!.walls[w] { keepGoing = false }
                    } else {
                        keepGoing = false
                    }
                    i += 1
                }*/
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    //print("Wall/Junction Hit, Stop Slide")
                    self.setNeedsDisplay()
                })/*
            }
            */
        } else {
            nextCell.userTravelled = true
            cells[nextCell.y][nextCell.x] = nextCell
            userPath.append(nextCell)
            
            /*
            if nextCell.hasCorridors() || !nextCell.walls[w] {
                // Stop Moving
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    print("Wall/Junction Hit, Stop Slide")
                    self.setNeedsDisplay()
                })
            } else {
                // Continue Moving
                var keepGoing = true
                var i = 1
                while keepGoing {
                    let anotherCell = getCellDistanceFromCell(nextCell, direction: d, distance: i)
                    if anotherCell != nil {
                        anotherCell!.userTravelled = true
                        cells[anotherCell!.y][anotherCell!.x] = anotherCell!
                        
                        userPath.append(anotherCell!)
                        
                        if anotherCell!.hasCorridors() || !anotherCell!.walls[w] { keepGoing = false }
                    } else {
                        keepGoing = false
                    }
                    i += 1
                }*/
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    //print("Wall/Junction Hit, Stop Slide")
                    self.setNeedsDisplay()
                })/*
             
            }*/
            
            if nextCell.isEnd && !userSolved {
                userSolved = true
                makeRainbowTail()
            }
        }
    }
    
    func getCellDistanceFromCell(_ cell: Cell, direction: Direction, distance: Int) -> Cell? {
        switch direction {
        case .North:
            if cell.y - distance < 0 { return nil }
            return cells[cell.y - distance][cell.x]
        case .South:
            if cell.y + distance > vCN { return nil }
            return cells[cell.y + distance][cell.x]
        case .East:
            if cell.x + distance > hCN { return nil }
            return cells[cell.y][cell.x + distance]
        case .West:
            if cell.x - distance < 0 { return nil }
            return cells[cell.y][cell.x - distance]
        }
    }
    
    func cellInUserPath(_ cell: Cell) -> Bool {
        for pCell in userPath {
            if cell.isCell(pCell) { return true }
        }
        return false
    }
    
    func makeMaze() {
        //DispatchQueue.global(qos: .background).async {
            self.createBlankCells()
            
            //Select start Node
            let rndX = Int(arc4random_uniform(UInt32(self.hCN)))
            let rndY = Int(arc4random_uniform(UInt32(self.vCN)))
            let rndStart = self.cells[rndY][rndX]
            rndStart.visited = true
            self.cells[rndY][rndX] = rndStart
            
            //Add neighbours of start to frontier
            self.frontier = [Cell]()
            self.frontier.append(contentsOf: self.getValidNeighbours(rndStart))
            
            self.startDelayedMazeCreation()
            /*
            while !frontier.isEmpty {
                //get random current node
                let rN = Int(arc4random_uniform(UInt32(frontier.count)))
                let rfCell = frontier.remove(at: rN)
                rfCell.visited = true
                self.cells[rfCell.y][rfCell.x] = rfCell
                
                self.breakDownWalls(cell: rfCell)
                
                let newFrontier = self.getValidNeighbours(cell: rfCell)
                if( !newFrontier.isEmpty ) {
                    frontier.append(contentsOf: newFrontier)
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                    self.setNeedsDisplay()
                })
                
            }
            */
            //print(self.cells)
        //}
    }
    
    func createBlankCells(){
        var hI = 0
        var vI = 0
        cells = [[Cell]](repeating: [Cell](repeating: Cell(), count: hCN), count: vCN)
        
        while vI < vCN {
            hI = 0
            while hI < hCN {
                
                let cell = Cell(xIndex: hI, yIndex: vI)
                cells[vI][hI] = cell
                
                hI += 1
            }
            vI += 1
        }
    }
    
    func getValidNeighbours(_ cell: Cell ) -> [Cell] {
        var neighbours = [Cell]()
        
        var xVal = -1
        var yVal = -1
        
        while yVal <= 1 {
            xVal = -1
            while xVal <= 1 {
                if( (yVal == 0 && xVal == 0) || (yVal != 0 && xVal != 0) ){
                    xVal += 1
                    continue
                }
                let nX = cell.x + xVal
                let nY = cell.y + yVal
                if( nX < 0 || nX >= hCN || nY < 0 || nY >= vCN ){
                    xVal += 1
                    continue
                }
                
                let nCell = cells[nY][nX]
                if nCell.visited {
                    xVal += 1
                    continue
                }
                nCell.parent = [cell.x, cell.y]
                neighbours.append(nCell)
                
                xVal += 1
            }
            yVal += 1
        }
        
        return neighbours
    }
    
    func breakDownWalls(_ cell: Cell) {
        let pCell = cells[cell.parent[1]][cell.parent[0]]
        
        if(cell.x == pCell.x){
            if(cell.y > pCell.y) {
                //BREAK North of Cell && South of pCell
                cell.walls[0] = true
                pCell.walls[1] = true
            } else {
                //BREAK South of Cell && North of pCell
                cell.walls[1] = true
                pCell.walls[0] = true
            }
        }
        
        if(cell.y == pCell.y){
            if(cell.x > pCell.x) {
                //BREAK West of Cell && East of pCell
                cell.walls[3] = true
                pCell.walls[2] = true
            } else {
                //BREAK East of Cell && West of pCell
                cell.walls[2] = true
                pCell.walls[3] = true
            }
        }
        
        cells[cell.y][cell.x]   = cell
        cells[pCell.y][pCell.x] = pCell
        
    }
    
    func breakDownExternalWall(_ cell: Cell) {
        if( cell.x == 0 ) {
            cell.walls[3] = true
        } else if( cell.x == hCN - 1) {
            cell.walls[2] = true
        } else if( cell.y == 0 ) {
            cell.walls[0] = true
        } else if( cell.y == vCN - 1) {
            cell.walls[1] = true
        }
        cells[cell.y][cell.x] = cell
    }
    
    func startDelayedMazeCreation() {
        animating = true
        if !frontier.isEmpty {
            //get random current node
            
            let rN = Int(arc4random_uniform(UInt32(frontier.count)))
            
            let rfCell = frontier.remove(at: rN)
            if rfCell.visited {
                self.startDelayedMazeCreation()
            } else {
                rfCell.visited = true
                Cell.setAsCurrent(rfCell)
                self.cells[rfCell.y][rfCell.x] = rfCell
                
                self.breakDownWalls( rfCell )
                
                let newFrontier = self.getValidNeighbours(rfCell)
                if( !newFrontier.isEmpty ) {
                    frontier.append(contentsOf: newFrontier)
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    self.setNeedsDisplay()
                    self.startDelayedMazeCreation()
                })
            }
            
        } else {
            print("= Done ~")
            Cell.unsetCurrent()
            
            // Create Start and End
            let rndStartY = Int(arc4random_uniform(UInt32(vCN / 3)))
            //let rndEndY = Int(arc4random_uniform(UInt32(vCN / 3))) + (2 * (vCN / 3))
            
            let startCell   = cells[rndStartY][0]
            //let endCell     = cells[rndEndY][hCN - 1]
            
            startCell.isStart       = true
            startCell.userTravelled = true
            userPath.append(startCell)
            
            //endCell.isEnd       = true
            
            cells[startCell.y][startCell.x] = startCell
            //cells[endCell.y][endCell.x]     = endCell
            
            breakDownExternalWall( startCell )
            //breakDownExternalWall( endCell )
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.025, execute: {
                self.setNeedsDisplay()// Begin solving the maze
                self.findLongestPath( startCell )
                //self.beginMazeSolve( startCell )
            })
        }
    }
    
    func findLongestPath(_ startCell: Cell) {
        // Find longest path, make end of path End of maze
        // Check if all cells are searched ~
        /*
        if allCellsSearched() {
            // Done search, find longest now
            return
        }
         */
        var d:Direction = .East
        
        startCell.searchPath = true
        cells[startCell.y][startCell.x] = startCell
        searchedPath.append(startCell)
        
        while !searchedPath.isEmpty {
            let last = searchedPath[searchedPath.count-1]
            let next = getNextPath(last , heading: d, isSolve: false)
            if next == nil {
                // Add Path to Paths
                paths.append(searchedPath)
                
                // Remove Last from Path and set it to searchBack
                last.searchBack = true
                searchedPath.removeLast()
                
                if searchedPath.count - 2 < 0 {
                    d = .East
                } else {
                    d = Cell.directionTo(fromCell: searchedPath[searchedPath.count-2], toCell: searchedPath[searchedPath.count-1])
                }
            } else {
                // Add Next to Path and set searched
                next!.searchPath = true
                cells[next!.y][next!.x] = next!
                searchedPath.append(next!)
                
                d = Cell.directionTo(fromCell: last, toCell: next!)
            }
        }
        
        paths = paths.sorted(by: { (a:[Cell], b:[Cell]) -> Bool in
            return a.count > b.count
        })
        
        var fp = 0
        var finalPath = paths[fp]
        var endCell = finalPath[finalPath.count - 1]
        while !isCellValidEnd(endCell) {
            fp += 1
            
            finalPath = paths[fp]
            endCell = finalPath[finalPath.count - 1]
        }
        endCell.isEnd = true
        breakDownExternalWall( endCell )
        cells[endCell.y][endCell.x] = endCell
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.025, execute: {
            self.setNeedsDisplay() //  MAZE CREATION END
            self.animating = false
            self.mazeReady = true
            
            //self.beginMazeSolve( startCell )
        })
    }
    
    func isCellValidEnd(_ cell: Cell) -> Bool {
        if cell.x == 0 || cell.x == hCN - 1 {
            if cell.x == hCN - 1 && cell.y < (vCN / 3) * 2 {
                return false
            } else {
                return true
            }
        } else if cell.y == 0 || cell.y == vCN - 1 {
            return true
        } else {
            return false
        }
    }
    
    func allCellsSearched() -> Bool {
        for row in cells {
            for cell in row {
                if cell.searchPath || cell.searchBack {
                    continue
                } else {
                    return false
                }
            }
        }
        return true
    }
    
    func beginMazeSolve(_ startCell: Cell ) {
        animating = true
        solutionPath.append(startCell)
        
        doMazeSolve(startCell, heading: .East)
    }
    
    func doMazeSolve(_ cell: Cell, heading: Direction) {
        
        // Check if is End
        if cell.isEnd {
            /* Do Something */
            
            animating = false
            printSolutions()
            return
        }
        
        // Get next "left" possible path
        let nextCell = getNextPath(cell, heading: heading, isSolve: true)
        if nextCell == nil {
            //No possible paths, begin backtracking
            //Remove Current cell from path
            let remove = solutionPath.removeLast()
            remove.backtrack()
            cells[remove.y][remove.x] = remove
            
            //Do Solve with new last cell of path
            let newLast = solutionPath[solutionPath.count-1]
            let d = Cell.directionTo(fromCell: solutionPath[solutionPath.count-2], toCell: newLast)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.0125, execute: {
                self.setNeedsDisplay()// Begin solving the maze
                self.doMazeSolve( newLast, heading: d )
            })
            
        } else {
            //Path found, add to path, set solved
            nextCell!.solved = true
            cells[nextCell!.y][nextCell!.x] = nextCell!
            solutionPath.append(nextCell!)
            
            let d = Cell.directionTo(fromCell: cell, toCell: nextCell!)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.025, execute: {
                self.setNeedsDisplay()// Begin solving the maze
                self.doMazeSolve( nextCell!, heading: d )
            })
        }
    }
    
    func getNextPath(_ cell: Cell, heading: Direction, isSolve: Bool) -> Cell? {
        let order:[Direction] = [Direction](arrayLiteral: .North, .East, .South, .West)
        let oi = order.index(of: heading)!
        let sd = oi - 1 > 0 ? oi - 1 : order.count - 1
        
        var i = -1
        while i < 3 {
            i += 1
            
            let cd = i + sd >= order.count ?  i + sd - order.count : i + sd
            let checkDirection = order[cd]
            var checkCell = Cell()
            
            switch checkDirection {
            case .North:
                if cell.y == 0 || !cell.walls[0] { continue }
                checkCell = cells[cell.y - 1][cell.x]
                break
            case .South:
                if cell.y == vCN-1 || !cell.walls[1] { continue }
                checkCell = cells[cell.y + 1][cell.x]
                break
            case .East:
                if cell.x == hCN-1 || !cell.walls[2] { continue }
                checkCell = cells[cell.y][cell.x + 1]
                break
            case .West:
                if cell.x == 0 || !cell.walls[3] { continue }
                checkCell = cells[cell.y][cell.x - 1]
                break
            }
            if (isSolve && (checkCell.solved || checkCell.backtracked)) ||
                (!isSolve && (checkCell.searchPath || checkCell.searchBack)) {
                continue
            } else {
                
                return checkCell
            }
        }
        return nil
    }
    func printSolutions() {
        //print("Solution is " + String(solutionPath.count) + " long")
    }
    
    func redo() {
        // Make New Maze
        // Reset Everything and start
        if !animating {
            mazeReady = false
            userSolved = false
            interruptRainbows = true
            
            beginPath = nil
            endPath = nil
            
            cells = [[Cell]]()
            
            frontier = [Cell]()
            userPath = [Cell]()
            solutionPath = [Cell]()
            paths = [[Cell]]()
            searchedPath = [Cell]()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05, execute: {
                self.setNeedsDisplay()// Begin solving the maze
                self.makeMaze()
            })
        } else {
            
        }
    }
    func rewind() {
        // Remake Same Maze
        // Reset Everything to a point and start
        
        
    }
    func doSolve() {
        //Find Start
        if !animating {
            
            for row in cells {
                for cell in row {
                    cell.solved = false
                    cell.backtracked = false
                    
                }
            }
            
            var i = 0
            var findStart = false
            while !findStart {
                let cell = cells[i][0]
                findStart = cell.isStart
                if cell.isStart {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05, execute: {
                        self.setNeedsDisplay()// Begin solving the maze
                        self.beginMazeSolve(cell)
                    })
                    return
                }
                i += 1
            }
        } else {
            
        }
    }
    
    var swipeLast = CGPoint()
    var swipeSpeed:CGFloat = 0
    var swipeDir:Direction = .East
    var swipePathing = false
    var swipeTravelled:CGFloat = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mazeReady {
            super.touchesBegan(touches, with: event)
            if let touch = touches.first {
                swipeLast = touch.location(in: self)
                swipeSpeed = 0
                swipeTravelled = 0
                swipePathing = false
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mazeReady {
            super.touchesBegan(touches, with: event)
            if let touch = touches.first {
                let swipeNew = touch.location(in: self)
                var heading = getDirectionFromTouch( swipeNew )
                
                swipePathing = heading.direction == swipeDir //Checks if user changes direction
                if heading.dist <= 1.0 {
                    heading.dist = 0
                }
                print(heading.dist)
                if swipePathing {
                    swipeTravelled += heading.dist
                } else {
                    swipeTravelled = heading.dist
                    swipeDir = heading.direction
                }
                
                swipeLast = swipeNew
                swipeSpeed = heading.dist
                
                if swipeTravelled > cellSize * (isIPad ? 2 : 5) {
                    userMove(heading.direction)
                    swipeTravelled = 0
                }
            }

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mazeReady {
            super.touchesEnded(touches, with: event)
            if touches.first != nil {
                //let swipeNew = touch.location(in: self)
                //let heading = getDirectionFromTouch( swipeNew )
                //userMove(heading.direction)
                
                swipeLast = CGPoint()
                swipeSpeed = 0
                swipeTravelled = 0
                swipePathing = false
            }
        }
    }
    
    func getDirectionFromTouch(_ touch: CGPoint) -> Heading{
        var hDist:CGFloat = 0
        var vDist:CGFloat = 0
        var hD:Direction = .West
        var vD:Direction = .North
        
        if swipeLast.y > touch.y {
            // NORTH
            vDist = swipeLast.y - touch.y
            vD = .North
        } else {
            // SOUTH
            vDist = touch.y - swipeLast.y
            vD = .South
        }
        
        if swipeLast.x < touch.x {
            // EAST
            hDist = touch.x - swipeLast.x
            hD = .East
        } else {
            // WEST
            hDist = swipeLast.x - touch.x
            hD = .West
        }
        
        let hv = hDist > vDist // True = Use H, False = Use V
        return Heading(hDirection: ((hv) ? hD : vD), hDistance: ((hv) ? hDist : vDist))
    }
    
    var interruptRainbows = false
    func makeRainbowTail() {
        if interruptRainbows || !userSolved {
            interruptRainbows = false
            return
        }
        var i = userPath.count - 1
        while i >= 0 {
            let cell = userPath[i]
            if cell.rnbw == -2 && i != 0 {
                let priorCell = userPath[i-1]
                if priorCell.rnbw != -2 { cell.rnbw = priorCell.rnbw + 1 }
            } else {
                cell.rnbw = cell.rnbw == -2 ? rbMax-1 : cell.rnbw - 1
            }
            if cell.rnbw == -1 { cell.rnbw = rbMax-1 }
            i -= 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.025, execute: {
            //print("Wall/Junction Hit, Stop Slide")
            self.setNeedsDisplay()
            self.makeRainbowTail()
        })
    }
    
    override func draw(_ rect: CGRect) {
        if cells.count == 0 { return }
        
        // Fixes double render issues ~
        let clearBG = UIBezierPath(rect: self.frame)
        let bgC:UIColor = .black
        bgC.setFill()
        clearBG.fill()
        
        let wallWidth = CGFloat(cellSize * 0.3125)
        
        var xVal = 0
        var yVal = 0
        
        let gridSize = cellSize * CGFloat(hCN)
        let gridOffsetX = (self.frame.width - gridSize) * 0.5
        let gridOffsetY = (self.frame.height - gridSize) * 0.5
        
        while yVal < vCN {
            xVal = 0
            while xVal < hCN {
                
                let cell = cells[yVal][xVal]
                let origin = CGPoint(x: (CGFloat(cell.x) * cellSize) + gridOffsetX, y: (CGFloat(cell.y) * cellSize) + gridOffsetY)
                let size = CGSize(width: cellSize, height: cellSize)
                let rect = CGRect(origin: origin, size: size)
                
                var color:UIColor = cell.visited ? .white : .black
                if( cell.x == Cell.current[0] && cell.y == Cell.current[1] ) {color = .darkGreen}
                
                if( cell.solved ) {color = .purple}
                if( cell.backtracked ) {color = .darkPurple}
                
                if( cell.isStart ) {
                    color = .darkBlue
                    beginPath = UIBezierPath(rect: CGRect(x: rect.minX - cellSize, y: rect.minY, width: cellSize, height: cellSize))
                    color.setFill()
                    beginPath!.fill()
                }
                if( cell.isEnd ) {
                    color = .darkGreen
                    if cell.x == 0 {
                        endPath = UIBezierPath(rect: CGRect(x: rect.minX - cellSize, y: rect.minY, width: cellSize, height: cellSize))
                    } else if cell.x == hCN - 1 {
                        endPath = UIBezierPath(rect: CGRect(x: rect.maxX, y: rect.minY, width: cellSize, height: cellSize))
                    } else if cell.y == 0 {
                        endPath = UIBezierPath(rect: CGRect(x: rect.minX, y: rect.minY - cellSize, width: cellSize, height: cellSize))
                    }else if cell.y == vCN - 1 {
                        endPath = UIBezierPath(rect: CGRect(x: rect.minX, y: rect.maxY, width: cellSize, height: cellSize))
                    }
                    color.setFill()
                    endPath!.fill()
                }
                if( cell.userTravelled ) {color = .userTeal }
                if userPath.count > 0 {
                    if userPath[userPath.count-1].isCell(cell) { color = .dae }
                }
                
                if( userSolved && cellInUserPath(cell) && cell.rnbw != -2 ) {
                    color = UIColor(hue: (360/CGFloat(rbMax) * CGFloat(cell.rnbw))/360, saturation: 100/100, brightness: 82/100, alpha: 1)
                }
                
                let cellBG = UIBezierPath(rect: rect)
                color.setFill()
                cellBG.fill()
                
                var i = 0
                while i < cell.walls.count {
                    let wall = cell.walls[i]
                    if !wall {
                        var wallBGRect = CGRect.zero
                        switch i {
                        case 0://NORTH WALL
                            wallBGRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: wallWidth)
                            break
                        case 1://SOUTH WALL
                            wallBGRect = CGRect(x: rect.minX, y: rect.maxY - wallWidth, width: rect.width, height: wallWidth)
                            break
                        case 2://EAST WALL
                            wallBGRect = CGRect(x: rect.maxX - wallWidth, y: rect.minY, width: wallWidth, height: rect.height)
                            break
                        case 3://WEST WALL
                            wallBGRect = CGRect(x: rect.minX, y: rect.minY, width: wallWidth, height: rect.height)
                            break
                        default: break
                            
                        }
                        let wallBG = UIBezierPath(rect: wallBGRect)
                        color = .black
                        color.setFill()
                        wallBG.fill()
                    }
                    i += 1
                }
                
                //Corners 
                i = 0
                for i in 0...3 {
                    var cornerRect = CGRect.zero
                    switch i {
                    case 0://NORTH WEST
                        cornerRect = CGRect(x: rect.minX, y: rect.minY, width: wallWidth, height: wallWidth)
                        break
                    case 1://NORTH EAST
                        cornerRect = CGRect(x: rect.maxX - wallWidth, y: rect.minY, width: wallWidth, height: wallWidth)
                        break
                    case 2://SOUTH WEST
                        cornerRect = CGRect(x: rect.minX, y: rect.maxY - wallWidth, width: wallWidth, height: wallWidth)
                        break
                    case 3://SOUTH EAST
                        cornerRect = CGRect(x: rect.maxX - wallWidth, y: rect.maxY - wallWidth, width: wallWidth, height: wallWidth)
                        break
                    default: break
                        
                    }
                    let corner = UIBezierPath(rect: cornerRect)
                    color = .black
                    color.setFill()
                    corner.fill()
                }
                
                xVal += 1
            }
            yVal += 1
        }
        
    }
    
}

class Cell {
    // -- walls info
    // true  = wall Open
    // false = wall Closed
    //                                  0      1      2      3
    //                                  North, South, East,  West
    var walls = [Bool]( arrayLiteral:   false, false, false, false )
    var isStart = false
    var isEnd = false
    var visited = false
    
    var userTravelled = false
    
    var solved = false
    var backtracked = false
    
    var searchPath = false
    var searchBack = false
    
    static var current = [0,0]
    
    var x:Int = 0
    var y:Int = 0
    var rnbw:Int = -2
    var parent: [Int] = [0,0]
    public init () {}
    public init (xIndex:Int, yIndex:Int){
        x = xIndex
        y = yIndex
    }
    
    public static func setAsCurrent(_ cell: Cell) {
        current = [cell.x, cell.y]
    }
    public static func unsetCurrent(){
        current = [-1, -1]
    }
    
    public static func directionTo(fromCell: Cell, toCell: Cell) -> Direction {
        var d:Direction = .North
        
        if fromCell.x == toCell.x {
            if fromCell.y > toCell.y {
                d = .North
            } else {
                d = .South
            }
        } else {
            if fromCell.x < toCell.x {
                d = .East
            } else {
                d = .West
            }
        }
        return d
    }
    
    public func backtrack() {
        backtracked = true
        solved = false
    }
    
    public func reset() {
        rnbw = -2
        solved = false
        backtracked = false
        userTravelled = false
        searchBack = false
        searchPath = false
        walls = [Bool](repeating: false, count: 4)
        isStart = false
        isEnd = false
        visited = false
        parent = [0,0]
    }
    
    public func hasCorridors() -> Bool {
        var count = 0
        
        for wall in walls {
            if wall { count += 1 }
        }
        return count >= 3
    }
    
    public func isCell(_ cell: Cell) -> Bool{
        return x == cell.x && y == cell.y
    }
}

struct Heading {
    public var direction:Direction = .North
    public var dist:CGFloat = 0.0
    init(hDirection:Direction, hDistance:CGFloat ) {
        direction = hDirection
        dist = hDistance
    }
}

enum Direction {
    case North
    case South
    case East
    case West
}
