//
//  Detail.m
//  Heard Here
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
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error! %@",error);
        abort();
    }
    
    self.tableView.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:153.0/255.0 blue:148.0/255.0 alpha:1.0];
    
    // UI
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    self.tableView.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];

    
    // Nav Bar Title
    UILabel *label = [[UILabel alloc] init];
    label.text = self.playlistTitle;
    label.frame = CGRectMake(0, 0, 100, 35);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:93.0/255.0 alpha:1.0];
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
    backButton.tintColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:93.0/255.0 alpha:1.0];
    
    // Nav Bar Edit Button
    UIImage *editImage = [UIImage imageNamed:@"dddetail-edit.png"];
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton addTarget:self action:@selector(toggleEditing) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.frame = CGRectMake(0,0, editImage.size.width*.5, editImage.size.height*.5);
    [self.editButton setBackgroundImage:editImage forState:UIControlStateNormal];
    
    UIBarButtonItem *dEditButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    self.navigationItem.rightBarButtonItem = dEditButtonItem;
    
    self.navigationController.navigationItem.backBarButtonItem.customView.tintColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:93.0/255.0 alpha:1.0];
    
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

-(void)dealloc
{
    self.playlistTitle = nil;
    self.currentPlaylist = nil;
    self.songInPlaylist = nil;
    self.managedObjectContext = nil;
    self.fetchedResultsController = nil;
    self.musicPlayer = nil;
    self.mySongQuery = nil;
    self.doneButton = nil;
    self.editButton = nil;
}

#pragma mark - Table view data source

-(void)toggleEditing
{
    [self setEditing:!self.isEditing animated:YES];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleEditing)];
        self.navigationItem.rightBarButtonItem = doneButton;
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonSystemItemDone];
        self.navigationItem.title = @"Done";
    } else {
        UIImage *editImage = [UIImage imageNamed:@"dddetail-edit.png"];
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editButton addTarget:self action:@selector(toggleEditing) forControlEvents:UIControlEventTouchUpInside];
        self.editButton.frame = CGRectMake(0,0, editImage.size.width*.5, editImage.size.height*.5);
        [self.editButton setBackgroundImage:editImage forState:UIControlStateNormal];
        
        UIBarButtonItem *dEditButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
        self.navigationItem.rightBarButtonItem = dEditButtonItem;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[self.fetchedResultsController sections] count];
    
    if (count == 0) {
        count = 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [secInfo numberOfObjects] + 1;
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
        return cell;
        
    } else {
        
        static NSString *SongsCellIdentifier = @"SongsCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SongsCellIdentifier forIndexPath:indexPath];
        
        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:0];
        
        Song *song = [self.fetchedResultsController objectAtIndexPath:indexPathNew];
        
        cell.textLabel.text = [song title];
        cell.detailTextLabel.text = [song artist];

        cell.textLabel.textColor = [UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1.0];
        cell.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.currentPlaylist managedObjectContext];
        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:0];
        Song *songToDeleteInPlaylist = [self.fetchedResultsController objectAtIndexPath:indexPathNew];
        
        [self.currentPlaylist removeSongsObject:songToDeleteInPlaylist];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error! %@",error);
        }
    }
}

#pragma mark - Segue
// help from http://de.softuses.com/216719

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"NewSong"])
    {
        
        NSArray *allSongs = [self.fetchedResultsController fetchedObjects];
        NSMutableArray *allSongsMutable = [[NSMutableArray alloc] initWithCapacity:[allSongs count]];
        
        for (songInPlaylist in allSongs) {
            MPMediaQuery *mySongQuery = [[MPMediaQuery alloc] init];
            MPMediaPropertyPredicate *predicateTitle = [MPMediaPropertyPredicate predicateWithValue:songInPlaylist.title forProperty:MPMediaItemPropertyTitle];
            MPMediaPropertyPredicate *predicateArtist = [MPMediaPropertyPredicate predicateWithValue:songInPlaylist.artist forProperty:MPMediaItemPropertyArtist];
            [mySongQuery addFilterPredicate:predicateTitle];
            [mySongQuery addFilterPredicate:predicateArtist];
            NSArray *songsList = [mySongQuery items];
            [allSongsMutable addObject:[songsList objectAtIndex:0]];
        }
        MPMediaItemCollection *moment = [MPMediaItemCollection collectionWithItems:allSongsMutable];
        int selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        MPMediaItem *selectedItem = [[allSongsMutable objectAtIndex:selectedIndex-1] representativeItem];
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        
        [musicPlayer setQueueWithItemCollection:moment];
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
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"listenDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchRequest.fetchBatchSize = 20;
    
    NSPredicate *pred;
    pred = [NSPredicate predicateWithFormat:@"playlist CONTAINS[c] %@", self.currentPlaylist];
    [fetchRequest setPredicate:pred];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:0];
    NSIndexPath *indexPathNew2 = [NSIndexPath indexPathForRow:(indexPath.row +1) inSection:0];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathNew2] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            Song *changedSong = [self.fetchedResultsController objectAtIndexPath:indexPathNew];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPathNew];
            cell.textLabel.text = changedSong.title;
            cell.detailTextLabel.text = changedSong.artist;
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

@end