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

@synthesize momentName;
@synthesize momentDelegate;
@synthesize playlistImageViewThumb;

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
