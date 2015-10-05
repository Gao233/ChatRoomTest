//
//  ChatView.m
//  ChatRoomTest
//
//  Created by Gaoyuan Chen on 6/30/15.
//  Copyright (c) 2015 Gaoyuan Chen. All rights reserved.
//

#import "ChatView.h"

@interface ChatView (){

	NSString *groupId;
    NSTimer *timer;
    BOOL isLoading;
    NSString *lastMessageText;
    NSString *recentObjectId;

}

@end

@implementation ChatView


- (id)initWith:(NSString *)groupId_

{
    self = [super init];
    groupId = groupId_;
    isLoading = NO;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.messages = [[NSMutableArray alloc] init];
    
    self.currentUser = [PFUser currentUser];
//    self.title = self.reciever.username;

    self.senderId = self.currentUser.objectId;
    self.senderDisplayName = self.currentUser.username;

    self.showLoadEarlierMessagesHeader = YES;
    
    //Using Parse.com to download all the pass messages

    isLoading = NO;
    [self loadMessages];
    [self createRecentItem];
}

-(void)loadMessages{
    
    if(isLoading == NO){
    
    isLoading = YES;
    JSQMessage *lastMessage = [self.messages lastObject];
    lastMessageText = lastMessage.text;
        
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"groupId" equalTo:groupId];
    if (lastMessage != nil) [query whereKey:@"createdAt" greaterThan:lastMessage.date];
    [query orderByDescending:@"createdAt"];
    [query setLimit:50];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             self.automaticallyScrollsToMostRecentMessage = NO;
             for (PFObject *object in [objects reverseObjectEnumerator])
             {
                 NSDate *date = [object createdAt];
                 JSQMessage *message = [[JSQMessage alloc] initWithSenderId:object[@"senderId"] senderDisplayName:object[@"senderDisplayName"] date:date text:object[@"text"]];
                 [self.messages addObject:message];
             }
             
             if ([objects count] != 0)
             {
//                 [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
                 [self finishReceivingMessage];
                 [self scrollToBottomAnimated:NO];
             }
             self.automaticallyScrollsToMostRecentMessage = YES;
             
         }
                      isLoading = NO;
      }];
    }
    
        [self updateLastMessage];
}


-(void)createRecentItem{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Recent"];
    [query whereKey:@"groupId" equalTo:groupId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            NSLog(@"Error: %@", error);
        }else
        {
            if([objects count] == 0)
            {
                //Create a Recent item on Parse.com
                PFObject *recent = [PFObject objectWithClassName:@"Recent"];
                recent[@"RecieverFullName"] = self.reciever.username;
                recent[@"RecieverId"] = self.reciever.objectId;
                recent[@"SenderFullName"] = [self.currentUser username];
                recent[@"groupId"] = groupId;
                recent[@"LastMessage"] = @"";
                
                [recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        recentObjectId = recent.objectId;
                        
                        NSLog(@"id: %@", recent.objectId);
                    } else {
                        // There was a problem, check error.description
                    }
                }];
            }else
            {
                self.recentItem = [objects objectAtIndex:0];
                recentObjectId = self.recentItem.objectId;
            }
        }
    }];
}

-(void)updateLastMessage
{
    PFQuery *query = [PFQuery queryWithClassName:@"Recent"];

    // Retrieve the object by id
    [query getObjectInBackgroundWithId:recentObjectId
                                 block:^(PFObject *recent, NSError *error) {
                                     // Now let's update it with some new data. In this case, only cheatMode and score
                                     // will get sent to the cloud. playerName hasn't changed.
                                     recent[@"LastMessage"] = lastMessageText;
                                     
                                     [recent saveInBackground];
                                 }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [timer invalidate];
}
#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    //Create a messsage object and save it in array locally
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    [self.messages addObject:message];
    //Upload message to parse.com
    PFObject *singleMessage = [PFObject objectWithClassName:@"Messages"];
    singleMessage[@"senderId"] = senderId;
    singleMessage[@"senderDisplayName"] = senderDisplayName;
    singleMessage[@"groupId"] = groupId;
    singleMessage[@"text"] = text;
    [singleMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@, %@", error, [error userInfo]);
        }else{
            [JSQSystemSoundPlayer jsq_playMessageSentSound];
            [self loadMessages];
        }
    }];
    [self finishSendingMessageAnimated:YES];
    
  
}



- (void)didPressAccessoryButton:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //TODO: Add functions of sending photos, videos and location
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:
//            [self.demoData addPhotoMediaMessage];
//            break;
            
        case 1:
        {
//            __weak UICollectionView *weakView = self.collectionView;
//            
//            [self.demoData addLocationMediaMessageCompletion:^{
//                [weakView reloadData];
//            }];
        }
            break;
            
        case 2:
//            [self.demoData addVideoMediaMessage];
            break;
    }
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessageAnimated:YES];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}


- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Add avatar images
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     **/
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}



@end
