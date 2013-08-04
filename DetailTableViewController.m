//
//  Detail.m
//  Music
//
//  Created by Dianna Mertz on 11/5/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import "DetailTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Playlist.h"
#import "Song.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

@synthesize playlist;
@synthesize songs;

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

    // Nav Bar Edit Button
    UIImage *editImage = [UIImage imageNamed:@"dddetail-edit.png"];
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,editImage.size.width*.5, editImage.size.height*.5) ];
    [editButton setImage:editImage forState:UIControlStateNormal];
    UIBarButtonItem *editPlaylist = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = editPlaylist;
    
    // Nav Bar Title
    UILabel *label = [[UILabel alloc] init];
    label.text = self.playlistTitle;
    label.frame = CGRectMake(0, 0, 100, 35);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.2549 green:0.8 blue:0.70589 alpha:1.0];
    label.font = [UIFont fontWithName:@"Arial" size:25.0];
    label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.titleView = customButton.customView;
    
    // Nav Bar Back Button
    UIImage *backImage = [UIImage imageNamed:@"dddetail-back.png"];
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,backImage.size.width*.5, backImage.size.height*.5) ];
    [backButton setImage:backImage forState:UIControlStateNormal];
    self.navigationItem.hidesBackButton = TRUE;
    UIBarButtonItem *barBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barBackItem;
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
    /*
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    return [songs count];
     */
    NSInteger rows = 0;
    rows = [playlist.songs count];
    if (self.editing) {
        rows++;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        return 120;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        static NSString *CellIdentifier = @"PlaylistImageCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UIImageView *playlistImage = (UIImageView *)[cell viewWithTag:120];
        playlistImage.image = playlist.photo;
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"SongsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        /*
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        NSArray *songs = [songsQuery items];
        
        MPMediaItem *rowItem = [songs objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [rowItem valueForProperty:MPMediaItemPropertyTitle];
        cell.detailTextLabel.text = [rowItem valueForProperty:MPMediaItemPropertyArtist];
    
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ddTable-view-background.png"]];
        
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ddTable-view-background.png"]];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:20.0];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        return cell;
         */
        
        NSUInteger songCount = [playlist.songs count];
        NSInteger row = indexPath.row;
        
        if (indexPath.row < songCount) {
            static NSString *SongsCellIdentifier = @"SongsCell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:SongsCellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SongsCellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
            }
            Song *song = [songs objectAtIndex:row];
            cell.textLabel.text = song.title;
            cell.detailTextLabel.text = song.artist;
         
        } else {
            static NSString *addSongCellIdentifier = @"AddSongCell";
            cell = [tableView dequeueReusableCellWithIdentifier:addSongCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addSongCellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = @"Add Song";
    }
    return cell;
    }
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"NewSong"])
    {
        //NSIndexPath *rowToSelect = [self.tableView indexPathForSelectedRow];
        //Playlist *playlistQuery = (self.playlistArray)[rowToSelect.row];
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        NSArray *songsList = [songsQuery items];
        
        int selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        MPMediaItem *selectedItem = [[songsList objectAtIndex:selectedIndex] representativeItem];
        
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        
        [musicPlayer setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[songsQuery items]]];
        [musicPlayer setNowPlayingItem:selectedItem];
        
        [musicPlayer play];
        
        /*
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        NSArray *songsList = [songsQuery items];
        
        int selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        MPMediaItem *selectedItem = [[songsList objectAtIndex:selectedIndex] representativeItem];
        
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        
        [musicPlayer setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[songsQuery items]]];
        [musicPlayer setNowPlayingItem:selectedItem];
        
        [musicPlayer play];
         */
    }
}

@end
