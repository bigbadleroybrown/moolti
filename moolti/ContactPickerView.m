//
//  ContactPickerView.m
//  moolti
//
//  Created by Eugene Watson on 12/9/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "ContactPickerView.h"
#import "ContactBubble.h"

@interface ContactPickerView () {
    BOOL _shouldSelectTextView;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableDictionary *contacts;
@property (strong, nonatomic) NSMutableArray *contactKeys;
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (assign, nonatomic) CGFloat lineHeight;
@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) BubbleColor *bubbleColor;
@property (strong, nonatomic) BubbleColor *bubbleSelectedColor;

@end

@implementation ContactPickerView

#define kViewPadding 5 // the amount of padding on top and bottom of the view
#define kHorizontalPadding 2 // the amount of padding to the left and right of each contact bubble
#define kVerticalPadding 4 // amount of padding above and below each contact bubble
#define kTextViewMinWidth 130

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.viewPadding = kViewPadding;
    
    self.contacts = [NSMutableDictionary dictionary];
    self.contactKeys = [NSMutableArray array];
    
    ContactBubble *contactBubble = [[ContactBubble alloc]initWithName:@"Sample"];
    self.lineHeight = contactBubble.frame.size.height + 2 * kVerticalPadding;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.textView = [[UITextView alloc]init];
    self.textView.delegate = self;
    self.textView.font = contactBubble.label.font;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.contentInset = UIEdgeInsetsMake(-4, -2, 0, 0);
    self.textView.scrollEnabled = NO;
    self.textView.scrollsToTop = NO;
    self.textView.clipsToBounds = NO;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [self layer];
    [layer setShadowColor:[[UIColor colorWithRed:225.0/255.0 green:226.0/255.0 blue:228.0/255.0 alpha:1] CGColor]];
    [layer setShadowOffset:CGSizeMake(0, 2)];
    [layer setShadowOpacity:1];
    [layer setShadowRadius:1.0f];
    
    self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, self.viewPadding, self.frame.size.width, self.lineHeight)];
    self.placeholderLabel.font = contactBubble.label.font;
    self.placeholderLabel.textColor = [UIColor grayColor];
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.placeholderLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Public functions

-(void)disableDropShadow
{
    CALayer *layer = [self layer];
    [layer setShadowRadius:0];
    [layer setShadowOpacity:0];
}

-(void)setFont:(UIFont *)font
{
    _font = font;
    
    ContactBubble *contactBubble = [[ContactBubble alloc]initWithName:@"Sample"];
    [contactBubble setFont:font];
    self.lineHeight = contactBubble.frame.size.height + 2 * kVerticalPadding;
    
    self.textView.font = font;
    [self.textView sizeToFit];
    
    self.placeholderLabel.font = font;
    self.placeholderLabel.frame = CGRectMake(8, self.viewPadding, self.frame.size.width, self.lineHeight);
}

-(void)addContact:(id)contact withName:(NSString *)name
{
    id contactKey = [NSValue valueWithNonretainedObject:contact];
    if ([self.contactKeys containsObject:contactKey]) {
        NSLog(@"Cant add the same object twice");
        return;
    }
    
    self.textView.text = @"";
    
    ContactBubble *contactBubble = [[ContactBubble alloc]initWithName:name color:self.bubbleColor selectedColor:self.bubbleSelectedColor];
    if (self.font !=nil) {
        [contactBubble setFont:self.font];
    }
    
    contactBubble.delegate = self;
    [self.contacts setObject:contactBubble forKey:contactKey];
    [self.contactKeys addObject:contactKey];
    
    [self layoutView];
    
    _shouldSelectTextView = YES;
    
    [self scrollToBottomWithAnimation:YES];
}

- (void)selectTextView {
    self.textView.hidden = NO;
    [self.textView becomeFirstResponder];
}

-(void)removeAllContacts
{
    for (id contact in [self.contacts allKeys]) {
        ContactBubble *contactBubble = [self.contacts objectForKey:contact];
        [contactBubble removeFromSuperview];
    }
    
    [self.contacts removeAllObjects];
    [self.contactKeys removeAllObjects];
    
    [self layoutView];
    
    self.textView.hidden = NO;
    self.textView.text = @"";
    
}

-(void)removeContact:(id)contact
{
    id contactKey = [NSValue valueWithNonretainedObject:contact];
    
    ContactBubble *contactBubble = [self.contacts objectForKey:contactKey];
    [contactBubble removeFromSuperview];
    
    [self.contacts removeObjectForKey:contactKey];
    [self.contactKeys removeObject:contactKey];
    
    [self layoutView];

    self.textView.hidden = NO;
    self.textView.text = @"";
    
    [self scrollToBottomWithAnimation:NO];
}

