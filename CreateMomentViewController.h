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
{
    @private
    Playlist *playlist;
    id <MomentAddDelegate> momentDelegate;
}

@property(nonatomic, retain) Playlist *playlist;
@property(nonatomic, assign) id <MomentAddDelegate> momentDelegate;

-(void)save;
-(void)cancel;

@end

@protocol MomentAddDelegate <NSObject>

-(void)createMomentViewController:(CreateMomentViewController *)createMomentViewController didAddMoment:(Playlist *)playlist;
@end
