//
//  Player.h
//  Heard Here
//
//  Created by Dianna Mertz on 11/16/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

@import UIKit;
@import MediaPlayer;
@import MapKit;
@import CoreLocation;
@import QuartzCore;
#import "Song.h"

@interface PlayerViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, MKAnnotation>


@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) Song *currentSong;
@property (nonatomic, strong) NSMutableArray *latitudeArray;
@property (nonatomic, strong) NSMutableArray *longitudeArray;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (assign) BOOL previousController;

- (void)registerMediaPlayerNotifications;

- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)previousSong:(id)sender;

@end

