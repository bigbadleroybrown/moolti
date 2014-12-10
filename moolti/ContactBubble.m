//
//  ContactBubble.m
//  moolti
//
//  Created by Eugene Watson on 12/9/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "ContactBubble.h"

@implementation ContactBubble

#define kHorizontalPadding 10
#define kVerticalPadding 2

#define kBubbleColor                      [UIColor colorWithRed:24.0/255.0 green:134.0/255.0 blue:242.0/255.0 alpha:1.0]
#define kBubbleColorSelected              [UIColor colorWithRed:151.0/255.0f green:199.0/255.0f blue:250.0/255.0f alpha:1.0]

-(id)initWithName:(NSString *)name
{
    if ([self initWithName:name color:nil selectedColor:nil]) {
        
    }
    return self;
}

-(id)initWithName:(NSString *)name color:(BubbleColor *)color selectedColor:(BubbleColor *)selectedColor
{
    self = [super init];
    if (self) {
        self.name = name;
        self.isSelected = NO;
        
        if (color==nil) {
            color = [[BubbleColor alloc]initWithGradientTop:kBubbleColor gradientBottom:kBubbleColor border:kBubbleColor];
        }
        
        if (selectedColor ==nil) {
            selectedColor = [[BubbleColor alloc]initWithGradientTop:kBubbleColorSelected gradientBottom:kBubbleColorSelected border:kBubbleColorSelected];
        }
        
        self.color = color;
        self.selectedColor = selectedColor;
        
        [self setUpView];
    }
        return self;
}

-(void)setUpView
{
    self.label = [[UILabel alloc] init];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.text = self.name;
    [self addSubview:self.label];
    
    self.textView = [[UITextView alloc]init];
    self.textView.delegate = self;
    self.textView.hidden = YES;
    [self addSubview:self.textView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
    [self adjustSize];
    
    [self unSelect];
}

-(void)adjustSize
{
    [self.label sizeToFit];
    CGRect frame = self.label.frame;
    frame.origin.x = kHorizontalPadding;
    frame.origin.y = kVerticalPadding;
    self.label.frame = frame;
    
    self.bounds = CGRectMake(0, 0, frame.size.width + 2 * kHorizontalPadding, frame.size.height + 2 *kVerticalPadding);
    
    if (self.gradientLayer ==nil) {
        self.gradientLayer = [CAGradientLayer layer];
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    self.gradientLayer.frame = self.bounds;
    
    CALayer *viewLayer = [self layer];
    viewLayer.cornerRadius = self.bounds.size.height / 2;
    viewLayer.borderWidth = 1;
    viewLayer.masksToBounds = YES;
    
}

- (void)setFont:(UIFont *)font {
    self.label.font = font;
    
    [self adjustSize];
}

-(void)select
{
    if ([self.delegate respondsToSelector:@selector(contactBubbleWasSelected:)]) {
        [self.delegate contactBubbleWasSelected:self];
    }
    
}

-(void)unSelect
{
    CALayer *viewLayer = [self layer];
    viewLayer.borderColor = self.color.border.CGColor;
    
    self.gradientLayer.colors = [NSArray arrayWithObjects:(id)[self.color.gradientTop CGColor], (id)[self.color.gradientBottom CGColor], nil];
    
    self.label.textColor = [UIColor whiteColor];
    
    [self setNeedsDisplay];
    self.isSelected = NO;
    
    [self.textView resignFirstResponder];
    
}

- (void)handleTapGesture {
    if (self.isSelected){
        [self unSelect];
    } else {
        [self select];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    self.textView.hidden = NO;
    
    if ( [text isEqualToString:@"\n"] ) { // Return key was pressed
        return NO;
    }
    
    // Capture "delete" key press when cell is empty
    if ([textView.text isEqualToString:@""] && [text isEqualToString:@""]){
        if ([self.delegate respondsToSelector:@selector(contactBubbleShouldBeRemoved:)]){
            [self.delegate contactBubbleShouldBeRemoved:self];
        }
    }
    
    if (self.isSelected){
        self.textView.text = @"";
        [self unSelect];
        if ([self.delegate respondsToSelector:@selector(contactBubbleWasUnSelected:)]){
            [self.delegate contactBubbleWasUnSelected:self];
        }
    }
    
    return YES;
}


@end
