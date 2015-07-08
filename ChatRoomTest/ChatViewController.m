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
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}



#pragma mark - Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //My code
  
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - IBActions

- (IBAction)write:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select a friend to start chatting :]" message:nil delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil, nil];
    [alert show];
    [self.tabBarController setSelectedIndex:2];
}
@end
