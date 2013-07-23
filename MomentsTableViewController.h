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
@class MomentTableViewCell;

@interface MomentsTableViewController : UITableViewController <MomentAddDelegate, NSFetchedResultsControllerDelegate>
{
    @private
        NSFetchedResultsController *fetchedResultsController;
        NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

//@property (weak, nonatomic) IBOutlet UIButton *logoButton;
-(void)showPlaylist:(Playlist *)playlist animated:(BOOL)animated;
-(void)configureCell:(MomentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
