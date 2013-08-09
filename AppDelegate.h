//
//  AppDelegate.h
//  Music
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentsTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

