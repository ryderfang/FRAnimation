//
//  EmitterSnowController.swift
//  AnimationDemo
//
//  Created by Ray Fong on 2017/2/4.
//  Copyright © 2017年 Ray Fong. All rights reserved.
//

import Foundation
import UIKit

class EmitterSnowController : UIViewController {
    var movedMask: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        // 粒子Layer
        let snowEmitter: CAEmitterLayer = CAEmitterLayer.init()
        // 粒子发射位置
        snowEmitter.emitterPosition = CGPoint.init(x: 120, y: 0)
        // 发射源的尺寸大小
        snowEmitter.emitterSize = self.view.bounds.size
        // 发射模式
        snowEmitter.emitterMode = kCAEmitterLayerSurface
        // 发射源的形状
        snowEmitter.emitterShape = kCAEmitterLayerLine
        
        // 雪花粒子
        let snowflake: CAEmitterCell = CAEmitterCell.init()
        // 粒子名字
        snowflake.name = "snow"
        // 粒子参数的速度乘数因子
        snowflake.birthRate = 20.0
        snowflake.lifetime = 120.0
        // 粒子速度
        snowflake.velocity = 10.0
        // 粒子的速度范围
        snowflake.velocityRange = 10
        // 粒子y方向的加速度分量
        snowflake.yAcceleration = 2
        // 周围发射角度
        snowflake.emissionRange = (CGFloat)(0.5 * Double.pi)
        // 子旋转角度范围
        snowflake.spinRange = CGFloat.init(0.25 * Double.pi)
        snowflake.contents = UIImage.init(named: "snow")?.cgImage
        // 雪花形状的粒子颜色
        snowflake.color = UIColor.white.cgColor
        snowflake.redRange = 2.0
        snowflake.greenRange = 2.0
        snowflake.blueRange = 2.0
        
        snowflake.scaleRange = 0.6
        snowflake.scale = 0.7
        
        snowEmitter.shadowOpacity = 1.0
        snowEmitter.shadowRadius = 0.0
        snowEmitter.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        
        // 粒子边缘颜色
        snowEmitter.shadowColor = UIColor.white.cgColor
        // 添加粒子
        snowEmitter.emitterCells = [snowflake]
        self.view.layer.addSublayer(snowEmitter)
        
        // 形成遮罩
        let image: UIImage! = UIImage.init(named: "alpha")
        self.movedMask = CALayer.init()
        self.movedMask?.frame = CGRect.init(origin: CGPoint.zero,
                                            size: CGSize.init(width: image.size.width * 1.5,
                                                              height: image.size.height * 1.5))
        self.movedMask?.contents = image.cgImage
        self.movedMask?.position = self.view.center
        snowEmitter.mask = self.movedMask
        
        // 拖拽的View
        let dragView: UIView! = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: image.size))
        dragView.center = self.view.center
        self.view.addSubview(dragView)
        
        let recognizer: UIPanGestureRecognizer =
            UIPanGestureRecognizer.init(target: self, action: #selector(self.handlePan(sender:)))
        dragView.addGestureRecognizer(recognizer)
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        let translation: CGPoint = sender.translation(in: self.view)
        sender.view?.center = CGPoint.init(x: (sender.view?.center.x)! + translation.x,
                                           y: (sender.view?.center.y)! + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        // 关闭CoreAnimation实时动画绘制(!)
        CATransaction.setDisableActions(true)
        self.movedMask?.position = (sender.view?.center)!
    }
}
