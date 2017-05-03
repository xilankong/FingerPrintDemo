//
//  ViewController.swift
//  FingerPrintDemo
//
//  Created by yanghuang on 16/11/29.
//  Copyright © 2016年 yanghuang. All rights reserved.
//  https://developer.apple.com/reference/localauthentication?language=objc

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var actionButton : UIButton!
    @IBOutlet weak var goButton : UIButton!
    var label : UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 300, width: 320, height: 40))
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        return label
    }()

    override func viewDidLoad() {
        self.title = "Swift 指纹解锁"
        super.viewDidLoad()
        self.view.addSubview(label)
        
        Bundle.main.loadNibNamed("btnViewOne", owner: self, options: nil)
        actionButton.frame = CGRect(x: 0, y: 100, width: 150, height: 50)
        actionButton.center = CGPoint(x: self.view.center.x, y: actionButton.center.y)
        
        actionButton.addTarget(self, action: #selector(authenticate), for: UIControlEvents.touchUpInside)
        self.view.addSubview(actionButton)
        
        goButton.frame = CGRect(x: 0, y: 200, width: 150, height: 50)
        goButton.center = CGPoint(x: self.view.center.x, y: goButton.center.y)
        goButton.addTarget(self, action: #selector(goOC), for: UIControlEvents.touchUpInside)
        self.view.addSubview(goButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func goOC() {
        
        let vc : UIViewController = ViewControllerTwo()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //代码取消弹窗 if (context) {  [context invalidate];  }
    
    //指纹验证
    func authenticate() {
        FingerPasswordHelper.FingerPasswordUnLock(withMsg: "使用您设备解锁指纹解锁") { (result: FingerPasswordHelper.FPCheckResult) in
            switch result {
                
            case .success:
                self.label.text = "用户解锁成功"
            case .failed:
                self.label.text = "用户解锁失败"
            case .passwordNotSet:
                self.label.text = "未设置密码"
            case .touchidNotSet:
                self.label.text = "未设置指纹"
            case .touchidNotAvailable:
                self.label.text = "系统不支持"
            }
        }
    }
}

