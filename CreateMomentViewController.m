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
@synthesize picker;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [momentName becomeFirstResponder];
    
    self.fromDate.userInteractionEnabled = YES;
    UITapGestureRecognizer *fromDateTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed:)];
    
    [self.fromDate addGestureRecognizer:fromDateTapRecognizer];
    
    self.fromDate.backgroundColor = [UIColor lightGrayColor];
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    picker = [[DateTimePicker alloc] initWithFrame:CGRectMake(0, screenHeight/2 - 35, screenWidth, screenHeight/2 + 35)];
    [picker addTargetForDoneButton:self action:@selector(donePressed)];
    [self.view addSubview:picker];
    picker.hidden = YES;
    [picker setMode:UIDatePickerModeDate];
    
    self.fromDate.text = @"From Date";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)donePressed {
    self.fromDate.text = [picker dateHasChanged:picker.myDateString];
    picker.hidden = YES;
}

-(void)buttonPressed:(id)sender {
    [self.momentName resignFirstResponder];
    picker.hidden = NO;
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
