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
    
    @IBOutlet weak var actionButton : UIButton!;
    @IBOutlet weak var goButton : UIButton!;
    var label : UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 300, width: 320, height: 40));
        label.textColor = UIColor.black;
        label.textAlignment = NSTextAlignment.center;
        return label;
    }();
    
    lazy var dragBtn : DragButton = {
        var dragBtn = DragButton(frame: CGRect(x: 0, y: 400, width: 50, height: 50))
        dragBtn.clickClosure = {
            [weak self]
            (dragBtn) in
            //单击回调
            self?.dragButtonClickAction(dragBtn)
        }
        dragBtn.doubleClickClosure = {
            [weak self]
            (dragBtn) in
            //双击回调
            self?.dragButtonDoubleClickAction(dragBtn)
        }
        dragBtn.draggingClosure = {
            [weak self]
            (dragBtn) in
            //拖拽回调
            self?.dragButtonDragingAction(dragBtn)
        }
        dragBtn.dragDoneClosure = {
            [weak self]
            (dragBtn) in
            //拖拽结束回调
            self?.dragButtonDragDoneAction(dragBtn)
        }
        dragBtn.autoDockEndClosure = {
            [weak self]
            (dragBtn) in
            //自动吸附回调
            self?.dragButtonAutoDockEndAction(dragBtn)
        }

        return dragBtn;
    }();

    override func viewDidLoad() {
        self.title = "Swift 指纹解锁";
        super.viewDidLoad();
        self.view.addSubview(label);
        
        Bundle.main.loadNibNamed("btnViewOne", owner: self, options: nil);
        actionButton.frame = CGRect(x: 0, y: 100, width: 150, height: 50);
        actionButton.center = CGPoint(x: self.view.center.x, y: actionButton.center.y);
        
        actionButton.addTarget(self, action: #selector(authenticate), for: UIControlEvents.touchUpInside)
        self.view.addSubview(actionButton);
        
        goButton.frame = CGRect(x: 0, y: 200, width: 150, height: 50);
        goButton.center = CGPoint(x: self.view.center.x, y: goButton.center.y);
        
        goButton.addTarget(self, action: #selector(goOC), for: UIControlEvents.touchUpInside)
        self.view.addSubview(goButton);
        self.view.addSubview(dragBtn);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func goOC() {
        
        let vc : UIViewController = ViewControllerTwo();
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    //指纹验证
    func authenticate() {

        if #available(iOS 8.0,OSX 10.12, *){ //IOS 版本判断 低于版本无需调用
            let context : LAContext = LAContext();
            var error : NSError? = nil;
            let msg : String = "使用您设备解锁指纹解锁";
            //判断设备支持状态
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                
                //指纹验证
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: msg, reply: { (success, errorTwo) in
                    
                    if success {
                        //验证成功 直接更新UI慢的原因是因为没有切回主线程    需要切回主线程操作UI
                        DispatchQueue.main.async {
                            self.label.text = "成功解锁";
                        }
                    } else {
                        //根据错误Code不一样，区分不同失败原因
                        switch errorTwo! {
                            
                        case LAError.userCancel:
                            DispatchQueue.main.async  {
                                self.label.text = "用户取消验证";
                            }
                        break;
                        case LAError.systemCancel:
                            DispatchQueue.main.async  {
                                self.label.text = "系统取消验证";
                            }
                            break;
                        case LAError.userFallback:
                            DispatchQueue.main.async  {
                                self.label.text = "用户解锁失败";
                            }
                            break;
                        default :
                                DispatchQueue.main.async {
                                    self.label.text = "其他原因解锁失败";
                                }
                            break;
                            
                        }
                        
                    }
                    
                })
            } else {
                DispatchQueue.main.async {
                    self.label.text = "您的设备不支持指纹解锁";
                }
            }
        
        }
        
    }
    
    
    func dragButtonClickAction(_ btn : DragButton) {
        print("buttonClick")
    }

    func dragButtonDoubleClickAction(_ btn : DragButton) {
        print("buttonDoubleClick")
    }

    func dragButtonDragingAction(_ btn : DragButton) {
        print("buttonDraging")
    }
    func dragButtonAutoDockEndAction(_ btn : DragButton) {
        print("buttonAutoDockEnd")
    }
    func dragButtonDragDoneAction(_ btn : DragButton) {
        print("buttonDragDone")
    }


}

