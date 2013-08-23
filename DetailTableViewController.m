//
//  Detail.m
//  Music
//
//  Created by Dianna Mertz on 11/5/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import "DetailTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface DetailTableViewController ()
@end

@implementation DetailTableViewController

@synthesize currentPlaylist;
@synthesize songInPlaylist;
@synthesize songsInPlaylistArrayArtists;
@synthesize songsInPlaylistArrayTitles;
@synthesize fetchedResultsController = _fetchedResultsController;


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
    /*
    NSSortDescriptor *sortDescriptorTitle = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptorsTitles = [[NSArray alloc] initWithObjects:sortDescriptorTitle, nil];
    self.songsInPlaylistArrayTitles = [self.currentPlaylist.songs sortedArrayUsingDescriptors:sortDescriptorsTitles];

    NSSortDescriptor *sortDescriptorArtist = [[NSSortDescriptor alloc] initWithKey:@"artist" ascending:NO];
    NSArray *sortDescriptorsArtists = [[NSArray alloc] initWithObjects:sortDescriptorArtist, nil];
    self.songsInPlaylistArrayArtists = [self.currentPlaylist.songs sortedArrayUsingDescriptors:sortDescriptorsArtists];
    */
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error! %@",error);
        abort();
    }
    
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
    
    [super viewDidLoad];
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
    NSInteger count = [[self.fetchedResultsController sections] count];
        
        if (count == 0) {
            count = 1;
        }
    
    NSLog(@"numberofsectionsinttableview: %ld", (long)count);
        return count;

    return [self.songsInPlaylistArrayArtists count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"numberofrowsinsection: %lu", (unsigned long)[secInfo numberOfObjects]);
    return [secInfo numberOfObjects];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        UIImageView *playlistImage = (UIImageView *)[cell viewWithTag:120];
        //playlistImage.image = playlist.photo;
        playlistImage.image = [UIImage imageNamed:@"ddme_binocs.jpg"];
        return cell;
        
    } else {
    
        static NSString *SongsCellIdentifier = @"SongsCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SongsCellIdentifier];
        
        Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        cell.textLabel.text = [song title];
        cell.detailTextLabel.text = [song artist];
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ddTable-view-background.png"]];
        cell.textLabel.textColor = [UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1.0];
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ddTable-view-background.png"]];
        
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:20.0];
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"NewSong"])
    {
        NSIndexPath *rowSelected = [self.tableView indexPathForSelectedRow];
        Song *song = (Song*)[self.fetchedResultsController objectAtIndexPath:rowSelected];
        NSLog(@"songInPlaylist: %@", song);
        NSLog(@"songInPlaylist.title: %@", song.title);
        NSLog(@"songInPlaylist.persistentID: %@", song.persistentID);
        
        MPMediaPropertyPredicate *predicateTitle = [MPMediaPropertyPredicate predicateWithValue:song.title forProperty:MPMediaItemPropertyTitle];
        
        MPMediaPropertyPredicate *predicateArtist = [MPMediaPropertyPredicate predicateWithValue:song.artist forProperty:MPMediaItemPropertyArtist];
        
       // MPMediaPropertyPredicate *predicatePersistentID = [MPMediaPropertyPredicate predicateWithValue:song.persistentID forProperty:MPMediaItemPropertyPersistentID];
        
        MPMediaQuery *mySongQuery = [[MPMediaQuery alloc] init];
        [mySongQuery addFilterPredicate:predicateTitle];
        [mySongQuery addFilterPredicate:predicateArtist];
        //[mySongQuery addFilterPredicate:predicatePersistentID];
        [MPMediaQuery songsQuery];
        
        NSArray *songsList = [mySongQuery items];
        NSLog(@"count: %lu", (unsigned long)[songsList count]);
        MPMediaItem *selectedItem = [[songsList objectAtIndex:0] representativeItem];
        
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
        NSLog(@"mySongQuery = %@", mySongQuery);
        
        [musicPlayer setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[mySongQuery items]]];
        [musicPlayer setNowPlayingItem:selectedItem];
        
        [musicPlayer play];
    }
}


-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:self.currentPlaylist.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchRequest.fetchBatchSize = 20;
    
    NSLog(@"self.currentPlaylist.songs:::: %@", self.currentPlaylist.songs);
    NSPredicate *pred;
    pred = [NSPredicate predicateWithFormat:@"playlist CONTAINS[c] %@", self.currentPlaylist];
    [fetchRequest setPredicate:pred];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
     
}

@end
