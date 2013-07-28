//
//  MomentTableViewCell.m
//  Heard Here
//
//  Created by Dianna Mertz on 7/23/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import "MomentTableViewCell.h"

@implementation MomentTableViewCell

@synthesize playlist;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
