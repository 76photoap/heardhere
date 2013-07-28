//
//  AppDelegate.h
//  Music
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MomentsTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

