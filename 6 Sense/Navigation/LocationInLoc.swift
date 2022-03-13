//
//  LocationInLoc.swift
//  6 Sense
//
//  Created by Sasha on 2/24/22.
//

import UIKit
import Foundation
import SwiftyJSON


var infoButtonInLoc: Int = 0

class LocationInLocView: UIViewController {
    
    
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
        print("Button tapped with tag \(sender.tag)")
        endBeaconText = (sender.titleLabel?.text)!
        infoButtonInLoc = sender.tag
        openView(id: "beaconNavigate")
    }
    func openView(id: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: id)
        self.navigationController?.show(nextVC, sender: Any?.self)
    }
    
    func addButton(){
        let nodesJSON = BeaconName(fromJson: JSON1![infoButtonLoc])
        for index in nodesJSON.nodes!.startIndex...nodesJSON.nodes!.endIndex - 1 {
            print(nodesJSON.nodes[index].name)
            if nodesJSON.nodes[index].isDestination == true {
                myButtonsArray.append("\(nodesJSON.nodes[index].name ?? "")")
            } else {
                myButtonsArray.append("nil")
            }
        }
        
        for (index,element) in myButtonsArray.enumerated() {
            if element != "nil" {
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
                button.titleLabel?.numberOfLines = 2
                button.titleLabel?.textAlignment = .center
                button.heightAnchor.constraint(equalToConstant: 135).isActive = true
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
    @IBAction func exit(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: "menu")
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }

    
}
