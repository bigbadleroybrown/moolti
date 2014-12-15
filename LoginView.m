//
//  LoginView.m
//  moolti
//
//  Created by Eugene Watson on 12/15/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#define loginErrorWidth 300.0
#define loginViewTopMargin 100.0
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
        
        self.passwordField = [[UITextField alloc]initWithFrame:CGRectZero];
        self.passwordField.secureTextEntry = YES;
        [self.passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.passwordField setPlaceholder:@"Password"];
        [self.passwordField setFont:[UIFont fontWithName:@"Avenir-Light" size:loginFontSize]];
        [self.passwordField setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.passwordField];
        
        self.errorLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.errorLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:errorSize]];
        [self.errorLabel setTextAlignment:NSTextAlignmentCenter];
        [self.errorLabel setTextColor:[UIColor redColor]];
        [self addSubview:self.errorLabel];
    }
    
    return self;
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
    
    self.errorLabel.frame = CGRectMake(self.bounds.size.width / 2 -
                                       loginErrorWidth / 2,
                                       self.passwordField.frame.origin.y +
                                       self.passwordField.bounds.size.height +
                                       loginViewSpacing,
                                       loginErrorWidth, 44.0);
    
}

-(void)showError:(NSString *)error
{
    [self.errorLabel setText:@"Error"];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
