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

@synthesize momentNameTextField, momentDelegate, playlistImageViewThumb, fromDateLabel, untilDateLabel, fromTimeLabel, untilTimeLabel, fromDatePicker, fromTimePicker, untilTimePicker, untilDatePicker, managedObjectContext,fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    [momentNameTextField becomeFirstResponder];
    
    [self setupDatePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.momentNameTextField = nil;
    self.fromDateLabel = nil;
    self.fromTimeLabel = nil;
    self.untilDateLabel = nil;
    self.untilTimeLabel = nil;
    self.photoButton = nil;
    self.playlistImageViewThumb = nil;
    
    self.fromDatePicker = nil;
    self.untilDatePicker = nil;
    self.fromTimePicker = nil;
    self.untilTimePicker = nil;
    
    self.songsToBeInNewPlaylistSet = nil;
    
    self.momentDelegate = nil;
    
    self.songObject = nil;
    self.currentPlaylist = nil;
    
    self.managedObjectContext = nil;
    self.fetchedResultsController = nil;
}

#pragma DatePicker methods

-(void)setupDatePicker
{
    // Date Picker
    self.fromDateLabel.userInteractionEnabled = YES;
    self.untilDateLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *fromDateTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedFromDate:)];
    UITapGestureRecognizer *untilDateTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedUntilDate:)];
    
    [self.fromDateLabel addGestureRecognizer:fromDateTapRecognizer];
    [self.untilDateLabel addGestureRecognizer:untilDateTapRecognizer];
    
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
    
    self.fromDateLabel.text = @"From ";
    self.fromTimeLabel.text = @"";
    self.untilDateLabel.text = @"Until";
    self.untilTimeLabel.text = @"";
}

-(void)donePressedFromDate {
    self.fromDateLabel.text = [fromDatePicker dateHasChanged:fromDatePicker.myDateString];
    NSLog(@"self.fromDateLabel.text: %@", self.fromDateLabel.text);
    
    NSDateFormatter *dateFormatterFromDate = [[NSDateFormatter alloc] init];
    [dateFormatterFromDate setDateFormat:@"yyyy-MM-dd"];
    self.fromDate = [dateFormatterFromDate dateFromString:self.fromDateLabel.text];

    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.fromDatePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
    [self buttonPressedFromTime:self];
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
    
    NSArray *fromStringsArray = [[NSArray alloc] initWithObjects: self.fromDateLabel.text, self.fromTimeLabel.text, nil];
    NSString *fromStrings = [fromStringsArray componentsJoinedByString:@" "];

    NSDateFormatter *dateFormatterFromTime = [[NSDateFormatter alloc] init];
    [dateFormatterFromTime setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.fromTime = [dateFormatterFromTime dateFromString:fromStrings];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self.fromTime];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self.fromTime];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:self.fromTime];
    
    [self.currentPlaylist setFromDatePlaylist:destinationDate];
    
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

-(void)donePressedUntilDate {
    self.untilDateLabel.text = [untilDatePicker dateHasChanged:untilDatePicker.myDateString];
    
    NSDateFormatter *dateFormatterUntilDate = [[NSDateFormatter alloc] init];
    [dateFormatterUntilDate setDateFormat:@"yyyy-MM-dd"];
    self.untilDate = [dateFormatterUntilDate dateFromString:self.untilDateLabel.text];

    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.untilDatePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
    
    [self buttonPressedUntilTime:self];
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

-(void)donePressedUntilTime {
    self.untilTimeLabel.text = [untilTimePicker dateHasChanged:untilTimePicker.myDateString];
    
    NSArray *untilStringsArray = [[NSArray alloc] initWithObjects: self.untilDateLabel.text, self.untilTimeLabel.text, nil];
    NSString *untilStrings = [untilStringsArray componentsJoinedByString:@" "];
    
    NSDateFormatter *dateFormatterFromTime = [[NSDateFormatter alloc] init];
    [dateFormatterFromTime setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.untilTime = [dateFormatterFromTime dateFromString:untilStrings];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self.untilTime];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self.untilTime];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:self.untilTime];
    
    [self.currentPlaylist setUntilDatePlaylist:destinationDate];
    
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

#pragma Fetched Results Controller

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:self.currentPlaylist.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"listenDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *pred;
    pred = [NSPredicate predicateWithFormat:@"(listenDate >= %@) AND (listenDate <= %@)", self.currentPlaylist.fromDatePlaylist, self.currentPlaylist.untilDatePlaylist];
    //pred = [NSPredicate predicateWithFormat:@"listenDate >= %@", self.currentPlaylist.fromDatePlaylist];
    [fetchRequest setPredicate:pred];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.currentPlaylist.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSArray *objects = [self.songObject.managedObjectContext executeFetchRequest:fetchRequest  error:&error];
    self.songsToBeInNewPlaylistSet = [NSSet setWithArray:[objects valueForKey:@"listenDate"]];

    return _fetchedResultsController;
}

- (IBAction)cancel:(id)sender
{
    [self.momentDelegate createMomentViewControllerDidCancel:[self currentPlaylist]];
}

- (IBAction)save:(id)sender
{
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error! %@",error);
        abort();
    }
    
    self.songsToBeInNewPlaylistSet = [NSSet setWithArray:[self.fetchedResultsController fetchedObjects]];
    
    // Get Playlist creationDate
    NSDate* sourceDate = [NSDate date];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    NSLog(@"current date: %@", destinationDate);
    [self.currentPlaylist setCreationDate:destinationDate];
    [self.currentPlaylist setName:momentNameTextField.text];
    [self.currentPlaylist setSongs:self.songsToBeInNewPlaylistSet];
    NSLog(@"currentPlaylist info: %@", self.currentPlaylist);
    
    [self.momentDelegate createMomentViewControllerDidSave];
}

@end
