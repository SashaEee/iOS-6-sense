//
//  MainViewController.swift
//  MainViewController
//
//  Created by Sasha on 12/2/21.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var instrButton: UIButton!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutUsButton: UIButton!
    
    override func viewDidLoad() {
        stopSpeaking()
        shadowButton()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func shadowButton(){ // функция добавления теней кнопки 
        instrButton.addShadow()
        navigationButton.addShadow()
        settingsButton.addShadow()
        aboutUsButton.addShadow()
    }

    
}
extension UIView {
  func addShadow() {
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: -1, height: 2)
    self.layer.shadowRadius = 4
      self.layer.shadowOpacity = 0.5
  }
}
