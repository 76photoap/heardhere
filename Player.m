//
//  Player.m
//  Music
//
//  Created by Dianna Mertz on 11/16/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import "Player.h"

@interface Player ()
{
    UIButton *backButton;
}

@end

@implementation Player

@synthesize musicPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UI Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Music player setup
    
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self registerMediaPlayerNotifications];
    
    // Custom UI
    
    artistLabel.textColor = [UIColor colorWithRed:1.0 green:0.9176 blue:0.5843 alpha:1.0];
    artistLabel.font = [UIFont fontWithName:@"Arial" size:20.0];
    
    titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.9176 blue:0.5843 alpha:1.0];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:20.0];
    
    // Back Button
    
    UIImage *backImage = [UIImage imageNamed:@"ddplayer-back.png"];
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,backImage.size.width*.5, backImage.size.height*.5) ];
    [backButton setImage:backImage forState:UIControlStateNormal];
    self.navigationItem.hidesBackButton = TRUE;
    UIBarButtonItem *barBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barBackItem;
    
    [self showNWLocation];
}

-(void)viewDidAppear:(BOOL)animated {
    
    // Back Button
    
    [backButton addTarget:self action:@selector(popViewControllerWithAnimation) forControlEvents:UIControlEventTouchDown];
}

-(void)popViewControllerWithAnimation {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // update control button
	
	if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-pause.png"] forState:UIControlStateNormal];
	} else {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
    }
    
    // Update volume slider
    
    [volumeSlider setValue:[musicPlayer volume]];
    
    // Update now playing info
    
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    
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
							 object: musicPlayer];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_PlaybackStateChanged:)
							   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object: musicPlayer];
    
    [notificationCenter addObserver: self
						   selector: @selector (handle_VolumeChanged:)
							   name: MPMusicPlayerControllerVolumeDidChangeNotification
							 object: musicPlayer];
    
	[musicPlayer beginGeneratingPlaybackNotifications];
}

- (void) handle_NowPlayingItemChanged: (id) notification
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
    }
}

- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
	
	if (playbackState == MPMusicPlaybackStatePaused) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
        
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-pause.png"] forState:UIControlStateNormal];
        
	} else if (playbackState == MPMusicPlaybackStateStopped) {
        [playPauseButton setImage:[UIImage imageNamed:@"ddplayer-button-play.png"] forState:UIControlStateNormal];
		[musicPlayer stop];
        
        [self.navigationController popViewControllerAnimated:YES];
	}
}

- (void) handle_VolumeChanged: (id) notification
{
    [volumeSlider setValue:[musicPlayer volume]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object: musicPlayer];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
												  object: musicPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerVolumeDidChangeNotification
												  object: musicPlayer];
    
	[musicPlayer endGeneratingPlaybackNotifications];
}

#pragma mark - Controls

- (IBAction)playPause:(id)sender
{
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [musicPlayer pause];
        
    } else {
        [musicPlayer play];
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

- (IBAction)volumeSliderChanged:(id)sender
{
    [musicPlayer setVolume:volumeSlider.value];
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
             [self.map setRegion:MKCoordinateRegionMake(placemark.region.center, MKCoordinateSpanMake(0.01, 0.01))];
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