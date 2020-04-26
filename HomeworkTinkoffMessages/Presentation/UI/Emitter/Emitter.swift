//
//  EmitterWindow.swift
//  Chat
//
//  Created by Олег Герман on 26.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import UIKit

protocol IEmitter {
    func startAnimation(with touch: UITouch)
    func updateAnimationPosition(with touch: UITouch)
    func stopAnimation()
}

class Emitter: IEmitter {
    lazy var emitterLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterCells = [emitterCell()]
        emitterLayer.zPosition = CGFloat.greatestFiniteMagnitude
        emitterLayer.birthRate = 0
        return emitterLayer
    }()

    weak var window: UIWindow?

    init(window: UIWindow) {
        self.window = window
        self.window?.layer.addSublayer(emitterLayer)
    }

    func startAnimation(with touch: UITouch) {
        emitterLayer.birthRate = 1
        updateAnimationPosition(with: touch)
    }

    func updateAnimationPosition(with touch: UITouch) {
        let location = touch.location(in: window)
        emitterLayer.emitterPosition = location
    }

    func stopAnimation() {
        emitterLayer.birthRate = 0
    }

    private func emitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "tinkoffLogo")?.cgImage
        cell.birthRate = 10
        cell.lifetime = 1
        cell.lifetimeRange = 0.5
        cell.emissionRange = .pi / 2
        cell.emissionLongitude = .pi / 2
        cell.emissionLatitude = .pi / 2
        cell.alphaSpeed = 0.5
        cell.velocity = 30
        cell.velocityRange = 30
        cell.spin = .pi
        cell.spinRange = .pi / 2
        cell.scale = 0.05
        cell.scaleRange = 0.005
        return cell
    }
}
