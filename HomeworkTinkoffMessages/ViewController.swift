//
//  ViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 13.02.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Application moved from Disappeared | Disappearing to Appearing: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Application moved from Appearing to Appeared: viewDidAppear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("Application moved from Autolayouted to Autolayouting: viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("Application moved from Autolayouting to Autolayouted: viewDidLayoutSubviews")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Application moved from Appearing | Appeared to Disappearing: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Application moved from Disappearing to Disappeared: viewWillAppear")
    }
    
}

