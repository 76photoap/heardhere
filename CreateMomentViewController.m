//
//  CreateMomentViewController.m
//  Heard Here
//
//  Created by Dianna Mertz on 7/22/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import "CreateMomentViewController.h"
#import "Playlist.h"

@interface CreateMomentViewController ()

@end

@implementation CreateMomentViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_momentName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _momentName) {
        [_momentName resignFirstResponder];
        [self savePlaylist];
    }
    return YES;
}

-(void)savePlaylist
{
    _playlist.name = _momentName.text;
    
    NSError *error = nil;
    if (![_playlist.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.momentDelegate createMomentViewController:self didAddMoment:_playlist];
}

- (IBAction)save:(id)sender
{
    _playlist.name = _momentName.text;
    
    NSError *error = nil;
    if (![_playlist.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.momentDelegate createMomentViewController:self didAddMoment:_playlist];
}

- (IBAction)cancel:(id)sender
{
    [_playlist.managedObjectContext deleteObject:_playlist];
    
    NSError *error = nil;
    if (![_playlist.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.momentDelegate createMomentViewController:self didAddMoment:nil];
}

@end