- (void)setPlaceholderString:(NSString *)placeholderString {
    self.placeholderLabel.text = placeholderString;
    
    [self layoutView];
}

- (void)resignKeyboard {
    [self.textView resignFirstResponder];
}

- (void)setViewPadding:(CGFloat)viewPadding {
    _viewPadding = viewPadding;
    
    [self layoutView];
}

-(void)setBubbleColor:(BubbleColor *)color selectedColor:(BubbleColor *)selectedColor
{
    self.bubbleColor = color;
    self.bubbleSelectedColor = selectedColor;
    
    for (id contactKey in self.contactKeys) {
        ContactBubble *contactBubble = (ContactBubble *)[self.contacts objectForKey:contactKey];
        
        contactBubble.color = color;
        contactBubble.selectedColor = selectedColor;
        
        if (contactBubble.isSelected) {
            [contactBubble select];
        } else {
            [contactBubble unSelect];
        }
        
    }
    
}

#pragma mark - Private functions

-(void)scrollToBottomWithAnimation:(BOOL)animated
{
    if (animated) {
        CGSize size = self.scrollView.contentSize;
        CGRect frame = CGRectMake(0, size.height - self.scrollView.frame.size.height, size.width, self.scrollView.frame.size.width);
        
        [self.scrollView scrollRectToVisible:frame animated:animated];
    } else {
        CGPoint offset = self.scrollView.contentOffset;
        offset.y = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
        self.scrollView.contentOffset = offset;
    }

}

- (void)removeContactBubble:(ContactBubble *)contactBubble
{
    id contact = [self contactForContactBubble:contactBubble];
    if (contact == nil){
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(contactPickerDidRemoveContact:)]){
        [self.delegate contactPickerDidRemoveContact:[contact nonretainedObjectValue]];
    }
    
    [self removeContactByKey:contact];
    
}

- (void)removeContactByKey:(id)contactKey {
    // Remove contactBubble from view
    ContactBubble *contactBubble = [self.contacts objectForKey:contactKey];
    [contactBubble removeFromSuperview];
    
    // Remove contact from memory
    [self.contacts removeObjectForKey:contactKey];
    [self.contactKeys removeObject:contactKey];
    
    // update layout
    [self layoutView];
    
//    [self.textView becomeFirstResponder];
    self.textView.hidden = NO;
    self.textView.text = @"";
    
    [self scrollToBottomWithAnimation:NO];
}

- (id)contactForContactBubble:(ContactBubble *)contactBubble {
    NSArray *keys = [self.contacts allKeys];
    
    for (id contact in keys){
        if ([[self.contacts objectForKey:contact] isEqual:contactBubble]){
            return contact;
        }
    }
    return nil;
}

