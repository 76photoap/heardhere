//
//  Photo.h
//  Heard Here
//
//  Created by Dianna Mertz on 8/26/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Playlist;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * name;
@property (nonatomic, retain) Playlist *playlist;

@end
