//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Eugene Watson on 11/17/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "DEMOLeftMenuViewController.h"
#import "DEMOFirstViewController.h"
#import "inboxInterface.h"
#import "FontAwesomeKit/FontAwesomeKit.h"
#import "GalleryVC.h"
#import "MWPhotoBrowser.h"
#import "CollectionTableView.h"
#import "SMSViewController.h"
#import "ContactPickerViewController.h"

@interface DEMOLeftMenuViewController ()
{
    NSMutableArray *_selections;
}

@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;


@end

@implementation DEMOLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 1.75f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
       
        case 0:
        
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ContactPickerViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        
        case 1:
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[inboxInterface alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        
        case 2:
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[SMSViewController alloc]init]]         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        
        case 3:
        
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc]initWithRootViewController:[[CollectionTableView alloc]init]]animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
}

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Light" size:19];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"Contacts", @"Mail", @"SMS", @"Look Books"];
    NSArray *images = @[@"address16", @"mail21", @"Icon-72", @"Icon-73"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

@end
