//
//  InstrViewController.swift
//  6 Sense
//
//  Created by Sasha on 3/16/22.
//


import UIKit
import Foundation

class InstrViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var TextView: UITextView!
    var textArr: [String] = ["Первое сообщение из шести.При открытии приложения вы попадаете в главное меню, от сюда вы можете прослушать эту инструкцию, перейти к навигации или открыть настройки", "Второе сообщение из шести.Для первого использования системы на любом объекте необходимо соединение с интернет, для дальнейшего использования соединение необязательно.", "Третье сообщение из шести.Если вы откроете меню навигации недалеко от объекта, оборудованного нашей системой, то в течение нескольких секунд ваше местоположение будет автоматически определено, о чем будет свидетельствовать надпись на первой кнопке на экране, далее вам нужно выбрать пункт назначения в соответствующем меню, кнопка для его вызова располагается следом за кнопкой выбора локации. После выбора пункта назначения, остаётся нажать кнопку «‎найти маршрут»‎ и ждать голосовых подсказок.", "Четвертое сообщение из шести.В приложении предусмотрена функция прогулки, когда вы будете находиться в меню выбора маршрута, приложение будет сообщать вам ваше местоположение.", "Пятое сообщение из шести.В меню настроек вы можете регулировать скорость речи.", "Шестое сообщение из шести. Для выхода из любого меню воспользуйтесь стандартной кнопкой «‎назад»‎"]
    var number = 0
    override func viewDidLoad() {
        backButton.isHidden = true
        TextView.text = textArr[number]
        speak(phrase: TextView.text)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonTap(_ sender: Any) { //нажата кнопка назад
        stopSpeaking()
        number -= 1
        forwardButton.isHidden = false
        if number <= 0{
            backButton.isHidden = true
        } else { backButton.isHidden = false}
        TextView.text = textArr[number]
        speak(phrase: TextView.text)
    }
    @IBAction func forwardButtonTap(_ sender: Any) { //нажата кнопка вперед
        stopSpeaking()
        number += 1
        backButton.isHidden = false
        if number >= 5{
            forwardButton.isHidden = true
        } else { forwardButton.isHidden = false}
        TextView.text = textArr[number]
        speak(phrase: TextView.text)
    }

    
 
}
