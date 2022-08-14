//
//  ViewController.swift
//  UIKitProject
//
//  Created by Akihiro Orikasa on 2022/08/13.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.text = NSLocalizedString("Hello, world!", comment: "")
    }


}

