//
//  Player.h
//  Music
//
//  Created by Dianna Mertz on 11/16/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MapKit/MapKit.h>
#import "Song.h"
#import <CoreLocation/CoreLocation.h>

//@protocol AddSongToDBDelegate;

@interface PlayerViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet UIButton *playPauseButton;
    IBOutlet UISlider *volumeSlider;
    
    IBOutlet UILabel *artistLabel;
    IBOutlet UILabel *titleLabel;
}

//@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
//@property (nonatomic, strong) Song *songToSaveInDB;
//@property (assign) id <AddSongToDBDelegate> addSongDelegate;

- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)volumeSliderChanged:(id)sender;

- (void) registerMediaPlayerNotifications;

- (void)showNWLocation;

@end
/*
@protocol AddSongToDBDelegate
-(void)addSongToDB;
@end
 */
