//
//  CollectionCell.h
//  moolti
//
//  Created by Eugene Watson on 11/19/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CollectionName;
@property (weak, nonatomic) IBOutlet UILabel *CollectionSubLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CollectionImage;

@end
