//
//  ChatViewController.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/29/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()
{
    NSMutableArray *recents;
    NSString *groupId;
    NSString *localDiscription;
    NSString *licalLastMessage;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.tableview.tableFooterView = [UIView new];


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getRecentInfo];
}

#pragma mark - Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [recents count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
    
    NSUInteger row = [indexPath row];
    PFObject *recentItem = [recents objectAtIndex:row];
    
    cell.labelLastMessage.text = [recentItem objectForKey:@"LastMessage"];

    if([[[PFUser currentUser] username] isEqualToString: [[recents objectAtIndex:indexPath.row] objectForKey:@"SenderFullName"]])
    {
            cell.labelDescription.text = [recentItem objectForKey:@"RecieverFullName"];
    } else{
            cell.labelDescription.text = [recentItem objectForKey:@"SenderFullName"];
    }

    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
    
    //Create a gropuId for two users
    
    groupId = [[recents objectAtIndex:indexPath.row] objectForKey:@"groupId"];
    
    NSLog(@"Recent groupId is: %@", groupId);

    //Create a chat view when select a friend
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.hidesBottomBarWhenPushed = YES;
    if([[[PFUser currentUser] username] isEqualToString: [[recents objectAtIndex:indexPath.row] objectForKey:@"SenderFullName"]])
    {
        chatView.title = [[recents objectAtIndex:indexPath.row] objectForKey:@"RecieverFullName"];
    } else{
        chatView.title = [[recents objectAtIndex:indexPath.row] objectForKey:@"SenderFullName"];
    }
    
    [self.navigationController pushViewController:chatView animated:YES];
}

#pragma mark - IBActions
//
//- (IBAction)write:(id)sender {
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select a friend to start chatting with" message:nil delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil, nil];
//    [alert show];
//    
//    [self.tabBarController setSelectedIndex:2];
//    
//}

#pragma mark - Helper methods

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableViewRowHeight;
}

-(void) getRecentInfo{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Recent"];
    [query whereKey:@"groupId" containsString:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            recents = [[NSMutableArray alloc] initWithArray:objects];
             [self.tableview reloadData];
//            NSLog(@"recents: %@", recents);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
@end
