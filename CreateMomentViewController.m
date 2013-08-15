//
//  CreateMomentViewController.m
//  Heard Here
//
//  Created by Dianna Mertz on 7/22/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import "CreateMomentViewController.h"
#import "AppDelegate.h"

@interface CreateMomentViewController ()
@end

@implementation CreateMomentViewController

@synthesize momentNameTextField;
@synthesize momentDelegate;
@synthesize playlistImageViewThumb;
@synthesize fromDateLabel;
@synthesize untilDateLabel;
@synthesize fromTimeLabel;
@synthesize untilTimeLabel;
@synthesize fromDatePicker;
@synthesize fromTimePicker;
@synthesize untilTimePicker;
@synthesize untilDatePicker;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext;
@synthesize untilDate;
@synthesize untilTime;
@synthesize fromDate;
@synthesize fromTime;
@synthesize songsToBeInNewPlaylistMutableSet;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    [momentNameTextField becomeFirstResponder];
    
    // Date Picker
    self.fromDateLabel.userInteractionEnabled = YES;
    self.untilDateLabel.userInteractionEnabled = YES;
    self.fromTimeLabel.userInteractionEnabled = YES;
    self.untilTimeLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *fromDateTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedFromDate:)];
    UITapGestureRecognizer *untilDateTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedUntilDate:)];
    UITapGestureRecognizer *fromTimeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedFromTime:)];
    UITapGestureRecognizer *untilTimeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedUntilTime:)];
    
    [self.fromDateLabel addGestureRecognizer:fromDateTapRecognizer];
    [self.fromTimeLabel addGestureRecognizer:fromTimeTapRecognizer];
    [self.untilDateLabel addGestureRecognizer:untilDateTapRecognizer];
    [self.untilTimeLabel addGestureRecognizer:untilTimeTapRecognizer];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    fromDatePicker = [[DateTimePicker alloc] initWithFrame:CGRectMake(0, screenHeight - 35, screenWidth, screenHeight + 35)];
    [fromDatePicker addTargetForDoneButton:self action:@selector(donePressedFromDate)];
    [self.view addSubview:fromDatePicker];
    fromDatePicker.hidden = YES;
    [fromDatePicker setMode:UIDatePickerModeDate];
    
    untilDatePicker = [[DateTimePicker alloc] initWithFrame:CGRectMake(0, screenHeight - 35, screenWidth, screenHeight + 35)];
    [untilDatePicker addTargetForDoneButton:self action:@selector(donePressedUntilDate)];
    [self.view addSubview:untilDatePicker];
    untilDatePicker.hidden = YES;
    [untilDatePicker setMode:UIDatePickerModeDate];
    
    fromTimePicker = [[DateTimePicker alloc] initWithFrame:CGRectMake(0, screenHeight - 35, screenWidth, screenHeight + 35)];
    [fromTimePicker addTargetForDoneButton:self action:@selector(donePressedFromTime)];
    [self.view addSubview:fromTimePicker];
    fromTimePicker.hidden = YES;
    [fromTimePicker setMode:UIDatePickerModeTime];
    
    untilTimePicker = [[DateTimePicker alloc] initWithFrame:CGRectMake(0, screenHeight - 35, screenWidth, screenHeight + 35)];
    [untilTimePicker addTargetForDoneButton:self action:@selector(donePressedUntilTime)];
    [self.view addSubview:untilTimePicker];
    untilTimePicker.hidden = YES;
    [untilTimePicker setMode:UIDatePickerModeTime];
    
    self.fromDateLabel.text = @"From Date";
    self.fromTimeLabel.text = @"From Time";
    self.untilDateLabel.text = @"Until Date";
    self.untilTimeLabel.text = @"Until Time";
    
    // song set
    self.songsToBeInNewPlaylistMutableSet = [[NSMutableSet alloc] init];
    
    // retrieve all songs
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Each song attached to the playlist is included in the array
    NSSet *songs = self.currentPlaylist.songs;

    for (Song *song in songs) {
        [songsToBeInNewPlaylistMutableSet addObject:song];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)donePressedFromDate {
    self.fromDateLabel.text = [fromDatePicker dateHasChanged:fromDatePicker.myDateString];
    
    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.fromDatePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
}

