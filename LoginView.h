//
//  LoginView.h
//  moolti
//
//  Created by Eugene Watson on 12/15/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UILabel *errorLabel;

-(void)showError:(NSString*)error;

@end
