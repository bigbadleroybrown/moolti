//
//  SMSViewController.h
//  moolti
//
//  Created by Eugene Watson on 12/8/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "JSQMessages.h"
#import "SMSDataModel.h"

@class SMSViewController;

@protocol SMSViewControllerDelegate <NSObject>

-(void)didDismissSMSViewController: (SMSViewController *)vc;

@end

@interface SMSViewController : JSQMessagesViewController <UIActionSheetDelegate>

@property (weak, nonatomic) id<SMSViewControllerDelegate> delegateModal;

@property (strong, nonatomic) SMSDataModel *dataModel;

-(void)receiveMessagePressed: (UIBarButtonItem *)sender;
-(void)closePressed : (UIBarButtonItem *)sender;

@end