-(void)layoutView
{
    CGRect frameOfLastBubble = CGRectNull;
    int lineCount = 0;
    
    for (id contactKey in self.contactKeys) {
        ContactBubble *contactBubble = (ContactBubble *) [self.contacts objectForKey:contactKey];
        CGRect bubbleFrame = contactBubble.frame;
        
        if (CGRectIsNull(frameOfLastBubble)) {
            bubbleFrame.origin.x = kHorizontalPadding;
            bubbleFrame.origin.y = kVerticalPadding + self.viewPadding;
        } else {
            
            CGFloat width = bubbleFrame.size.width + 2 * kHorizontalPadding;
            if (self.frame.size.width - frameOfLastBubble.origin.x - frameOfLastBubble.size.width - width >=0) {
                
                bubbleFrame.origin.x = frameOfLastBubble.origin.x + frameOfLastBubble.size.width + kHorizontalPadding * 2;
                bubbleFrame.origin.y = frameOfLastBubble.origin.y;
            } else {
                lineCount++;
                bubbleFrame.origin.x = kHorizontalPadding;
                bubbleFrame.origin.y = (lineCount * self.lineHeight) + kVerticalPadding + 	self.viewPadding;
            }
        }
        frameOfLastBubble = bubbleFrame;
        contactBubble.frame = bubbleFrame;
        // Add contact bubble if it hasn't been added
        if (contactBubble.superview == nil){
            [self.scrollView addSubview:contactBubble];
        }
        
    }
    
    CGFloat minWidth = kTextViewMinWidth + 2 * kHorizontalPadding;
    CGRect textViewFrame = CGRectMake(0, 0, self.textView.frame.size.width, self.lineHeight/* - 2 * kVerticalPadding*/);
    // Check if we can add the text field on the same line as the last contact bubble
    if (self.frame.size.width - frameOfLastBubble.origin.x - frameOfLastBubble.size.width - minWidth >= 0){ // add to the same line
        textViewFrame.origin.x = frameOfLastBubble.origin.x + frameOfLastBubble.size.width + kHorizontalPadding;
        textViewFrame.size.width = self.frame.size.width - textViewFrame.origin.x;
    } else { // place text view on the next line
        lineCount++;
    
        textViewFrame.origin.x = kHorizontalPadding;
        textViewFrame.size.width = self.frame.size.width - 2 * kHorizontalPadding;
        
        if (self.contacts.count == 0){
            lineCount = 0;
            textViewFrame.origin.x = kHorizontalPadding;
        }
    }
    textViewFrame.origin.y = lineCount * self.lineHeight + kVerticalPadding + self.viewPadding;
    self.textView.frame = textViewFrame;
    
    // Add text view if it hasn't been added
    if (self.textView.superview == nil){
        [self.scrollView addSubview:self.textView];
    }
    
    // Hide the text view if we are limiting number of selected contacts to 1 and a contact has already been added
    if (self.limitToOne && self.contacts.count >= 1){
        self.textView.hidden = YES;
        lineCount = 0;
    }
    
    // Adjust scroll view content size
    CGRect frame = self.bounds;
    CGFloat maxFrameHeight = 2 * self.lineHeight + 2 * self.viewPadding; // limit frame to two lines of content
    CGFloat newHeight = (lineCount + 1) * self.lineHeight + 2 * self.viewPadding;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, newHeight);
    
    // Adjust frame of view if necessary
    newHeight = (newHeight > maxFrameHeight) ? maxFrameHeight : newHeight;
    if (self.frame.size.height != newHeight){
        // Adjust self height
        CGRect selfFrame = self.frame;
        selfFrame.size.height = newHeight;
        self.frame = selfFrame;
        
        // Adjust scroll view height
        frame.size.height = newHeight;
        self.scrollView.frame = frame;
        
        if ([self.delegate respondsToSelector:@selector(contactPickerDidResize:)]){
            [self.delegate contactPickerDidResize:self];
        }
    }
    
    // Show placeholder if no there are no contacts
    if (self.contacts.count == 0){
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    self.textView.hidden = NO;
    
    if ( [text isEqualToString:@"\n"] ) { // Return key was pressed
        return NO;
    }
    
    // Capture "delete" key press when cell is empty
    if ([textView.text isEqualToString:@""] && [text isEqualToString:@""]){
        // If no contacts are selected, select the last contact
        self.selectedContactBubble = [self.contacts objectForKey:[self.contactKeys lastObject]];
        [self.selectedContactBubble select];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(contactPickerTextViewDidChange:)]){
        [self.delegate contactPickerTextViewDidChange:textView.text];
    }
    
    if ([textView.text isEqualToString:@""] && self.contacts.count == 0){
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

#pragma mark - THContactBubbleDelegate Functions

-(void)contactBubbleWasSelected:(ContactBubble *)contactBubble
{
    if (self.selectedContactBubble !=nil){
        [self.selectedContactBubble unSelect];
    }
    self.selectedContactBubble = contactBubble;
    
    [self.textView resignFirstResponder];
    self.textView.text = @"";
    self.textView.hidden = YES;
}

-(void)contactBubbleWasUnSelected:(ContactBubble *)contactBubble
{
    if (self.selectedContactBubble !=nil){
        
    }
    [self.textView becomeFirstResponder];
    self.textView.text = @"";
    self.textView.hidden = NO;
}

-(void)contactBubbleShouldBeRemoved:(ContactBubble *)contactBubble
{
    [self removeContactBubble:contactBubble];
}

#pragma mark - Gesture Recognizer

- (void)handleTapGesture {
    if (self.limitToOne && self.contactKeys.count == 1){
        return;
    }
    [self scrollToBottomWithAnimation:YES];
    
    // Show textField
    self.textView.hidden = NO;
    [self.textView becomeFirstResponder];
    
    // Unselect contact bubble
    [self.selectedContactBubble unSelect];
    self.selectedContactBubble = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (_shouldSelectTextView){
        _shouldSelectTextView = NO;
        [self selectTextView];
    }
}

@end
