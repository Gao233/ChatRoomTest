//
//  HomeTableViewController.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/22/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController (){

    NSMutableArray *posts;
    NSString *groupId;
}

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.currentUser = [PFUser currentUser];
    
    if(self.currentUser){
        NSLog(@"Current User: %@", [self.currentUser username]);
        
    }else{
        
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"pic_background"]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getCellInfo) forControlEvents:UIControlEventValueChanged];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [self getCellInfo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [posts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    static NSString *CellIdentifier = @"HomeCellIdentifier";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
   
    PFObject *singlePost = [posts objectAtIndex:indexPath.row];
    cell.courseName.text = [singlePost objectForKey:@"course"];
    cell.courseNumber.text = [singlePost objectForKey:@"courseNumber"];
    cell.title.text = [singlePost objectForKey:@"title"];
    cell.author.text = [singlePost objectForKey:@"author"];
    cell.professor.text = [singlePost objectForKey:@"professor"];
    cell.price.text = [singlePost objectForKey:@"price"];
    if([[singlePost objectForKey:@"sold"] isEqualToString:@"0"]){
        cell.stamp.image = nil;
    }else{
        cell.stamp.image = [UIImage imageNamed:@"sold.jpg"];
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    //Create a gropuId for two users
    
    NSString *senderId = [[posts objectAtIndex:indexPath.row] objectForKey:@"sender"];
    
    if([senderId isEqualToString:[[PFUser currentUser] objectId]]){
        //Click it's own post, do nothing
    }else{
        
        NSString *id1 = senderId;
        NSString *id2 = [[PFUser currentUser] objectId];
        groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];
        
    //Create a chat view when select a friend
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.hidesBottomBarWhenPushed = YES;
    chatView.title = [[posts objectAtIndex:indexPath.row] objectForKey:@"senderName"];
    
    [self.navigationController pushViewController:chatView animated:YES];
    }
    
}

- (void)getCellInfo{

    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            posts =[[NSMutableArray alloc] initWithArray:objects];
            
            [self.tableView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [self.refreshControl endRefreshing];
}

#pragma mark - Helper methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showLogin"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

@end
