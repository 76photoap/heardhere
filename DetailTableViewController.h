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
#import <MediaPlayer/MediaPlayer.h>

@interface DetailTableViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate>
{
    UIButton *backButton;
}

@property NSString *playlistTitle;
@property (nonatomic, strong) Playlist *currentPlaylist;
@property (nonatomic, strong) Song *songInPlaylist;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) MPMediaQuery *mySongQuery;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) UIButton *editButton;

@end
