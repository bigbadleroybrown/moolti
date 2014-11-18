//
//  mainMenuVC.m
//  moolti
//
//  Created by Eugene Watson on 11/14/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "mainMenuVC.h"
#import "CNPGridMenu.h"


@interface mainMenuVC ()  <CNPGridMenuDelegate>

@property (strong, nonatomic) CNPGridMenu *mainMenu;
@property (strong, nonatomic) CNPGridMenuItem * contacts;
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;


@end

@implementation mainMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enter.layer.cornerRadius = 4;
    self.blurEffectStyle = UIBlurEffectStyleDark;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goToMenu:(id)sender {
    
    CNPGridMenuItem *contacts = [[CNPGridMenuItem alloc] init];
    contacts.icon = [UIImage imageNamed:@"users"];
    contacts.title = @"Contacts";

    CNPGridMenuItem *lookBooks = [[CNPGridMenuItem alloc] init];
    lookBooks.icon = [UIImage imageNamed:@"camera"];
    lookBooks.title = @"LookBooks";
    
    CNPGridMenuItem *sms = [[CNPGridMenuItem alloc] init];
    sms.icon = [UIImage imageNamed:@"phone"];
    sms.title = @"SMS";

//    CNPGridMenuItem *email = [[CNPGridMenuItem alloc] init];
//    email.icon = [UIImage imageNamed:@"mail"];
//    email.title = @"Email";

    CNPGridMenu *gridMenu = [[CNPGridMenu alloc] initWithMenuItems:@[contacts, lookBooks, sms]];
    gridMenu.delegate = self;
    [self presentGridMenu:gridMenu animated:YES completion:^{
        NSLog(@"Grid Menu Presented");
    }];
}

//- (void)gridMenuDidTapOnBackground:(CNPGridMenu *)menu {
//    [self dismissGridMenuAnimated:YES completion:^{
//        NSLog(@"Grid Menu Dismissed With Background Tap");
//    }];
//}

- (void)gridMenu:(CNPGridMenu *)menu didTapOnItem:(CNPGridMenuItem *)item {
    [self dismissGridMenuAnimated:YES completion:^{
        NSLog(@"Grid Menu Did Tap On Item: %@", item.title);
    }];
}






@end
