//
//  MVSViewController.m
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import "MVSViewController.h"

#import "MVSTableViewCell.h"
#import "ADNPost.h"
#import "ADNUser.h"
#import "ADNAvatar.h"
#import "ADNUsersController.h"
#import "ADNPostController.h"

#import "UIImageView+WebCache.h"

@interface MVSViewController ()
@property (nonatomic, strong) NSArray* posts;
@end

@implementation MVSViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.refreshControl =[[UIRefreshControl alloc] init];
  
  self.tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
  
  [self.refreshControl addTarget:self
                          action:@selector(refreshActionFromSender:)
                forControlEvents:UIControlEventValueChanged];
  
  [[NSNotificationCenter defaultCenter] addObserver: self
                                           selector: @selector(postControllerRefreshedTimeLine:)
                                               name: kADNPOSTCONTROLLER_NOTE_TIMELINE_REFRESHED
                                             object: [ADNPostController shared]];
  
  [[ADNPostController shared] refreshTimeline];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


- (void)refreshActionFromSender:(id)sender
{
  [[ADNPostController shared] refreshTimeline];
}

#pragma mark - POST CONTROLLER

- (void)postControllerRefreshedTimeLine:(NSNotification*)notification
{
  self.posts =[[ADNPostController shared] timeline];  
  [self.tableView reloadData];
  [self.refreshControl endRefreshing];  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  MVSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MVSTableViewCell reusableCellIdentifier]];
  if (!cell) {
    cell = [[MVSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:[MVSTableViewCell reusableCellIdentifier]];
  }
  
  ADNPost* post =self.posts[indexPath.row];
  
  ADNUser* user =[[ADNUsersController shared] userForID:post.userID];
  cell.userNameLabel.text =user.userName;
  
  cell.postTextLabel.text =post.text;
  [cell.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatar.url]
                       placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ADNPost* post =self.posts[indexPath.row];
  CGFloat height =[[MVSTableViewCell class] cellHeightFromPostText:post.text];
  if (height < [MVSTableViewCell minHeight]) {
    return [MVSTableViewCell minHeight];
  }
  return height;
}

@end
