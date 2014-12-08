//
//  SMSDataModel.h
//  moolti
//
//  Created by Eugene Watson on 12/8/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "JSQMessages.h"

static NSString * const kAvatarNameEugene = @"Eugene Watson";
static NSString * const kAvatarNameRoss = @"Ross Anderson";
static NSString * const kAvatarNameKevin = @"Kevin Fling";
static NSString * const kAvatarNameElliott = @"Elliott Watson";

static NSString * const kAvatarIdEugene = @"123456789";
static NSString * const kAvatarIdRoss = @"0123456789";
static NSString * const kAvatarIdKevin = @"234567891";
static NSString * const kAvatarIdElliott = @"345678912";

@interface SMSDataModel : NSObject

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *avatars;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) NSDictionary *users;

-(void)addPhotoMedia;
-(void)addLocationMediaMessageCompletion: (JSQLocationMediaItemCompletionBlock)completion;
-(void)addVideoMessage;

@end
