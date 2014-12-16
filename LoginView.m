//
//  LoginView.m
//  moolti
//
//  Created by Eugene Watson on 12/15/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#define loginErrorWidth 300.0
#define loginViewTopMargin 120.0
#define loginViewRightMargin 20.0
#define loginViewLeftMargin 20.0
#define loginViewSpacing 10.0
#define loginFontSize 18.0
#define errorSize 10.0

#import "LoginView.h"

@implementation LoginView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.nameField = [[UITextField alloc]initWithFrame:CGRectZero];
        [self.nameField setPlaceholder:@"Name"];
        [self.nameField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.nameField setFont:[UIFont fontWithName:@"Avenir-Light" size:loginFontSize]];
        [self.nameField setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.nameField];
        self.nameField.delegate = self;
        
        self.passwordField = [[UITextField alloc]initWithFrame:CGRectZero];
        self.passwordField.secureTextEntry = YES;
        [self.passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.passwordField setPlaceholder:@"Password"];
        [self.passwordField setFont:[UIFont fontWithName:@"Avenir-Light" size:loginFontSize]];
        [self.passwordField setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.passwordField];
        self.passwordField.delegate = self;
    }
    
    return self;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    return YES;
}

-(void)layoutSubviews
{
    self.nameField.frame = CGRectMake(loginViewLeftMargin,
                                loginViewTopMargin,
                                self.bounds.size.width -
                                (loginViewLeftMargin +
                                 loginViewRightMargin),
                                44.0);
    
    self.passwordField.frame = CGRectMake(loginViewLeftMargin,
                                          self.nameField.frame.origin.y +
                                          self.nameField.bounds.size.height +
                                          loginViewSpacing,
                                          self.bounds.size.width -
                                          (loginViewLeftMargin +
                                           loginViewRightMargin),
                                          44.0);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
