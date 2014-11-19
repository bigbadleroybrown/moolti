//
//  GalleryVC.h
//  moolti
//
//  Created by Eugene Watson on 11/18/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "AppDelegate.h"

@interface GalleryVC : UIViewController <MWPhotoBrowserDelegate> {
    NSMutableArray *_selections;
}

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;


@end
