//
//  LoginViewController.m
//  moolti
//
//  Created by Eugene Watson on 12/15/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "AFOAuth2Manager.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestSerializer+OAuth2.h"
#import "DEMOLeftMenuViewController.h"
#import "DEMORightMenuViewController.h"
#import "SMSViewController.h"
#import "ContactPickerViewController.h"
#import "MONActivityIndicatorView.h"
#import "TSMessageView.h"


@interface LoginViewController () <RESideMenuDelegate, MONActivityIndicatorViewDelegate>

@property (nonatomic, strong) UINavigationController *navController;

#define ShowHUD(view) [MBProgressHUD showHUDAddedTo:view animated:YES]

-(void)cancel:(id)sender;
-(void)login:(id)sender;

@end

@implementation LoginViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Moolti Login";
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor blackColor], NSForegroundColorAttributeName,
                                                               [UIFont fontWithName:@"Avenir-Light" size:18.0], NSFontAttributeName, nil]];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(cancel:)];
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Login"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(login:)];

        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
        
        NSDictionary* barButtonItemAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light" size:15.0f]};
        [[UIBarButtonItem appearance] setTitleTextAttributes: barButtonItemAttributes forState:UIControlStateNormal];
    }
    
    return self;
}

-(void)loadView
{
    LoginView *loginView = [[LoginView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    self.view = loginView;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}


//random color generator for HUD
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(void)login:(id)sender
{
    LoginView *view = (LoginView *)self.view;
//    static NSString *const emailRegEx =
//    @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)\\b";
//    NSPredicate *emailPred = [NSPredicate predicateWithFormat:@"self MATCHES[c] %@", emailRegEx];
//    if (![emailPred evaluateWithObject:(view.nameField).text]) {
//        //NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"Please enter a valid e-mail address", nil) };
//        return [TSMessage showNotificationWithTitle:@"Please enter a valid email address" type:TSMessageNotificationTypeError];
//    }
    MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 5;
    indicatorView.radius = 10;
    indicatorView.internalSpacing = 3;
    indicatorView.duration = 0.8;
    indicatorView.delay = 0.2;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

    //LoginView *view = (LoginView *)self.view;
    //MAKE THE FUCKING REQUEST!!!!
        
    _navController = [[UINavigationController alloc]initWithRootViewController:[[ContactPickerViewController alloc]init]];
    DEMOLeftMenuViewController *leftMenuViewController= [[DEMOLeftMenuViewController alloc]init];
    DEMORightMenuViewController *rightMenuViewController = [[DEMORightMenuViewController alloc]init];
    RESideMenu *sidemenuViewController = [[RESideMenu alloc]initWithContentViewController:_navController leftMenuViewController:leftMenuViewController rightMenuViewController: rightMenuViewController];
    
    sidemenuViewController.backgroundImage = [UIImage imageNamed:@"homebackground"];
    sidemenuViewController.menuPreferredStatusBarStyle = 1;
    sidemenuViewController.delegate = self;
    sidemenuViewController.contentViewShadowColor = [UIColor blackColor];
    sidemenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sidemenuViewController.contentViewShadowOpacity = 0.6;
    sidemenuViewController.contentViewShadowRadius = 12;
    sidemenuViewController.contentViewShadowEnabled = YES;
        sleep(4.0);
    [self presentViewController:sidemenuViewController animated: NO completion:nil];
        [indicatorView stopAnimating];
    });
}

- (void)loginViewController:(LoginViewController *)loginViewController didFinishWithLogin:(BOOL)loggedIn {
    [self dismissViewControllerAnimated:YES completion:^(){
        if(loggedIn){
            NSLog(@"Logged in");
        }
    }];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancel:(id)sender
{
    NSLog(@"Tapped Cancel");
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
