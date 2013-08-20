//
//  Detail.h
//  Heard Here
//
//  Created by Dianna Mertz on 11/5/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playlist.h"
#import "Song.h"

@interface DetailTableViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate>
{
    UIButton *backButton;
}

@property NSString *playlistTitle;

@property (nonatomic, strong) Playlist *currentPlaylist;
@property (nonatomic, strong) Song *songInPlaylist;
@property (nonatomic, strong) NSMutableArray *songsInPlaylistMutableArray;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
