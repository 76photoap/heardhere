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
}

@end

@implementation PlayerViewController

#pragma mark - UI Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Music player setup
    _musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self registerMediaPlayerNotifications];
    
    if ([_musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-pause.png"] forState:UIControlStateNormal];
	} else {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
    }
    
    // Back Button
    UIImage *backImage = [UIImage imageNamed:@"ddplayer-back.png"];
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
    //volumeSlider.backgroundColor = [UIColor clearColor];
    MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame: volumeView.bounds];
    [volumeView addSubview:myVolumeView];
    
    [self showNWLocation];
}

-(void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // update control button
	
	if ([_musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-pause.png"] forState:UIControlStateNormal];
	} else {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
    }

    // Update now playing info
    MPMediaItem *currentItem = [_musicPlayer nowPlayingItem];
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
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
    
}

#pragma mark - Register media player notifications

- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter addObserver: self
						   selector: @selector (handle_NowPlayingItemChanged:)
							   name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
							 object: _musicPlayer];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_PlaybackStateChanged:)
							   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object: _musicPlayer];

	[_musicPlayer beginGeneratingPlaybackNotifications];
}

- (void) handle_NowPlayingItemChanged: (id) notification
{
    if ([_musicPlayer playbackState] != MPMusicPlaybackStateStopped) {
        MPMediaItem *currentItem = [_musicPlayer nowPlayingItem];
        
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
        
        AppDelegate *myApp = (AppDelegate *) [[UIApplication sharedApplication]delegate];
        Song *songToSaveInDB = (Song *) [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:myApp.managedObjectContext];
        
        // Date
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
        //[self.songToSaveInDB setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
        //[self.songToSaveInDB setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
        [songToSaveInDB setListenDate:destinationDate];
        //[songToSaveInDB setListenTime:time];
        [songToSaveInDB setPersistentID:[currentItem valueForProperty:MPMediaItemPropertyPersistentID]];
        [songToSaveInDB.managedObjectContext save:nil];
    
        // Log
        NSLog(@"artist %@", [songToSaveInDB artist]);
        NSLog(@"album %@", [songToSaveInDB album]);
        NSLog(@"genre %@", [songToSaveInDB genre]);
        NSLog(@"title %@", [songToSaveInDB title]);
        NSLog(@"date %@", [songToSaveInDB listenDate]);
        NSLog(@"time %@", [songToSaveInDB listenTime]);
        NSLog(@"persistent id %@", [songToSaveInDB persistentID]);
    }
}

- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [_musicPlayer playbackState];
	
	if (playbackState == MPMusicPlaybackStatePaused) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
        
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-pause.png"] forState:UIControlStateNormal];
        
	} else if (playbackState == MPMusicPlaybackStateStopped) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
		[_musicPlayer stop];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object: _musicPlayer];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
												  object: _musicPlayer];

	[self.musicPlayer endGeneratingPlaybackNotifications];
}

#pragma mark - Controls

- (IBAction)playPause:(id)sender
{
    if ([_musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [_musicPlayer pause];
        
    } else {
        [_musicPlayer play];
    }
}

- (IBAction)nextSong:(id)sender
{
    [_musicPlayer skipToNextItem];
}

- (IBAction)previousSong:(id)sender
{
    [_musicPlayer skipToPreviousItem];
}

#pragma Map

// via Michael Markert's Map Demo

- (void)showNWLocation {
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder geocodeAddressString:@"86 Pike Street, Seattle, WA"
				 completionHandler:^(NSArray *placemarks, NSError *error)
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


@end
