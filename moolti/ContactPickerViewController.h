//
//  ContactPickerViewController.h
//  moolti
//
//  Created by Eugene Watson on 12/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ContactPickerView.h"
#import "ContactPickerTableViewCell.h"

@interface ContactPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ContactPickerDelegate, ABPersonViewControllerDelegate>

@property (strong, nonatomic) ContactPickerView *contactPickerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSMutableArray *selectedContacts;
@property (strong, nonatomic) NSArray *filteredContacts;

@end
