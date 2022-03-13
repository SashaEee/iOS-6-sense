//
//  Menu2ViewController.swift
//  Menu2ViewController
//
//  Created by Sasha on 12/2/21.
//

import UIKit

class Menu2ViewController: UIViewController {
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    override func viewDidLoad() {
        designButton()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func designButton(){
        locationButton.addShadow()
        finishButton.addShadow()
    }
    @IBAction func exit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: "menu")
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
