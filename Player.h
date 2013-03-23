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

@interface Player : UIViewController <MKMapViewDelegate>
{
    IBOutlet UIButton *playPauseButton;
    IBOutlet UISlider *volumeSlider;
    
    IBOutlet UILabel *artistLabel;
    IBOutlet UILabel *titleLabel;
}

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;

- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)volumeSliderChanged:(id)sender;

- (void) registerMediaPlayerNotifications;

- (void)showNWLocation;

@end
