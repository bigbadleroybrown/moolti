//
//  LoginViewController.h
//  moolti
//
//  Created by Eugene Watson on 12/15/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate;

@interface LoginViewController : UIViewController

@property (weak, nonatomic) id<LoginViewControllerDelegate> delegate;

@end

@protocol LoginViewControllerDelegate <NSObject>

-(void)loginViewController:(LoginViewController*)loginViewController didFinishWithLogin:(BOOL)loggedIn;

@end

