//
//  ChatCell.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/29/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell


@synthesize imageUser;
@synthesize labelDescription, labelLastMessage;
@synthesize labelElapsed, labelCounter;

- (void)bindData:(PFObject *)recent_
{
    imageUser.layer.cornerRadius = imageUser.frame.size.width/2;
    imageUser.layer.masksToBounds = YES;
   
    //TODO: Change this into last user;
    //PFUser *lastUser = recent[PF_RECENT_LASTUSER];
    
    //TODO:Download the last user's profile picture:
    //[imageUser setFile:lastUser[PF_USER_PICTURE]];
    [imageUser loadInBackground];
    
    //TODO: get last user's description and message
    //labelDescription.text = recent[PF_RECENT_DESCRIPTION];
    //labelLastMessage.text = recent[PF_RECENT_LASTMESSAGE];
    
    //TODO: get time
    //NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:recent[PF_RECENT_UPDATEDACTION]];
    //labelElapsed.text = TimeElapsed(seconds);
    
    //TODO:
    //int counter = [recent[PF_RECENT_COUNTER] intValue];
    //labelCounter.text = (counter == 0) ? @"" : [NSString stringWithFormat:@"%d new", counter];
}


//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
