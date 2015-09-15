//
//  HomeTableViewController.h
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/22/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HomeCell.h"

@interface HomeTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>{
    
}

@property (strong, nonatomic) PFUser *currentUser;


@end
