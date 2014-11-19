//
//  CollectionTableView.h
//  moolti
//
//  Created by Eugene Watson on 11/19/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface CollectionTableView : UITableViewController <MWPhotoBrowserDelegate>


@property (nonatomic, strong) NSMutableArray *assets;

@end
