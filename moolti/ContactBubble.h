//
//  ContactBubble.h
//  moolti
//
//  Created by Eugene Watson on 12/9/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BubbleColor.h"

@class ContactBubble;

@protocol ContactBubbleDelegate <NSObject>

-(void)contactBubbleWasSelected:(ContactBubble *)contactBubble;
-(void)contactBubbleWasUnSelected:(ContactBubble *)contactBubble;
-(void)contactBubbleShouldBeRemoved:(ContactBubble *)contactBubble;

@end

@interface ContactBubble : UIView <UITextViewDelegate>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextView *textView;
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) id <ContactBubbleDelegate>delegate;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (strong, nonatomic) BubbleColor *color;
@property (strong, nonatomic) BubbleColor *selectedColor;

-(id)initWithName:(NSString*)name;
-(id)initWithName:(NSString *)name
             color:(BubbleColor *)color
     selectedColor:(BubbleColor *)selectedColor;

-(void)select;
-(void)unSelect;
-(void)setFont:(UIFont*)font;

@end
