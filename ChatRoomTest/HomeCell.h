//
//  HomeCell.h
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 8/9/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HomeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *headline;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *reply;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end
