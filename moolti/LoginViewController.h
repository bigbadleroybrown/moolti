//
//  LoginViewController.h
//  moolti
//
//  Created by Eugene Watson on 12/12/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoginControllerMode) {
    LoginControllerModeLogin,
    LoginControllerModeRegister
};

typedef NS_ENUM(NSInteger, ResetPasswordMode) {
    secondFieldNormal,
    secondFieldReset
};

@interface LoginViewController : UIViewController

+ (instancetype)controller;

@property (nonatomic, readonly) ResetPasswordMode newMode;

@property (nonatomic, readonly) LoginControllerMode mode;

@end
