//
//  ContactPickerView.h
//  moolti
//
//  Created by Eugene Watson on 12/9/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THContactBubble.h"

@class THContactPickerView;

@protocol THContactPickerDelegate <NSObject>

- (void)contactPickerTextViewDidChange:(NSString *)textViewText;
- (void)contactPickerDidRemoveContact:(id)contact;
- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView;

@end

@interface THContactPickerView : UIView <UITextViewDelegate, THContactBubbleDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) THContactBubble *selectedContactBubble;
@property (nonatomic, assign) IBOutlet id <THContactPickerDelegate> delegate;
@property (nonatomic, assign) BOOL limitToOne;
@property (nonatomic, assign) CGFloat viewPadding;
@property (nonatomic, strong) UIFont *font;

- (void)addContact:(id)contact withName:(NSString *)name;
- (void)removeContact:(id)contact;
- (void)removeAllContacts;
- (void)setPlaceholderString:(NSString *)placeholderString;
- (void)disableDropShadow;
- (void)resignKeyboard;
- (void)setBubbleColor:(THBubbleColor *)color selectedColor:(THBubbleColor *)selectedColor;
    
@end
