//
//  CollectionTableViewController.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 8/20/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
// 

#import "CollectionTableViewController.h"

@interface CollectionTableViewController ()
{
    NSMutableArray *posts;
}
@end

@implementation CollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationController hidesBottomBarWhenPushed];
    self.title = @"My Store";
    
    [self getCellInfo];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getCellInfo) forControlEvents:UIControlEventValueChanged];
//    [self.refreshControl endRefreshing];
    
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
    static NSString *CellIdentifier = @"HomeCellIdentifier";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
    // Configure the cell...
    
    PFObject *singlePost = [posts objectAtIndex:indexPath.row];
    cell.courseName.text = [singlePost objectForKey:@"course"];
    cell.courseNumber.text = [singlePost objectForKey:@"courseNumber"];
    cell.title.text = [singlePost objectForKey:@"title"];
    cell.author.text = [singlePost objectForKey:@"author"];
    cell.professor.text = [singlePost objectForKey:@"professor"];
    cell.price.text = [singlePost objectForKey:@"price"];
    }
    
    return cell;
    
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}

-(void)getCellInfo{


    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"sender" equalTo:[[PFUser currentUser]objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            posts =[[NSMutableArray alloc] initWithArray:objects];
            
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [self.refreshControl endRefreshing];
}

-(IBAction)star:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];

}


@end
