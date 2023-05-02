//
//  ViewController.swift
//  revisao_api
//
//  Created by Victor Pizetta on 01/05/23.
//

import UIKit

class ViewController: UIViewController {

    let homeView = Home()

    override func loadView() {
        super.loadView()
        self.view = homeView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

