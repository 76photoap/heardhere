//
//  AppDelegate.h
//  Music
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MomentsTableViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (nonatomic, retain) MomentsTableViewController *momentsController;
@property (readonly, nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end

