//
//  BubbleColor.h
//  moolti
//
//  Created by Eugene Watson on 12/9/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BubbleColor : NSObject

@property (strong, nonatomic) UIColor *gradientTop;
@property (strong, nonatomic) UIColor *gradientBottom;
@property (strong, nonatomic) UIColor *border;

-(id)initWithGradientTop:(UIColor*)gradientTop gradientBottom:(UIColor*)gradientBottom border:(UIColor*)border;

@end
