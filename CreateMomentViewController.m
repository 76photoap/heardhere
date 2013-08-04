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

@synthesize playlist;
@synthesize momentName;
@synthesize momentDelegate;

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
    
    [momentName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == momentName) {
        [momentName resignFirstResponder];
        [self savePlaylist];
    }
    return YES;
}

-(void)savePlaylist
{
    playlist.name = momentName.text;
    
    NSError *error = nil;
    if (![playlist.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.momentDelegate createMomentViewController:self didAddMoment:playlist];
}

- (IBAction)save:(id)sender
{
    playlist.name = momentName.text;
    
    NSError *error = nil;
    if (![playlist.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.momentDelegate createMomentViewController:self didAddMoment:playlist];
}

- (IBAction)cancel:(id)sender
{
    [playlist.managedObjectContext deleteObject:playlist];
    
    NSError *error = nil;
    if (![playlist.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.momentDelegate createMomentViewController:self didAddMoment:nil];
}

@end
