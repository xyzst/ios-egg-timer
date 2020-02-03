//
//  ViewController.swift
//  EggTimer
//
//  Created by Darren Rambaud on 02/02/2020.
//  Copyright © 2020 Darren Rambaud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum EggBoilTime: Int {
        case UNKNOWN = -1
        case SOFT = 300
        case MEDIUM = 420
        case HARD = 720
        
        static func from(_ value: String) -> EggBoilTime {
            switch value.uppercased() {
            case "SOFT":    return EggBoilTime.SOFT
            case "MEDIUM":  return EggBoilTime.MEDIUM
            case "HARD":    return EggBoilTime.HARD
            default:        return EggBoilTime.UNKNOWN
            }
        }
        
        func getDisplayName() -> String {
            switch self {
                case .SOFT:     return "Soft"
                case .MEDIUM:   return "Medium"
                case .HARD:     return "Hard"
                case .UNKNOWN:  return "Unknown"
            }
        }
    }
    
    var selectedEggType: EggBoilTime? = nil
    var timer = Timer()
    var remainingTime: Int = 0
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBAction func eggTemperature(_ sender: UIButton) {
        setAlarmBy(EggBoilTime.from(sender.currentTitle ?? "SOFT"))
    }
    
    func setAlarmBy(_ time: EggBoilTime) {
        progressBar.setProgress(0.0, animated: true)
        timer.invalidate()

        selectedEggType = time
        remainingTime = time.rawValue

        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(countdown),
            userInfo: nil,
            repeats: true)
        
        timer.fire()
    }
    
    @objc func countdown() {
        if (remainingTime > 0) {
            header.text = "\(selectedEggType!.getDisplayName()) boiled eggs have \(remainingTime) seconds remaining"
            progressBar.setProgress(
                (1.0 - (Float(remainingTime) / Float(selectedEggType!.rawValue))),
                animated: true)
            remainingTime -= 1
        } else {
            header.text = "\(selectedEggType!.getDisplayName()) boiled eggs are done!"
            progressBar.setProgress(1.0, animated: true)
            
            timer.invalidate()
        }
    }
}
