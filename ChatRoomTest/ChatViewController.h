//
//  ChatViewController.h
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/29/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessage.h>
#import <Parse/Parse.h>
#import "ChatView.h"
#import "ChatCell.h"
#define kTableViewRowHeight 66;

@interface ChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)write:(id)sender;

@end
