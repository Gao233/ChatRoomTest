//
//  ViewPostViewController.m
//  Tango
//
//  Created by Gaoyuan Chen on 8/27/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "ViewPostViewController.h"

@interface ViewPostViewController ()

@end

@implementation ViewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    static NSString *CellIdentifier = @"ReplyCellIdentifier";
    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:self options:nil];
    cell = [nibs objectAtIndex:0];
    
    return cell;
    
    
}


@end
