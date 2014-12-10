//
//  Contact.h
//  moolti
//
//  Created by Eugene Watson on 12/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Contact : NSObject

-(instancetype)initWithAttributes:(NSDictionary *)attributes;
-(NSString *)fullName;

@property (assign, nonatomic) NSInteger recordId;
@property (assign, nonatomic) NSString *firstName;
@property (assign, nonatomic) NSString *lastName;
@property (assign, nonatomic) NSString *phone;
@property (assign, nonatomic) NSString *email;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic, getter= isSelected) BOOL selected;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSDate *dateUpdated;

@end
