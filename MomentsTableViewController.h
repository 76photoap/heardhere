//
//  Playlists.h
//  Heard Here
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateMomentViewController.h"
#import "PlayerViewController.h"
#import "Playlist.h"

@class Song;

@interface MomentsTableViewController : UITableViewController <MomentAddDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Playlist *currentPlaylist;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) UIButton *editButton;

@end
