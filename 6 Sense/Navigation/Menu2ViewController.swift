//
//  Menu2ViewController.swift
//  Menu2ViewController
//
//  Created by Sasha on 12/2/21.
//

import UIKit

class Menu2ViewController: UIViewController {
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var huynyaView: UIView!
    override func viewDidLoad() {
        designButton()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func designButton(){
        locationButton.addShadow()
        searchButton.addShadow()
        finishButton.addShadow()
        huynyaView.addShadow()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
