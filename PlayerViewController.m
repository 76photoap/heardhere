//
//  Player.m
//  Heard Here
//
//  Created by Dianna Mertz on 11/16/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import "PlayerViewController.h"
#import "AppDelegate.h"

@interface PlayerViewController ()
{
    UIButton *backButton;
    IBOutlet UIView *volumeView;
    IBOutlet UIButton *playPauseButton;
    IBOutlet UILabel *artistLabel;
    IBOutlet UILabel *titleLabel;
    MPMusicPlayerController *musicPlayer;
    BOOL _preferCoord;
}

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, strong) Song *songObject;
@property (nonatomic, strong) CLPlacemark *placemark;

@end

@implementation PlayerViewController

#pragma mark - View Controller
/*
-(id)initWithPlacemark:(CLPlacemark *)placemark preferCoord:(BOOL)shouldPreferCoord
{
    self = [super init];
    if (self) {
        _placemark = placemark;
        _preferCoord = shouldPreferCoord;
        //[self registerMediaPlayerNotifications];
        //NSLog(@"initwithplacemark");
    }
    return self;
}

-(id)initWithPlacemark:(CLPlacemark *)placemark
{
    return [self initWithPlacemark:placemark preferCoord:NO];
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self registerMediaPlayerNotifications];
    
    self.view.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    
    // Back Button
    UIImage *backImage = [UIImage imageNamed:@"player-back.png"];
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,backImage.size.width*.5, backImage.size.height*.5) ];
    [backButton setImage:backImage forState:UIControlStateNormal];
    self.navigationItem.hidesBackButton = TRUE;
    UIBarButtonItem *barBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barBackItem;
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    // Custom UI
    artistLabel.textColor = [UIColor colorWithRed:1.0 green:0.9176 blue:0.5843 alpha:1.0];
    artistLabel.font = [UIFont fontWithName:@"Arial" size:16.0];
    
    titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.9176 blue:0.5843 alpha:1.0];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:16.0];
    
    // Volume View
    volumeView.backgroundColor = [UIColor clearColor];
    MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame: volumeView.bounds];
    [volumeView addSubview:myVolumeView];
    
    [[self locationManager] startUpdatingLocation];
}

-(void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-pause.png"] forState:UIControlStateNormal];
    } else {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
    }
    
    // Update now playing info
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    NSString *titleString = [[musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        titleLabel.text = titleString;
    } else {
        titleLabel.text = @"Unknown Title";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        artistLabel.text = artistString;
    } else {
        artistLabel.text = @"Unknown Artist";
    }
    
    [self showLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object: musicPlayer];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                  object: musicPlayer];
    
    [musicPlayer endGeneratingPlaybackNotifications];
    
    self.songObject = nil;
    backButton = nil;
    self.map = nil;
    //musicPlayer = nil;
}

#pragma mark - Register media player notifications

- (void)registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    
    [musicPlayer beginGeneratingPlaybackNotifications];
}
 
- (void)handle_NowPlayingItemChanged:(id)notification
{
    if ([musicPlayer playbackState] != MPMusicPlaybackStateStopped) {
        
        MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
        
        NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
        if (titleString) {
            titleLabel.text = titleString;
        } else {
            titleLabel.text = @"Unknown title";
        }
        
        NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        if (artistString) {
            artistLabel.text = artistString;
        } else {
            artistLabel.text = @"Unknown artist";
        }
        
        [self showLocation];
        
        AppDelegate *myApp = (AppDelegate *) [[UIApplication sharedApplication]delegate];
        Song *songToSaveInDB = (Song *) [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:myApp.managedObjectContext];
        
        // Grab Location
        CLLocation *location = [_locationManager location];
        if (!location) {
            return;
        }
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        // Grab Date
        NSDate* sourceDate = [NSDate date];
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
        
        // send to DB
        [songToSaveInDB setAlbum:[currentItem valueForProperty:MPMediaItemPropertyAlbumTitle]];
        [songToSaveInDB setArtist:[currentItem valueForProperty:MPMediaItemPropertyArtist]];
        [songToSaveInDB setGenre:[currentItem valueForProperty:MPMediaItemPropertyGenre]];
        [songToSaveInDB setTitle:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
        [songToSaveInDB setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
        [songToSaveInDB setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
        [songToSaveInDB setListenDate:destinationDate];
        [songToSaveInDB setPersistentID:[currentItem valueForProperty:MPMediaItemPropertyPersistentID]];
        [songToSaveInDB.managedObjectContext save:nil];
    }
}


- (void)handle_PlaybackStateChanged:(id)notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    NSLog(@"playbackState: %ld", (long)playbackState);
    if (playbackState == MPMusicPlaybackStatePaused) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-pause.png"] forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStateInterrupted) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
        
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
    }
 
}

#pragma mark - Controls

- (IBAction)playPause:(id)sender
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    
    if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused || playbackState == MPMusicPlaybackStateInterrupted) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-pause.png"] forState:UIControlStateNormal];
        [musicPlayer play];
        
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
        [musicPlayer pause];
    }
}

- (IBAction)nextSong:(id)sender
{
    [musicPlayer skipToNextItem];
}

- (IBAction)previousSong:(id)sender
{
    [musicPlayer skipToPreviousItem];
}

#pragma Map

- (void)showLocation {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"86 Pike Street, Seattle, WA" completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for(CLPlacemark* placemark in placemarks) {
             MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
             annotation.title = @"Pikes Place Market";
             annotation.subtitle = placemark.locality;
             annotation.coordinate = placemark.location.coordinate;
             [self.map addAnnotation:annotation];
             //[self.map setRegion:MKCoordinateRegionMake(placemark.region.center, MKCoordinateSpanMake(0.01, 0.01))];
         }
     }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:view.annotation.title
                                                    message:@"You were here, at Pike's Place Market"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    return nil;
}

// Saving location of played song

#pragma mark Location manager

- (CLLocationManager *)locationManager {
	
    if (_locationManager != nil) {
		return _locationManager;
	}
	
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[_locationManager setDelegate:self];
	
	return _locationManager;
}

#pragma mark - MKAnnotation Protocol (for map pin)

- (CLLocationCoordinate2D)coordinate
{
    return self.placemark.location.coordinate;
}

- (NSString *)title
{
    return self.placemark.thoroughfare;
}


@end