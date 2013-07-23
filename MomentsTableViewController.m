//
//  Playlists.m
//  Music
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import "MomentsTableViewController.h"
#import "DetailTableViewController.h"
#import "Playlist.h"
#import "MomentTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MomentsTableViewController ()

@end

@implementation MomentsTableViewController

@synthesize managedObjectContext, fetchedResultsController;

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
    NSInteger count = [[fetchedResultsController sections] count];
    if (count == 0) {
		count = 1;
	}
	
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
	
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MomentCell";
    
    MomentTableViewCell *momentCell = (MomentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(momentCell == nil) {
        momentCell = [[MomentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        momentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:momentCell atIndexPath:indexPath];
    return momentCell;
    
    /*
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
     */
}

-(void)configureCell:(MomentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Playlist *playlist = (Playlist *)[fetchedResultsController objectAtIndexPath:indexPath];
    cell.playlist = playlist;
}



#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MomentSelected"])
    {
       /*
        DetailTableViewController *detailViewController = [segue destinationViewController];
        
        MPMediaQuery *ddPlaylistsQuery = [MPMediaQuery playlistsQuery];
        NSArray *playlists = [ddPlaylistsQuery collections];
        
        int selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        MPMediaPlaylist *selectedItem = [playlists objectAtIndex:selectedIndex];
        NSString *playlistTitle = [selectedItem valueForProperty:MPMediaPlaylistPropertyName];
        
        [detailViewController setPlaylistTitle:playlistTitle];
        */
        /*
        Playlist *playlist = (Playlist *)[fetchedResultsController objectAtIndexPath:indexPath];
        [self showPlaylist:playlist animated:YES];
        */
        
        //DetailTableViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Playlist *playlist = (Playlist *)[fetchedResultsController objectAtIndexPath:indexPath];
        
        
        [self showPlaylist:playlist animated:YES];
        
    }
}
 

@end
