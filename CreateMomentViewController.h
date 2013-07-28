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

@property(nonatomic, retain) Playlist *playlist;
@property (weak, nonatomic) IBOutlet UITextField *momentName;
@property (strong, nonatomic) IBOutlet UIButton *fromButton;
@property (strong, nonatomic) IBOutlet UIButton *untilButton;
@property (strong, nonatomic) IBOutlet UIButton *fromTime;
@property (strong, nonatomic) IBOutlet UIButton *untilTime;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;

@property(nonatomic, assign) id <MomentAddDelegate> momentDelegate;

-(void)save;
-(void)cancel;

@end

@protocol MomentAddDelegate <NSObject>

-(void)createMomentViewController:(CreateMomentViewController *)createMomentViewController didAddMoment:(Playlist *)playlist;
@end
