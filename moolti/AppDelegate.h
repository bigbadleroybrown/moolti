//
//  AppDelegate.h
//  moolti
//
//  Created by Eugene Watson on 11/13/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RESideMenu.h"
#import "JBKenBurnsView.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate, KenBurnsViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *testArray;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSArray *defaultBackgroundImages;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

