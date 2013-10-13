//
//  Photo.h
//  Heard Here
//
//  Created by Dianna Mertz on 8/26/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

@import Foundation;
@import CoreData;

@class Playlist;

@interface Photo : NSManagedObject

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) Playlist *playlist;

@end
