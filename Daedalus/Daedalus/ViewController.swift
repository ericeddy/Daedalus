//
//  ViewController.swift
//  Daedalus
//
//  Created by Eric Eddy on 2017-02-07.
//  Copyright © 2017 ericeddy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var maze:MazeView?// = MazeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if maze == nil {
            maze = MazeView(frame: view.bounds, vCell: 20, hCell: 20)
        }
        view!.addSubview(maze!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

