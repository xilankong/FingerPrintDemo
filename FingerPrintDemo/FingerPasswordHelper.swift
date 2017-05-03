//
//  FingerPasswordHelper.swift
//  FingerPrintDemo
//
//  Created by yanghuang on 2017/5/3.
//  Copyright © 2017年 yanghuang. All rights reserved.
//

import Foundation
import LocalAuthentication

class FingerPasswordHelper: NSObject {
    
    @objc
    enum FPCheckResult: NSInteger {
        case success             //成功
        case failed              //失败
        case passwordNotSet      //未设置手机密码
        case touchidNotSet       //未设置指纹
        case touchidNotAvailable //不支持指纹
    }
    
    // MARK: 校验是否支持指纹，不涉及指纹验证
    static func checkFingerPasswordAvailable(block : @escaping (_ result: FPCheckResult) -> Void) {
        
        if #available(iOS 8.0, OSX 10.12, *) { //IOS 版本判断 低于版本无需调用
            let context: LAContext = LAContext()
            context.localizedFallbackTitle = ""
            var error: NSError? = nil
            //判断设备支持状态
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                block(FPCheckResult.success)
            }
            
            guard error != nil else {
                block(FPCheckResult.success)
                return
            }
            
            switch LAError(_nsError: error!).code {
                
            case LAError.passcodeNotSet:
                block(FPCheckResult.passwordNotSet)
                break
                
            case LAError.touchIDNotEnrolled:
                block(FPCheckResult.touchidNotSet)
                break
                
            case LAError.touchIDNotAvailable:
                block(FPCheckResult.touchidNotAvailable)
                break
                
            default:
                //所有其他情况如需添加，可在后面处理，大部分情况不需要处理，所以都返回失败。
                block(FPCheckResult.failed)
                break
            }
        }
    }
    
    // MARK: 校验是否指纹验证成功,返回各种错误信息
    static func FingerPasswordUnLock(withMsg msg: String, block : @escaping (_ result: FPCheckResult) -> Void) {
        
        if #available(iOS 8.0, OSX 10.12, *) { //IOS 版本判断 低于版本无需调用
            let context: LAContext = LAContext()
            context.localizedFallbackTitle = ""
            var error: NSError? = nil
            let msg: String = msg
            //判断设备支持状态
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                //指纹验证
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: msg, reply: { (success, _) in
                    
                    if success {
                        //验证成功 直接更新UI慢的原因是因为没有切回主线程    需要切回主线程操作UI
                        DispatchQueue.main.async {
                            block(FPCheckResult.success)
                        }
                    } else {
                        //根据错误Code不一样，区分不同失败原因
                        DispatchQueue.main.async {
                            block(FPCheckResult.failed)
                        }
                    }
                })
            } else {
                guard error != nil else {
                    return
                }
                switch LAError(_nsError: error!).code {
                    
                case LAError.passcodeNotSet:
                    DispatchQueue.main.async {
                        block(FPCheckResult.passwordNotSet)
                    }
                    break
                    
                case LAError.touchIDNotEnrolled:
                    DispatchQueue.main.async {
                        block(FPCheckResult.touchidNotSet)
                    }
                    break
                    
                case LAError.touchIDNotAvailable:
                    DispatchQueue.main.async {
                        block(FPCheckResult.touchidNotAvailable)
                    }
                    break
                default:
                    DispatchQueue.main.async {
                        block(FPCheckResult.failed)
                    }
                    break
                }
            }
        }
    }
}
