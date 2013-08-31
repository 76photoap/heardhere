//
//  Player.h
//  Heard Here
//
//  Created by Dianna Mertz on 11/16/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MapKit/MapKit.h>
#import "Song.h"
#import <CoreLocation/CoreLocation.h>

@interface PlayerViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet UIButton *playPauseButton;
    IBOutlet UIView *volumeView;
    
    IBOutlet UILabel *artistLabel;
    IBOutlet UILabel *titleLabel;
}

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Song *songObject;

- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)previousSong:(id)sender;

- (void) registerMediaPlayerNotifications;

- (void)showNWLocation;

@end

