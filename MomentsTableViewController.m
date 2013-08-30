//
//  Playlists.m
//  Music
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//


#import "MomentsTableViewController.h"
#import "DetailTableViewController.h"
#import "Song.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface MomentsTableViewController ()
@end

@implementation MomentsTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

-(void)createMomentViewControllerDidCancel:(Playlist*)playlistToDelete
{
    NSManagedObjectContext *context = self.managedObjectContext;
   
    [context deleteObject:playlistToDelete];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createMomentViewControllerDidSave
{
    NSError *error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    if (![context save:&error]) {
        NSLog(@"Error! %@", error);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"createMomentSegue"]) {
        
        CreateMomentViewController *addController = (CreateMomentViewController*)[segue destinationViewController];
        addController.momentDelegate = self;
        
        Playlist *newPlaylist = (Playlist *) [NSEntityDescription insertNewObjectForEntityForName:@"Playlist" inManagedObjectContext:self.managedObjectContext];
        addController.currentPlaylist = newPlaylist;
    }
    
    if ([[segue identifier] isEqualToString:@"MomentSelected"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Playlist *playlistSelected = (Playlist *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        
        DetailTableViewController *detailcontroller = [segue destinationViewController];
        detailcontroller.currentPlaylist = playlistSelected;
        detailcontroller.playlistTitle = playlistSelected.name;
    }
}

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
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error! %@",error);
        abort();
    }
    
    // UI
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    self.tableView.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:153.0/255.0 blue:148.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];

    // Nav Bar Title
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Moments";
    label.frame = CGRectMake(0, 0, 100, 35);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:93.0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"Arial" size:25.0];
    label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.titleView = customButton.customView;
    
    /*
    // Nav Bar Edit Button
    UIImage *addMomentIcon = [UIImage imageNamed:@"ddplus-sign.png"];
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,addMomentIcon.size.width, addMomentIcon.size.height) ];
    addMomentIcon = [addMomentIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [editButton setImage:addMomentIcon forState:UIControlStateNormal];
    UIBarButtonItem *editPlaylist = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = editPlaylist;
    */
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
     NSInteger count = [[self.fetchedResultsController sections] count];
    
	if (count == 0) {
		count = 1;
	}
	NSLog(@"count: %ld", (long)count);
    return count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    if (![sectionInfo numberOfObjects]) {
        return 1;
    } else {
        return [sectionInfo numberOfObjects];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MomentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Playlist *playlist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [playlist name];
    
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ddTable-view-background.png"]];
    cell.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:153.0/255.0 blue:148.0/255.0 alpha:1.0];
    cell.textLabel.textColor = [UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1.0];
    
    //cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ddTable-view-background.png"]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:20.0];
    cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [self managedObjectContext];
        Playlist *playlistToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [context deleteObject:playlistToDelete];
		
		NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error! %@",error);
        }
	}
}

#pragma mark - Fetched results controller

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Playlist" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    fetchRequest.fetchBatchSize = 20;
        
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"name" cacheName:@"Root"];
        
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
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            Playlist *changedPlaylist = [self.fetchedResultsController objectAtIndexPath:indexPath];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = changedPlaylist.name;
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
