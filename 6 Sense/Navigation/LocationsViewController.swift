//
//  LocationsViewController.swift
//  6 Sense
//
//  Created by Sasha on 2/17/22.
//

import UIKit
import Alamofire
import SwiftyJSON


var JSON1: JSON?
var infoButtonLoc: Int = 0


class DynamicStackViewController: UIViewController {
    
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    var myButtonsArray : [String] = []
    
    
    override func viewDidLoad() {
        addButton()
        buttonsStack.spacing = 30
        let insets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        super.viewDidLoad()
                
        
    } //End ViewDidload
    
    @IBAction func buttonAction(sender: UIButton!) {
        infoButtonLoc = sender.tag
        openView(id: "LocationView")
        print("Button tapped with tag \(sender.tag)")
    }
    func openView(id: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: id)
        self.navigationController?.show(nextVC, sender: Any?.self)
    }
    
    func addButton(){
        for index in JSON1!.array!.startIndex...JSON1!.array!.endIndex - 1 {
            let beaconJSON = BeaconName(fromJson: JSON1![index])
            if beaconJSON.text as! String == "" {
            myButtonsArray.append("\(beaconJSON.name ?? "")")
            } else {
                myButtonsArray.append("nil")
            }
        }
        for (index,element) in myButtonsArray.enumerated() {
            if element != "nil"{
            let oneBtn : UIButton = {
                let button = UIButton()
                button.setTitle(element, for: .normal)
                button.backgroundColor = UIColor.white
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.borderWidth = 1
                button.setTitleColor(UIColor.black, for: .normal)
                //button.translatesAutoresizingMaskIntoConstraints = false
                button.contentHorizontalAlignment = .center
                button.contentVerticalAlignment = .center
                button.titleLabel?.font = UIFont(name: "Fira Code Regular", size: 61)
                button.layer.cornerRadius = 5
//                button.frame.size.height = 200.0
//                button.frame.size.width = 200.0
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button.tag = index
                button.addShadow()
                return button
            }()
            buttonsStack.addArrangedSubview(oneBtn)
            }
        }

    }

    
}
