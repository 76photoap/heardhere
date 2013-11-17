//
//  AppDelegate.m
//  Heard Here
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

@import MediaPlayer;
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)insertPlaylistWithPlaylistName:(NSString *)playlistName
{
    Playlist *playlist = [NSEntityDescription insertNewObjectForEntityForName:@"Playlist"
                                               inManagedObjectContext:self.managedObjectContext];
    
    playlist.name = playlistName;
    [self.managedObjectContext save:nil];
}

- (void)importCoreDataDefaultRoles {
    [self insertPlaylistWithPlaylistName:@"Sample"];
}
- (void)setupFetchedResultsController
{
    NSString *entityName = @"Playlist";
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                    ascending:YES
                     selector:@selector(localizedCaseInsensitiveCompare:)]];
 
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
        managedObjectContext:self.managedObjectContext
          sectionNameKeyPath:nil
                   cacheName:nil];
    
    [self.fetchedResultsController performFetch:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[self registerMediaPlayerNotifications];
    [self setupFetchedResultsController];
    
    if (![[self.fetchedResultsController fetchedObjects] count] > 0 ) {
        [self importCoreDataDefaultRoles];
    }
    else {
        // do something
    }
    
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    
    UINavigationController *nav = (UINavigationController *)[[tabController viewControllers] objectAtIndex:1];
    
    MomentsTableViewController *mtvc = (MomentsTableViewController *)[[nav viewControllers]objectAtIndex:0];
    mtvc.managedObjectContext = self.managedObjectContext;
     
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.tintColor = [UIColor colorWithRed:255.0/255.0 green:234.0/255.0 blue:149.0/255.0 alpha:1.0];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

-(void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"heardhere" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Heard-Here.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"Heard-Here"
                                                         withExtension:@"sqldata"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end