//
//  Detail.h
//  Heard Here
//
//  Created by Dianna Mertz on 11/5/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

@import UIKit;
@import MediaPlayer;
#import "Playlist.h"
#import "Song.h"

@interface DetailTableViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property NSString *playlistTitle;
@property (nonatomic, strong) Playlist *currentPlaylist;
@property (nonatomic, strong) Song *songInPlaylist;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) MPMediaQuery *mySongQuery;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) UIButton *editButton;
@property (strong, nonatomic) UIImageView *detailImage;

@end
