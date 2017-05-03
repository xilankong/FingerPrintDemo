//
//  ViewControllerTwo.m
//  FingerPrintDemo
//
//  Created by yanghuang on 16/11/29.
//  Copyright © 2016年 yanghuang. All rights reserved.
//

#import "ViewControllerTwo.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewControllerTwo ()

@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation ViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OC 指纹解锁";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 320, 40)];
    self.resultLabel.textColor = [UIColor blackColor];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.text = @"";
    [self.view addSubview:self.resultLabel];
    
    [self authenticateUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma 指纹验证

- (void)authenticateUser {
    //初始化上下文
    LAContext *context = [[LAContext alloc]init];
    NSError *error = nil;
    
    NSString *msg = @"使用您设备解锁指纹解锁";
    
    //判断设备支持状态 
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
       //指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                //验证成功 直接更新UI慢得原因是因为没有切回主线程    需要切回主线程操作UI
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    
                    self.resultLabel.text = @"成功解锁";
                }];
            } else {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                        //切换到其他APP 系统取消验证
                    {
                        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                            
                            self.resultLabel.text = @"系统取消验证";
                        }];
                    }
                        break;
                    case LAErrorUserCancel:
                        //用户取消验证
                    {
                        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                            
                            self.resultLabel.text = @"用户取消验证";
                        }];
                    }
                        break;
                    case LAErrorUserFallback:
                        //用户验证失败
                    {
                        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                            
                            self.resultLabel.text = @"用户验证失败";
                        }];
                    }
                        break;

                    default:
                        //其他失败情况
                    {
                        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                            
                            self.resultLabel.text = @"其他失败情况";
                        }];
                    }
                        break;
                }
            }
        }];
        
    } else {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
            self.resultLabel.text = @"您的设备不支持指纹解锁";
        }];
    }
    
    
}
/*
 //授权失败
 LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
 //用户取消Touch ID授权
 LAErrorUserCancel           = kLAErrorUserCancel,
 
 //用户选择输入密码
 LAErrorUserFallback         = kLAErrorUserFallback,
 
 //系统取消授权(例如其他APP切入)
 LAErrorSystemCancel         = kLAErrorSystemCancel,
 
 //系统未设置密码
 LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,
 
 //设备Touch ID不可用，例如未打开
 
 LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,
 
 //设备Touch ID不可用，用户未录入
 LAErrorTouchIDNotEnrolled   = kLAErrorTouchIDNotEnrolled,
 */
@end
