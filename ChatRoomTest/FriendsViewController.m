//
//  FriendsViewController.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/26/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"firendsRelation"];
    
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(error){
            NSLog(@"Error; %@ %@", error, [error userInfo]);
        }else{
            self.friends = objects;
            
            [self.tableview reloadData];
            
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.friends count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    
    return cell;
    
}

#pragma mark - For Chat View
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
    
    //Create a chat view when select a friend
    ChatView *chatView = [[ChatView alloc] init];
    chatView.hidesBottomBarWhenPushed = YES;
    chatView.reciever = [self.friends objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:chatView animated:YES];
    
}

#pragma mark - Helper Method

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showEditFriends"]){
        
        EditFriendsViewController *viewController = (EditFriendsViewController *)segue.destinationViewController;
        viewController.friends = [NSMutableArray arrayWithArray:self.friends];
        
    }else if([segue.identifier isEqualToString:@"showChatViewFromFriends"]){
        //pass the username to chat view

        //create a message object for current user and reciever
        //I need: reciever name, reciever's profile picture, the messages they are sending(as mutable array)
    }
    
}


@end
