//
//  EditFriendsViewController.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/27/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "EditFriendsViewController.h"

@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    //set up current user for later usage
    self.currentUser = [PFUser currentUser];
    //Display all users in "Edit friends" interface
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(error){
            NSLog(@"Error: %@ %@",error, [error userInfo]);
        }else{
            self.allUsers = objects;
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
    return [self.allUsers count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //My code
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row]; //User that is tapped on
    cell.textLabel.text = user.username;
    
    
    if([self isFriend: user]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Manually deselect the row background color after clicked
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row]; //User that is tapped on
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"firendsRelation"];
    
    if([self isFriend:user]){//Check if the user is friend
        
        //Remove the friend!!
        //1.Remove the checkmark
        cell.accessoryType = UITableViewCellAccessoryNone;
        //2.Remove from friend array
        for(PFUser *friend in self.friends){
            
            if([friend.objectId isEqualToString:user.objectId]){
                [self.friends removeObject:friend];
                break;
            }
        }
        //3.Remove from backend
        [friendsRelation removeObject:user];
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.friends addObject:user];
        //Relate data using PFRelation (Add friends)
        [friendsRelation addObject:user];
    }
    //Save to backend
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        if(error){
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
    }];
}

#pragma mark - Helper Methods

-(BOOL) isFriend:(PFUser *)user{
    
    for(PFUser *friend in self.friends){
        
        if([friend.objectId isEqualToString:user.objectId]){
            return YES;
        }
        
    }
    return NO;
}

@end
