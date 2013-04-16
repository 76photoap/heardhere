//
//  Playlists.m
//  Music
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import "Playlists.h"
#import "Detail.h"
#import <MediaPlayer/MediaPlayer.h>

@interface Playlists ()

@end

@implementation Playlists

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
    
    UIImage *plusImage = [UIImage imageNamed:@"ddplus-sign.png"];
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plusButton.bounds = CGRectMake(0,0,(plusImage.size.width)*.5, (plusImage.size.width)*.5);
    [plusButton setImage:plusImage forState:UIControlStateNormal];
    UIBarButtonItem *addPlaylist = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
    
    self.navigationItem.rightBarButtonItem = addPlaylist;
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
    MPMediaQuery *ddPlaylistsQuery = [MPMediaQuery playlistsQuery];
    NSArray *playlists = [ddPlaylistsQuery collections];
    
    return [playlists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    MPMediaQuery *ddPlaylistsQuery = [MPMediaQuery playlistsQuery];
    NSArray *playlists = [ddPlaylistsQuery collections];
    
    MPMediaPlaylist *playlist = [playlists objectAtIndex:indexPath.row];
    [cell.textLabel setText:[playlist valueForProperty:MPMediaPlaylistPropertyName]];

    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ddTable-view-background.png"]];
    cell.textLabel.textColor = [UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1.0];
    
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ddTable-view-background.png"]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:20.0];
    cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AlbumSelected"])
    {
        Detail *detailViewController = [segue destinationViewController];
        
        MPMediaQuery *ddPlaylistsQuery = [MPMediaQuery playlistsQuery];
        NSArray *playlists = [ddPlaylistsQuery collections];
        
        int selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        MPMediaPlaylist *selectedItem = [playlists objectAtIndex:selectedIndex];
        NSString *playlistTitle = [selectedItem valueForProperty:MPMediaPlaylistPropertyName];
        
        [detailViewController setPlaylistTitle:playlistTitle];
    }
  }

@end
