//
//  ContactPickerView.h
//  moolti
//
//  Created by Eugene Watson on 12/9/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactBubble.h"

@class ContactPickerView;

@protocol ContactPickerDelegate <NSObject>

-(void)contactPickerTextViewDidChange:(NSString*)textViewText;
-(void)contactPickerDidRemoveContact:(id)contact;
-(void)contactPickerDidResize:(ContactPickerView*)contactPickerView;

@end

@interface ContactPickerView : UIView <UITextViewDelegate, ContactBubbleDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) ContactBubble *selectedContactBubble;
@property (assign, nonatomic) IBOutlet id <ContactPickerDelegate> delegate;
@property (assign, nonatomic) BOOL limitToOne;
@property (assign, nonatomic) CGFloat viewPadding;
@property (strong, nonatomic) UIFont *font;

- (void)addContact:(id)contact withName:(NSString *)name;
- (void)removeContact:(id)contact;
- (void)removeAllContacts;
- (void)setPlaceholderString:(NSString *)placeholderString;
- (void)disableDropShadow;
- (void)resignKeyboard;
- (void)setBubbleColor:(BubbleColor*)color selectedColor:(BubbleColor*)selectedColor;

@end
