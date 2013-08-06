//
//  Playlists.h
//  Music
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateMomentViewController.h"

@class Playlist;

@interface MomentsTableViewController : UITableViewController <MomentAddDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(void)showPlaylist:(Playlist *)playlist animated:(BOOL)animated;

@end
