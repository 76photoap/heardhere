//
//  CreateMomentViewController.h
//  Heard Here
//
//  Created by Dianna Mertz on 7/22/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DetailTableViewController.h"
#import "DateTimePicker.h"

@protocol MomentAddDelegate;
@class Playlist;

@interface CreateMomentViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *momentName;
@property (strong, nonatomic) IBOutlet UILabel *fromDate;
@property (strong, nonatomic) IBOutlet UILabel *fromTime;
@property (strong, nonatomic) IBOutlet UILabel *untilDate;
@property (strong, nonatomic) IBOutlet UILabel *untilTime;

@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UIImageView *playlistImageViewThumb;
@property (strong, nonatomic) DateTimePicker *fromDatePicker;
@property (strong, nonatomic) DateTimePicker *untilDatePicker;
@property (strong, nonatomic) DateTimePicker *fromTimePicker;
@property (strong, nonatomic) DateTimePicker *untilTimePicker;

@property(nonatomic, weak) id <MomentAddDelegate> momentDelegate;

@property(nonatomic, strong) Playlist *currentPlaylist;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol MomentAddDelegate
-(void)createMomentViewControllerDidSave;
-(void)createMomentViewControllerDidCancel:(Playlist*)playlistToDelete;
@end
