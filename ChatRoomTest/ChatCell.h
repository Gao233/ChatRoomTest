//
//  ChatCell.h
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/29/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI.h>

@interface ChatCell : UITableViewCell{
    IBOutlet UILabel *labelDescription;
    IBOutlet UILabel *labelLastMessage;
}

@property (strong, nonatomic) IBOutlet PFImageView *imageUser;
@property (strong, retain) IBOutlet UILabel *labelDescription;
@property (strong, retain) IBOutlet UILabel *labelLastMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelElapsed;
@property (strong, nonatomic) IBOutlet UILabel *labelCounter;

@end
