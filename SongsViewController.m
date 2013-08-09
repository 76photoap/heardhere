//
//  SongsViewController.m
//  Heard Here
//
//  Created by Dianna Mertz on 8/9/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import "SongsViewController.h"

@interface SongsViewController ()

@end

@implementation SongsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Tab bar
    
    UITabBarItem *item1 = [[self.tabBarController.tabBar items] objectAtIndex:0];
    [item1 setFinishedSelectedImage:[UIImage imageNamed:@"Songs-tab-bar-icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Songs-tab-bar-icon.png"]];
    
    UITabBarItem *item2 = [[self.tabBarController.tabBar items] objectAtIndex:1];
    [item2 setFinishedSelectedImage:[UIImage imageNamed:@"Albums-tab-bar-icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Albums-tab-bar-icon.png"]];
    
    // Now playing button
    
    nowPlayingButton = [[UIBarButtonItem alloc] initWithTitle:@"NP" style:UIBarButtonItemStyleBordered target:self action:@selector(goToNowPlaying)];
    
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStateStopped) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = nowPlayingButton;
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter addObserver: self
						   selector: @selector (handle_PlaybackStateChanged:)
							   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object: [MPMusicPlayerController iPodMusicPlayer]];
    
    [[MPMusicPlayerController iPodMusicPlayer] beginGeneratingPlaybackNotifications];
    
}

- (void) goToNowPlaying
{
    [self performSegueWithIdentifier:@"NowPlaying" sender:self];
}

- (void) handle_PlaybackStateChanged: (id) notification
{
	if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStateStopped) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = nowPlayingButton;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
												  object: [MPMusicPlayerController iPodMusicPlayer]];
    
	[[MPMusicPlayerController iPodMusicPlayer] endGeneratingPlaybackNotifications];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    
    return [songs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    
    MPMediaItem *rowItem = [songs objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [rowItem valueForProperty:MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [rowItem valueForProperty:MPMediaItemPropertyArtist];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Table-view-background.png"]];
    cell.textLabel.textColor = [UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1.0];
    
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Table-view-selected-background.png"]];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"NewSong"])
    {
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        NSArray *songs = [songsQuery items];
        
        int selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        MPMediaItem *selectedItem = [[songs objectAtIndex:selectedIndex] representativeItem];
        
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        
        [musicPlayer setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[songsQuery items]]];
        [musicPlayer setNowPlayingItem:selectedItem];
        
        [musicPlayer play];
    }
}

@end
