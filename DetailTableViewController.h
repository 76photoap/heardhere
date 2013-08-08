//
//  Detail.h
//  Music
//
//  Created by Dianna Mertz on 11/5/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Playlist;

@interface DetailTableViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    UIButton *backButton;
}

@property NSString *playlistTitle;

@property (nonatomic, retain) Playlist *currentPlaylist;
@property (nonatomic, retain) NSMutableArray *songs;

@end
