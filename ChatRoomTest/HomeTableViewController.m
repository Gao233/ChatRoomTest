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
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"pic_background"]];
    
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
    return 127;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    static NSString *CellIdentifier = @"HomeCellIdentifier";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
   
    PFObject *singlePost = [posts objectAtIndex:indexPath.row];
    cell.name.text = [singlePost objectForKey:@"name"];
    cell.headline.text = [singlePost objectForKey:@"title"];
    cell.content.text = [singlePost objectForKey:@"content"];
    
    
    return cell;


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

}

#pragma mark - Helper methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showLogin"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

@end