-(void)buttonPressedFromDate:(id)sender {
    if (momentNameTextField) {
        [self.momentNameTextField resignFirstResponder];
    }
    fromDatePicker.hidden = NO;
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    fromDatePicker.transform = CGAffineTransformMakeTranslation(0, -216);
    [UIView commitAnimations];
}

-(void)donePressedFromTime {
    self.fromTimeLabel.text = [fromTimePicker dateHasChanged:fromTimePicker.myDateString];
    
    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.fromTimePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
}

-(void)buttonPressedFromTime:(id)sender {
    if (momentNameTextField) {
        [self.momentNameTextField resignFirstResponder];
    }
    
    fromTimePicker.hidden = NO;
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    fromTimePicker.transform = CGAffineTransformMakeTranslation(0, -216);
    [UIView commitAnimations];
}

-(void)donePressedUntilTime {
    self.untilTimeLabel.text = [untilTimePicker dateHasChanged:untilTimePicker.myDateString];
    
    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.untilTimePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
}

-(void)buttonPressedUntilTime:(id)sender {
    if (momentNameTextField) {
        [self.momentNameTextField resignFirstResponder];
    }
    
    untilTimePicker.hidden = NO;
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    untilTimePicker.transform = CGAffineTransformMakeTranslation(0, -216);
    [UIView commitAnimations];
}

-(void)donePressedUntilDate {
    self.untilDateLabel.text = [untilDatePicker dateHasChanged:untilDatePicker.myDateString];
    
    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.untilDatePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
}

-(void)buttonPressedUntilDate:(id)sender {
    if (momentNameTextField) {
    [self.momentNameTextField resignFirstResponder];
    }
    
    untilDatePicker.hidden = NO;
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    untilDatePicker.transform = CGAffineTransformMakeTranslation(0, -216);
    [UIView commitAnimations];
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    AppDelegate *myApp = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entitySong = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:myApp.managedObjectContext];
    
    [fetchRequest setEntity:entitySong];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // format Date
    
    NSDateFormatter *dateFormatterFromDate = [[NSDateFormatter alloc] init];
    [dateFormatterFromDate setDateStyle:NSDateFormatterMediumStyle];
    self.fromDate = [dateFormatterFromDate dateFromString:self.fromDateLabel.text];
    
    NSDateFormatter *dateFormatterUntilDate = [[NSDateFormatter alloc] init];
    [dateFormatterUntilDate setDateStyle:NSDateFormatterMediumStyle];
    self.untilDate = [dateFormatterUntilDate dateFromString:self.untilDateLabel.text];
    
    NSDateFormatter *dateFormatterFromTime = [[NSDateFormatter alloc] init];
    [dateFormatterFromTime setDateFormat:@"h:mm a"];
    self.fromTime = [dateFormatterFromTime dateFromString:self.fromTimeLabel.text];

    NSDateFormatter *dateFormatterUntilTime = [[NSDateFormatter alloc] init];
    [dateFormatterUntilTime setDateFormat:@"h:mm a"];
    self.untilTime = [dateFormatterUntilTime dateFromString:self.untilTimeLabel.text];
    
    //
    
    NSPredicate *pred;
    
    pred = [NSPredicate predicateWithFormat:@"title == %@", self.song.title];
    
    [fetchRequest setPredicate:pred];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:myApp.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController = theFetchedResultsController;
    //_fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (IBAction)cancel:(id)sender
{
    [self.momentDelegate createMomentViewControllerDidCancel:[self currentPlaylist]];
}

- (IBAction)save:(id)sender
{
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Error in search %@, %@", error, [error userInfo]);
	}

    [self.currentPlaylist setName:momentNameTextField.text];
    [self.currentPlaylist setPhoto:playlistImageViewThumb.image];
    [self.currentPlaylist setFromDatePlaylist:fromDate];
    [self.currentPlaylist setFromTimePlaylist:fromTime];
    [self.currentPlaylist setUntilDatePlaylist:untilDate];
    [self.currentPlaylist setUntilTimePlaylist:untilTime];
    [self.currentPlaylist setSongs:songsToBeInNewPlaylistMutableSet];
    [self.momentDelegate createMomentViewControllerDidSave];
}


@end
