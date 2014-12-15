//
//  LoginViewController.m
//  moolti
//
//  Created by Eugene Watson on 12/15/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"

@interface LoginViewController ()

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
    
}

-(void)login:(id)sender
{
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
