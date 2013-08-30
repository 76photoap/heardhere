//
//  Song.h
//  Heard Here
//
//  Created by Dianna Mertz on 8/26/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Playlist;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSDate * listenDate;
@property (nonatomic, retain) NSDate * listenTime;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * persistentID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *playlist;
@end

@interface Song (CoreDataGeneratedAccessors)

- (void)addPlaylistObject:(Playlist *)value;
- (void)removePlaylistObject:(Playlist *)value;
- (void)addPlaylist:(NSSet *)values;
- (void)removePlaylist:(NSSet *)values;

@end
