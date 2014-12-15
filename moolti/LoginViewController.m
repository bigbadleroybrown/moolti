//
//  LoginViewController.m
//  moolti
//
//  Created by Eugene Watson on 12/12/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *resetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *requestPasswordReset;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *nameFieldContainer;
@property (weak, nonatomic) IBOutlet UIView *secondFieldNormal;
@property (weak, nonatomic) IBOutlet UIView *secondFieldReset;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;


@end

@implementation LoginViewController
    BOOL _isNameFieldShowing;
    BOOL _isModeSwitchPending;

+(instancetype)controller
{
    LoginViewController *vc = [[UIStoryboard storyboardWithName:NSStringFromClass(self) bundle:[NSBundle bundleForClass:self]]instantiateInitialViewController];
    return vc;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self == nil) return nil;
    self.transitioningDelegate = self;
    _mode = -1;
    _newMode = -1;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *phAttribs = @{ NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.3] };
    void (^processField)(UITextField *) = ^(UITextField *field) {
        field.text = nil;
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:field.placeholder attributes:phAttribs];
    };
    processField(_nameField);
    processField(_passwordField);
    processField(_emailField);
    self.view.backgroundColor = nil;
    _resetPasswordButton.layer.cornerRadius = 2.5;
    _requestPasswordReset.layer.cornerRadius =2.5;
    
    [self _switchToMode:LoginControllerModeLogin animated:NO];
    [self setMode:secondFieldNormal animated:YES ];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Transitioning Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

#pragma mark Animated Transitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [UIView transitionFromView:from.view toView:to.view duration:[self transitionDuration:transitionContext] options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    dispatch_block_t submit = ^{
        NSLog(@"User tapped Submit");
    };
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.nameField) {
        submit();
    }
    else if (_newMode == secondFieldReset) {
        NSLog(@"User tapped Register");
    }
    
    else if (textField == _passwordField) {
        if (_isNameFieldShowing) {
            [_nameField becomeFirstResponder];
        } else {
            
            submit();
        }
    }
    return NO;
}

- (void)_switchToMode:(LoginControllerMode)mode animated:(BOOL)animated {
    if (_mode == mode) return;
    
    [self setMode:secondFieldNormal animated:YES ];
    
    _mode = mode;
    // select segment
    _modeSelector.selectedSegmentIndex = TRSelectorSegmentIndexForMode(mode);
    // swap last row
    UIView *to = (mode == LoginControllerModeLogin) ? _resetPasswordButton : _nameFieldContainer;
    UIView *from = (mode == LoginControllerModeLogin) ? _nameFieldContainer : _resetPasswordButton;
    
    [UIView transitionFromView:from toView:to duration:animated ? 0.5 : 0 options:UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    
    _isNameFieldShowing = (to == _nameFieldContainer);
    
    // change password field return button
    _passwordField.returnKeyType = _isNameFieldShowing ? UIReturnKeyNext : UIReturnKeyDone;
    [_passwordField reloadInputViews];
    
    if (_mode ==LoginControllerModeRegister) {
        [_emailField resignFirstResponder];
    }
    else {
        [_emailField becomeFirstResponder];
    }
}

-(void)setMode:(ResetPasswordMode)newMode animated:(BOOL)animated
{
    if (_newMode ==newMode) return;
    _newMode = newMode;
    
    UIView *to = (_newMode == secondFieldNormal) ? self.secondFieldNormal : self.secondFieldReset;
    UIView *from = (_newMode == secondFieldNormal) ? self.secondFieldReset : self.secondFieldNormal;
    [UIView transitionFromView:from toView:to duration:animated ? 0.5 : 0 options:UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    
    [UIView animateWithDuration:animated ? 0.5 : 0 animations:^{
        self.resetPasswordButton.hidden = (_newMode == secondFieldReset)? 1:0;
        self.doneButton.hidden = (_newMode == secondFieldReset)? 1:0;
    }];
}


static inline LoginControllerMode TRModeForSelectorSegmentIndex(NSInteger index) {
    switch (index) {
        case 0:
            return LoginControllerModeLogin;
        case 1:
            return LoginControllerModeRegister;
        default:
            NSCAssert(NO, @"Invalid index in %s: %d", __PRETTY_FUNCTION__, (int)index);
            return -1;
    }
}

static inline LoginControllerMode TRSelectorSegmentIndexForMode(LoginControllerMode mode) {
    switch (mode) {
        case LoginControllerModeLogin:
            return 0;
        case LoginControllerModeRegister:
            return 1;
        default:
            NSCAssert(NO, @"Invalid mode in %s: %d", __PRETTY_FUNCTION__, (int)mode);
            return -1;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
