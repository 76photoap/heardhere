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
#import <QuartzCore/QuartzCore.h> // for CALayer support

@interface PlayerViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, MKAnnotation>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) Song *currentSong;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;

-(NSString *)title;

//-(id)init;
//-(id)initWithPlacemark:(CLPlacemark *)placemark preferCoord:(BOOL)shouldPreferCoord;
//-(id)initWithPlacemark:(CLPlacemark *)placemark;
- (void)handle_NowPlayingItemChanged; //:(id)notification;
- (void)handle_PlaybackStateChanged; //:(id)notification;

- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)previousSong:(id)sender;

@end

