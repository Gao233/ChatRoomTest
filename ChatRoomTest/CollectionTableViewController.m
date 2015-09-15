//
//  CollectionTableViewController.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 8/20/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
// 

#import "CollectionTableViewController.h"

@interface CollectionTableViewController ()

@end

@implementation CollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationController hidesBottomBarWhenPushed];
    self.title = @"My collections";

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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"HomeCellIdentifier";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
    // Configure the cell...
    
    return cell;
    
    
}

-(IBAction)star:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];

}


@end
