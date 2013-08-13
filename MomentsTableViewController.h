//
//  Playlists.h
//  Music
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateMomentViewController.h"
#import "PlayerViewController.h"

@class Playlist;
@class Song;

@interface MomentsTableViewController : UITableViewController <MomentAddDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
