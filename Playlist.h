//
//  Playlist.h
//  Heard Here
//
//  Created by Dianna Mertz on 7/22/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Song;

@interface Playlist : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id photo;
@property (nonatomic, retain) NSSet *songs;
@property (nonatomic, retain) NSDate *fromDatePlaylist;
@property (nonatomic, retain) NSDate *fromTimePlaylist;
@property (nonatomic, retain) NSDate *untilDatePlaylist;
@property (nonatomic, retain) NSDate *untilTimePlaylist;
@end

@interface Playlist (CoreDataGeneratedAccessors)

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
