//
//  CreateMomentViewController.m
//  Heard Here
//
//  Created by Dianna Mertz on 7/22/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import "CreateMomentViewController.h"
#import "Playlist.h"
#import "Song.h"


@interface CreateMomentViewController ()
//-(void)hidePicker;
//-(void)showPicker;
@end

@implementation CreateMomentViewController

@synthesize momentName;
@synthesize momentDelegate;
@synthesize playlistImageViewThumb;
@synthesize fromDate;
@synthesize untilDate;
@synthesize fromTime;
@synthesize untilTime;
@synthesize fromDatePicker;
@synthesize fromTimePicker;
@synthesize untilTimePicker;
@synthesize untilDatePicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [momentName becomeFirstResponder];
    
    self.fromDate.userInteractionEnabled = YES;
    self.untilDate.userInteractionEnabled = YES;
    self.fromTime.userInteractionEnabled = YES;
    self.untilTime.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *fromDateTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedFromDate:)];
    UITapGestureRecognizer *untilDateTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedUntilDate:)];
    UITapGestureRecognizer *fromTimeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedFromTime:)];
    UITapGestureRecognizer *untilTimeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedUntilTime:)];
    
    [self.fromDate addGestureRecognizer:fromDateTapRecognizer];
    [self.fromTime addGestureRecognizer:fromTimeTapRecognizer];
    [self.untilDate addGestureRecognizer:untilDateTapRecognizer];
    [self.untilTime addGestureRecognizer:untilTimeTapRecognizer];
    
    //self.fromDate.backgroundColor = [UIColor lightGrayColor];
    
    
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
    
    self.fromDate.text = @"From Date";
    self.fromTime.text = @"From Time";
    self.untilDate.text = @"Until Date";
    self.untilTime.text = @"Until Time";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)donePressedFromDate {
    self.fromDate.text = [fromDatePicker dateHasChanged:fromDatePicker.myDateString];
    
    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.fromDatePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
}

-(void)buttonPressedFromDate:(id)sender {
    if (momentName) {
        [self.momentName resignFirstResponder];
    }
    fromDatePicker.hidden = NO;
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    fromDatePicker.transform = CGAffineTransformMakeTranslation(0, -216);
    [UIView commitAnimations];
}

-(void)donePressedFromTime {
    self.fromTime.text = [fromTimePicker dateHasChanged:fromTimePicker.myDateString];
    
    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.fromTimePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
}

-(void)buttonPressedFromTime:(id)sender {
    if (momentName) {
        [self.momentName resignFirstResponder];
    }
    
    fromTimePicker.hidden = NO;
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    fromTimePicker.transform = CGAffineTransformMakeTranslation(0, -216);
    [UIView commitAnimations];
}

-(void)donePressedUntilTime {
    self.untilTime.text = [untilTimePicker dateHasChanged:untilTimePicker.myDateString];
    
    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.untilTimePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
}

-(void)buttonPressedUntilTime:(id)sender {
    if (momentName) {
        [self.momentName resignFirstResponder];
    }
    
    untilTimePicker.hidden = NO;
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    untilTimePicker.transform = CGAffineTransformMakeTranslation(0, -216);
    [UIView commitAnimations];
}

-(void)donePressedUntilDate {
    self.untilDate.text = [untilDatePicker dateHasChanged:untilDatePicker.myDateString];
    
    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.untilDatePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
}

-(void)buttonPressedUntilDate:(id)sender {
    if (momentName) {
    [self.momentName resignFirstResponder];
    }
    
    untilDatePicker.hidden = NO;
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    untilDatePicker.transform = CGAffineTransformMakeTranslation(0, -216);
    [UIView commitAnimations];
}

- (IBAction)cancel:(id)sender
{
    [self.momentDelegate createMomentViewControllerDidCancel:[self currentPlaylist]];
}

- (IBAction)save:(id)sender
{
    [self.currentPlaylist setName:momentName.text];
    [self.currentPlaylist setPhoto:playlistImageViewThumb.image];
    //[self.currentPlaylist setSongs:<#(NSSet *)#>];
    [self.momentDelegate createMomentViewControllerDidSave];
}


@end
