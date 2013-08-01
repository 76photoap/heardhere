//
//  CreateMomentViewController.h
//  Heard Here
//
//  Created by Dianna Mertz on 7/22/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol MomentAddDelegate;
@class Playlist;

@interface CreateMomentViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Playlist *playlist;
@property (strong, nonatomic) IBOutlet UITextField *momentName;
@property (strong, nonatomic) IBOutlet UIButton *fromButton;
@property (strong, nonatomic) IBOutlet UIButton *untilButton;
@property (strong, nonatomic) IBOutlet UIButton *fromTime;
@property (strong, nonatomic) IBOutlet UIButton *untilTime;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;


@property(nonatomic, assign) id <MomentAddDelegate> momentDelegate;

- (void)savePlaylist;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;


@end

@protocol MomentAddDelegate <NSObject>

-(void)createMomentViewController:(CreateMomentViewController *)createMomentViewController didAddMoment:(Playlist *)playlist;
@end
