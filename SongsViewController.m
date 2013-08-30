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
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    //UITabBarItem *item1 = [[self.tabBarController.tabBar items] objectAtIndex:0];
    //[item1 initWithTitle:item1 image:[UIImage imageNamed:@"Songs-tab-bar-icon.png"] selectedImage:[UIImage imageNamed:@"Songs-tab-bar-icon.png"]];
    
   // [item1 setFinishedSelectedImage:[UIImage imageNamed:@"Songs-tab-bar-icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Songs-tab-bar-icon.png"]];
    
    //UITabBarItem *item2 = [[self.tabBarController.tabBar items] objectAtIndex:1];
    //[item2 setFinishedSelectedImage:[UIImage imageNamed:@"Albums-tab-bar-icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Albums-tab-bar-icon.png"]];
    
    // UI
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    self.tableView.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:153.0/255.0 blue:148.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    // Nav Bar Title
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Songs";
    label.frame = CGRectMake(0, 0, 100, 35);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:93.0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"Arial" size:25.0];
    label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.titleView = customButton.customView;
    
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
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1.0];
    cell.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:153.0/255.0 blue:148.0/255.0 alpha:1.0];
    
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
