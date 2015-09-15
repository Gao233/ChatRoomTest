//
//  FriendsViewController.h
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/26/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "EditFriendsViewController.h"
#import "ChatView.h"

@interface FriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
    
@property (strong, nonatomic) IBOutlet UITableView *tableview;


@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) PFUser *chatUser;
@property (nonatomic, strong) PFRelation *friendsRelation;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *lastMessage;


@end
