//
//  HashViewController.m
//  HeyVote
//
//  Created by Ikhram Khan on 5/5/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "HashViewController.h"
#import "ContactsTabViewController.h"
#import "searchTabViewController.h"
#import "CameraViewController.h"
#import "globalViewCell.h"
#import "CommentVC.h"
#import "heyVoteProfileVC.h"
#import "profileViewController.h"

@interface HashViewController (){
    
    float testVa;
    UILabel *Timer;
    int valText ;
    CGSize labelSize;
    NSString * recentVal;
    
    NSString * exactTime;
    
    NSString* commentViewVal;
    
    CGRect tabRect;
    CGRect newTabRect;
    
    
    CGRect HeaderRect;
    CGRect SecondHeaderRect;
    
    int newVal;
    NSInteger categoryID;
    NSInteger statusID;
    
    NSMutableArray *arr;
    
    
    NSString* followUnfolloww;
    
    NSString* blockUnblockk;
    
    NSString * voteResultVal;
    NSString * timerLoad;
    NSString * previewVal;
    NSMutableArray * voteResultAraay;
    NSMutableArray* nameArr;
}

@end

@implementation HashViewController
@synthesize globalArray;
@synthesize heyVoteUpdates;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    nameArr = [NSMutableArray arrayWithObjects: @"Jill Valentine", @"Peter Griffin", @"Meg Griffin", @"Jack Lolwut",
    //                        @"Mike Roflcoptor",
    //                        nil];
    
    
    categoryID = 0;
    statusID = 1;
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainMenu:)
                                                 name:@"loginComplete" object:nil];
    
    
    
    
    [heyVoteUpdates setHidden:YES];
    
    
    heyVoteUpdates.layer.shadowColor = [UIColor grayColor].CGColor;
    heyVoteUpdates.layer.shadowOffset = CGSizeMake(0, 1.0);
    heyVoteUpdates.layer.shadowOpacity = 1.0;
    heyVoteUpdates.layer.shadowRadius = 0.0;
    
    //   _timerCalc = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(runScheduledTask:) userInfo:nil repeats:YES];
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(callNewUpdates:) userInfo:nil repeats:YES];
    
    
    
    
    timerLoad = @"";
    self.myScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    recentVal = @"";
    voteResultAraay = [[NSMutableArray alloc]init];
    [_noPostView setHidden:YES];
    [_zoomView setHidden:YES];
    voteResultVal = @"";
    previewVal = @"";
    [_previewView setHidden:YES];
    
    [self callMainWebService];
    // [self callProfileView];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"basicInformation"] == nil) {
        [self callProfileView];
    }
    
    else{
        
        
        [_qatarButton setTitle:[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"basicInformation"] allObjects] valueForKey:@"Country"] objectAtIndex:0] forState:UIControlStateNormal];
        
        
        
    }
    
    
    globalArray = [[NSMutableArray alloc]init];
    
    
    if (globalArray.count == 0) {
        [_noPostView setHidden:NO];
        
        newVal = 0;
        [self callWebService:newVal];
        
        
    }
    
    
    
    
    tabRect = CGRectMake(_myTableView.frame.origin.x, _myTableView.frame.origin.y, _myTableView.frame.size.width, _myTableView.frame.size.height);
    
    newTabRect = CGRectMake(_myTableView.frame.origin.x, _myTableView.frame.origin.y - _secondHeader.frame.size.height, _myTableView.frame.size.width, _myTableView.frame.size.height + _secondHeader.frame.size.height);
    
    
    HeaderRect = CGRectMake(_headerView.frame.origin.x, _headerView.frame.origin.y, _headerView.frame.size.width, _headerView.frame.size.height);
    
    SecondHeaderRect = CGRectMake(_secondHeader.frame.origin.x, _secondHeader.frame.origin.y, _secondHeader.frame.size.width, _secondHeader.frame.size.height);
    
    
    
    
    
    [self.homeSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
    [self.homeSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateHighlighted];
    
    [self.homeSliderTwo setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
    [self.homeSliderTwo setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateHighlighted];
    
    _homeSlider.value = 0;
    _homeSliderTwo.value = 0;
    
    
    
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""]; //to give the attributedTitle
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged ];
    [_refreshControl setTintColor:[UIColor redColor]];
    [_myTableView addSubview:_refreshControl];
    
    
    
}

-(void)callMainWebService{
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        //        UIView *newView = [[UIView alloc]init];
        //        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        //        [self.view addSubview:newView];
        //
        //        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        //
        //
        
        
        NSDictionary *jsonDictionary =@{
                                        
                                        @"isWeb":@"false"
                                        
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/Getuserheaderresult"]];
        
        
        
        [requestPost setHTTPMethod:@"POST"];
        
        
        
        [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        
        
        
        NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        [requestPost setHTTPBody: requestData];
        
        
        [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
        
        
        
        [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                //do something with error
            } else {
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (dic==nil) {
                        
                        
                        //                        [GMDCircleLoader hideFromView:newView animated:YES];
                        //                        [newView removeFromSuperview];
                        
                        
                    }
                    else{
                        
                        
                        NSLog(@"hjfshjfhs%@",dic);
                        
                        NSString* v1 = [NSString stringWithFormat:@"%@",[[[dic valueForKey:@"GetUserHeaderResultResult"] allObjects] objectAtIndex:1]];
                        NSString* v2 = [NSString stringWithFormat:@"%@",[[[dic valueForKey:@"GetUserHeaderResultResult"] allObjects] objectAtIndex:0]];
                        NSArray *items1 = [v1 componentsSeparatedByString:@"."];
                        
                        NSArray *items2 = [v2 componentsSeparatedByString:@"."];
                        NSString *percent = @"%";
                        NSString*testOne= [NSString stringWithFormat:@"%@%@ are with you",[items1 objectAtIndex:0],percent];
                        NSString*testTwo= [NSString stringWithFormat:@"%@%@ are against you",[items2 objectAtIndex:0],percent];
                        
                        
                        
                        
                        _wonText.text = testOne;
                        _lostText.text = testTwo;
                        
                        //                        [GMDCircleLoader hideFromView:newView animated:YES];
                        //                        [newView removeFromSuperview];
                        //
                        //
                        
                        
                    }
                    
                    
                    
                    
                });
            }
        }];
    }
    
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
}




- (void)showMainMenu:(NSNotification *)note {
    [self callWebService:0];}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    commentViewVal = @"";
    
    
}

#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
    
    // [textField becomeFirstResponder];
    timerLoad = @"invalid";
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
    timerLoad = @"invalid";
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    timerLoad = @"invalid";
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    [self.mc pause];
    
    voteResultAraay = [[NSMutableArray alloc]init];
    
    if (  [commentViewVal isEqualToString: @"val"]) {
        
    }
    
    else{
        [_myTableView setContentOffset:CGPointZero animated:YES];
        
        if ([_secondHeader alpha] == 0.0f || [_headerView alpha] == 0.0f) {
            
            
            
            //fade in
            [UIView animateWithDuration:0.5f animations:^{
                _secondHeader.alpha = 1.0f;
                _headerView.alpha = 1.0f;
                _headerView.frame = HeaderRect;
                _myTableView.frame = tabRect;
                
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
    }
    
}



- (void)refresh:(UIRefreshControl *)refreshControl
{
    
    [heyVoteUpdates setHidden:YES];
    [_myTableView setUserInteractionEnabled:NO];
    //  [refreshControl endRefreshing];
    [self callWebServiceRefresh:0];
    
    voteResultVal = @"";
    voteResultAraay = [[NSMutableArray alloc]init];
    
    //    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
}
//- (void)stopRefresh
//{
//
//    [ _refreshControl endRefreshing];
//
//}



-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    [self.myScrollView setScrollEnabled:YES];
    self.myScrollView.contentSize=CGSizeMake(self.myScrollView.bounds.size.width,_myScrollView.frame.size.height);
    
    
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did end decelerating");
    
    if (_myTableView.contentOffset.y == 0){
        
        NSLog(@"reached Top");
        
        [heyVoteUpdates setHidden:YES];
        
        if ([_secondHeader alpha] == 0.0f) {
            
            
            //fade in
            [UIView animateWithDuration:0.2f animations:^{
                _secondHeader.alpha = 1.0f;
                _myTableView.frame = tabRect;
                _headerView.frame = HeaderRect;
                
                
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    NSLog(@"Did end dragging");
    
    
    if (globalArray.count >0) {
        
        if (![_zoomView isHidden]) {
            
        }
        //        else{
        //
        //   arr = [[NSMutableArray alloc]init];
        //    for (NSIndexPath *indexVisible in _myTableView.indexPathsForVisibleRows) {
        //        CGRect cellRect = [_myTableView rectForRowAtIndexPath:indexVisible];
        //        BOOL isVisible = CGRectContainsRect(_myTableView.bounds, cellRect);
        //        if (isVisible) {
        //            //you can also add rows if you dont want full indexPath.
        //            //[arr addObject:[NSString stringWithFormat:@"%ld",(long)indexVisible.row]];
        //            [arr addObject:indexVisible];
        //        }
        //    }
        //    NSLog(@"%@",arr);
        //    if ([arr count]==0) {
        //
        //    }
        //
        //    else{
        //
        //        if ([previewVal isEqualToString:@""]) {
        //              previewVal = @"yes";
        //            [self performSelector:@selector(doSomething) withObject:nil afterDelay:5.0f];
        //        }
        //
        //    }
        //
        //    }
        
    }
    
}

-(void)doSomething{
    
    if ([previewVal isEqualToString:@"yes"]) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(doSomething)
                                                   object:nil];
        
        
        if ([[[globalArray valueForKey:@"PostType"] objectAtIndex:[[arr firstObject]section]] integerValue]==1) {
            
            
            if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:[[arr firstObject]section]] integerValue] == 1) {
                
                
                
                
                
                if ([[[globalArray valueForKey:@"hasVoted"] objectAtIndex:[[arr firstObject]section]] integerValue] == 1) {
                    
                    
                    NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[globalArray valueForKey:@"Image1Idf"] objectAtIndex:[[arr firstObject]section]],[[globalArray valueForKey:@"PostFolderPath"] objectAtIndex:[[arr firstObject]section]]];
                    
                    
                    [_previewImageView  sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    
                    [_previewButtonView setHidden:YES];
                    
                    [_previewYouHaveVoted setHidden:NO];
                    
                    
                    if ([[[globalArray valueForKey:@"VoteOption"] objectAtIndex:[[arr firstObject]section]] integerValue] == 0) {
                        
                        
                        NSString*uVoted = [NSString stringWithFormat:@"You have voted for \"%@\"",[[globalArray valueForKey:@"Caption1"] objectAtIndex:[[arr firstObject]section]]];
                        
                        _previewYouVotedText.text =uVoted;
                    }
                    
                    else{
                        
                        
                        NSString*uVoted = [NSString stringWithFormat:@"You have voted for \"%@\"",[[globalArray valueForKey:@"Caption2"] objectAtIndex:[[arr firstObject]section]]];
                        _previewYouVotedText.text =uVoted;
                        
                    }
                    
                    
                    [_myTableView setUserInteractionEnabled:NO];
                    
                    
                    [_previewView setHidden:NO];
                    _previewView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                    [UIView animateWithDuration:0.5
                                     animations:^{
                                         _previewView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                     } completion:^(BOOL finished) {
                                         
                                     }];
                    
                }
                
                else{
                    
                }
                
            }
            
            else
                
            {
                
                
                
                
                NSLog(@"dfsdfsdfdsf%@",[globalArray objectAtIndex:[[arr firstObject]section]]);
                
                NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[globalArray valueForKey:@"Image1Idf"] objectAtIndex:[[arr firstObject]section]],[[globalArray valueForKey:@"PostFolderPath"] objectAtIndex:[[arr firstObject]section]]];
                
                
                [_previewImageView  sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                
                
                if ([[[globalArray valueForKey:@"hasVoted"] objectAtIndex:[[arr firstObject]section]] integerValue] == 0) {
                    
                    
                    [_previewYouHaveVoted setHidden:YES];
                    
                    if ([voteResultAraay containsObject:[globalArray objectAtIndex:[[arr firstObject]section]]]) {
                        
                        if ([voteResultVal isEqualToString:@"leftvoted"] || [voteResultVal isEqualToString:@"rightvoted"]) {
                            [_previewButtonView setHidden:YES];
                            
                            [_previewYouHaveVoted setHidden:NO];
                            
                            
                            if ([voteResultVal isEqualToString:@"leftvoted"]) {
                                
                                
                                
                                NSString*uVoted = [NSString stringWithFormat:@"You have voted for \"%@\"",[[globalArray valueForKey:@"Caption1"] objectAtIndex:[[arr firstObject]section]]];
                                _previewYouVotedText.text =uVoted;
                            }
                            
                            else{
                                
                                NSString*uVoted = [NSString stringWithFormat:@"You have voted for \"%@\"",[[globalArray valueForKey:@"Caption2"] objectAtIndex:[[arr firstObject]section]]];
                                
                                _previewYouVotedText.text =uVoted;
                            }
                            
                        }
                        
                    }
                    
                    else{
                        
                        [_previewButtonView setHidden:NO];
                        
                        
                        
                        [_previewLeftButton setTitle:[[globalArray valueForKey:@"Caption1"] objectAtIndex:[[arr firstObject]section]] forState:UIControlStateNormal];
                        
                        
                        [_previewRightButton setTitle:[[globalArray valueForKey:@"Caption2"] objectAtIndex:[[arr firstObject]section]] forState:UIControlStateNormal];
                        
                    }
                }
                
                else{
                    [_previewButtonView setHidden:YES];
                    [_previewYouHaveVoted setHidden:NO];
                    
                    if ([[[globalArray valueForKey:@"VoteOption"] objectAtIndex:[[arr firstObject]section]] integerValue] == 0) {
                        
                        
                        NSString*uVoted = [NSString stringWithFormat:@"You have voted for \"%@\"",[[globalArray valueForKey:@"Caption1"] objectAtIndex:[[arr firstObject]section]]];
                        
                        _previewYouVotedText.text =uVoted;
                    }
                    
                    else{
                        
                        
                        NSString*uVoted = [NSString stringWithFormat:@"You have voted for \"%@\"",[[globalArray valueForKey:@"Caption2"] objectAtIndex:[[arr firstObject]section]]];
                        _previewYouVotedText.text =uVoted;
                        
                    }
                    
                    
                    
                    
                }
                [_myTableView setUserInteractionEnabled:NO];
                
                
                [_previewView setHidden:NO];
                _previewView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     _previewView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                 } completion:^(BOOL finished) {
                                     
                                 }];
                
            }
        }
        
        
    }
    
    
    
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did begin decelerating");
    
    
    if (_lastContentOffset.x < (int)scrollView.contentOffset.x) {
        // moved right
        NSLog(@"right");
    }
    else if (_lastContentOffset.x > (int)scrollView.contentOffset.x) {
        // moved left
        NSLog(@"left");
        
    }else if (_lastContentOffset.y<(int)scrollView.contentOffset.y){
        NSLog(@"up");
        
        if ([_secondHeader alpha] == 1.0f || [_headerView alpha] == 1.0f) {
            
            [UIView animateWithDuration:0.1f animations:^{
                
                _secondHeader.alpha = 0.0f;
                _headerView.alpha = 0.0f;
                
                
                _myTableView.frame = CGRectMake(_myScrollView.frame.origin.x, _myScrollView.frame.origin.y - 20 , _myScrollView.frame.size.width, _myScrollView.frame.size.height );
                
                
                //   _headerView.frame = CGRectMake(_myScrollView.frame.origin.x, _myScrollView.frame.origin.y - 20, _headerView.frame.size.width, _headerView.frame.size.height );
                
                
            } completion:^(BOOL finished) {
                
                
                
                
                
            }];
            
        }
        
        
        
    }else if (_lastContentOffset.y>(int)scrollView.contentOffset.y){
        NSLog(@"down");
        
        
        
        if ([_headerView alpha] == 0.0f) {
            
            
            
            //fade in
            [UIView animateWithDuration:0.1f animations:^{
                _headerView.alpha = 1.0f;
                _myTableView.frame = newTabRect;
                _headerView.frame = SecondHeaderRect;
                
                
                
                
                
                
                
                
            } completion:^(BOOL finished) {
                
                
                
                
            }];
            
        }
        
        
        
    }
    
    
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"Did begin dragging");
    timerLoad = @"";
    
    [self.mc stop];
    
    
    previewVal = @"";
    
    _lastContentOffset.x = scrollView.contentOffset.x;
    _lastContentOffset.y = scrollView.contentOffset.y;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    NSInteger newValF;
    NSInteger tabHeight = 0;
    
    if (globalArray.count >0) {
        
        
        
        if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 0) {
            
            
            tabHeight = 485;
            
        }
        
        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 1) {
            
            
            tabHeight = 511;
            
        }
        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 2) {
            
            
            tabHeight = 532;
            
        }
        
        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 3 || [[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] > 3) {
            
            
            tabHeight = 600;
            
        }
        
    }
    
    
    
    if (screenWidth > 320) {
        
        newValF = screenWidth - 320;
        
        tabHeight = tabHeight + newValF;
        
    }
    
    
    return tabHeight;
}


#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"myCell";
    static NSString *cellIdentifierOne = @"oneCommentCell";
    static NSString *cellIdentifierTwo = @"twoCommentCell";
    static NSString *cellIdentifierThree = @"threeCommentCell";
    
    
    globalViewCell *cell;
    
    
    //    cell.layer.shadowOffset = CGSizeMake(1, 1);
    //    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    //    cell.layer.shadowRadius = 5;
    //    cell.layer.shadowOpacity = .25;
    
    [cell.showMoreComments setHidden:YES];
    if (newVal == 1000) {
        
    }
    
    else{
        
        if (indexPath.section == [globalArray count]-1 ) {
            
            
            int plusVal = newVal+1;
            newVal = plusVal;
            timerLoad = @"invalid";
            [self callWebService:plusVal];
            
            
            
        }
    }
    
    
    if (globalArray.count >0) {
        
        
        nameArr =  [[NSMutableArray alloc] init];
        
        
        if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 0) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:
                    cellIdentifier];
            if (cell == nil) {
                cell = [[globalViewCell alloc]initWithStyle:
                        UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            
            
            
        }
        
        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 1){
            
            cell = [tableView dequeueReusableCellWithIdentifier:
                    cellIdentifierOne];
            if (cell == nil) {
                cell = [[globalViewCell alloc]initWithStyle:
                        UITableViewCellStyleDefault reuseIdentifier:cellIdentifierOne];
            }
            
        }
        
        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 2){
            
            cell = [tableView dequeueReusableCellWithIdentifier:
                    cellIdentifierTwo];
            if (cell == nil) {
                cell = [[globalViewCell alloc]initWithStyle:
                        UITableViewCellStyleDefault reuseIdentifier:cellIdentifierTwo];
            }
            
        }
        
        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 3 || [[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] > 3 ){
            
            cell = [tableView dequeueReusableCellWithIdentifier:
                    cellIdentifierThree];
            if (cell == nil) {
                cell = [[globalViewCell alloc]initWithStyle:
                        UITableViewCellStyleDefault reuseIdentifier:cellIdentifierThree];
            }
            
        }
        
        
        if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] > 3) {
            [cell.showMoreComments setHidden:NO];
        }
        
        else{
            
            [cell.showMoreComments setHidden:YES];
        }
        
        
        
        
        [cell.hashCollectionView setHidden:YES];
        
        
        
        [cell.checkInView setHidden:YES];
        [cell.spamView setHidden:YES];
        [cell.progresssView setHidden:YES];
        [cell.timerCell setHidden:YES];
        [cell.remainingLabel setHidden:YES];
        
        
        
        
        //HashTags
        
        
        if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstHashTags"] count] == 0) {
            
        }
        
        else{
            
            [cell.hashCollectionView setHidden:NO];
            
            
            
            NSLog(@"%@",[[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstHashTags"] valueForKey:@"HashTag"] allObjects]);
            nameArr = [[NSMutableArray alloc]init];
            [nameArr addObjectsFromArray:[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstHashTags"]];
            
            [cell.hashCollectionView reloadData];
            
        }
        
        
        
        
        
        
        // timerLoad = @"";
        cell.leftResultButton.layer.cornerRadius = 3;
        [[cell.leftResultButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        cell.leftResultButton.layer.borderWidth = 0.5;
        
        cell.rightResultButton.layer.cornerRadius = 3;
        [[cell.rightResultButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        cell.rightResultButton.layer.borderWidth = 0.5;
        
        
        cell.leftButton.layer.cornerRadius = 3;
        [[cell.leftButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        cell.leftButton.layer.borderWidth = 0.5;
        
        cell.rightButton.layer.cornerRadius = 3;
        [[cell.rightButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        cell.rightButton.layer.borderWidth = 0.5;
        
        
        [self.mc stop];
        
        [cell.timerCell setHidden:YES];
        [cell.remainingLabel setHidden:YES];
        
        [cell.videoPreview setHidden:YES];
        [cell.moreButtonView setHidden:YES];
        [cell.deleteView setHidden:YES];
        cell.commentTextField.text = @"";
        
        
        
        [cell.leftButton setBackgroundColor:[UIColor whiteColor] ];
        
        
        [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
        
        // [cell.titleLabel setNumberOfLines:0];
        
        cell.titleLabel.text = [[globalArray valueForKey:@"Title"] objectAtIndex:indexPath.section];
        //  NSString *textViewText =cell.titleLabel.text;
        
        //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textViewText];
        //        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        paragraphStyle.lineSpacing = 5;
        //
        //        NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
        //        [attributedString addAttributes:dict range:NSMakeRange(0, [textViewText length])];
        //
        //    cell.titleLabel.text = textViewText;
        
        //[cell.titleLabel sizeToFit];
        
        
        
        // More button function (Follow/Block /Report)
        
        if ([[[globalArray valueForKey:@"CanFollow"] objectAtIndex:indexPath.section] integerValue] == 1) {
            
            NSString * moreFollowString = [NSString stringWithFormat:@"Follow %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
            
            [cell.moreFollow setTitle:moreFollowString forState: UIControlStateNormal];
            
        }
        
        if ([[[globalArray valueForKey:@"CanFollow"] objectAtIndex:indexPath.section] integerValue] == 0) {
            NSString * moreFollowString = [NSString stringWithFormat:@"Unfollow %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
            
            [cell.moreFollow setTitle:moreFollowString forState: UIControlStateNormal];
            
            
        }
        
        if ( [[[globalArray valueForKey:@"CanBlock"] objectAtIndex:indexPath.section] integerValue] == 1) {
            
            NSString * moreFollowString = [NSString stringWithFormat:@"Block %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
            
            [cell.moreBlock setTitle:moreFollowString forState: UIControlStateNormal];
            
        }
        
        else if ( [[[globalArray valueForKey:@"CanBlock"] objectAtIndex:indexPath.section] integerValue] == 0){
            
            
            NSString * moreFollowString = [NSString stringWithFormat:@"Unblock %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
            
            [cell.moreBlock setTitle:moreFollowString forState: UIControlStateNormal];
            
            
        }
        
        [cell.moreReport setTitle:@"Report this post" forState: UIControlStateNormal];
        
        
        //CEll for Image Post
        
        
        if ([[[globalArray valueForKey:@"PostType"] objectAtIndex:indexPath.section] integerValue] == 1) {
            
            
            
            
            
            
            NSString * locationName = [[globalArray valueForKey:@"LocationName"] objectAtIndex:indexPath.section];
            if ([locationName length] > 0) {
                [cell.checkInView setHidden:NO];
                [cell.checkinButton setTitle:locationName forState: UIControlStateNormal];
            }
            
            
            
            
            [cell.proImageView setHidden:NO];
            [cell.buttonOverImage setHidden:NO];
            [cell.voiceView setHidden:YES];
            
            
            
            //Post Image
            
            NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[globalArray valueForKey:@"Image1Idf"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"PostFolderPath"] objectAtIndex:indexPath.section]];
            
            
            
            
            
            //            cell.proImageView.layer.shadowColor = [UIColor blackColor].CGColor;
            //            cell.proImageView.layer.shadowOpacity = 0.3f;
            //            cell.proImageView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
            //            cell.proImageView.layer.shadowRadius = 4.0f;
            //            cell.proImageView.layer.masksToBounds = NO;
            //
            //            UIBezierPath *path = [UIBezierPath bezierPathWithRect:cell.proImageView.bounds];
            //            cell.proImageView.layer.shadowPath = path.CGPath;
            
            [cell.proImageView  sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            //Post Vote percentage
            
            
            
            
            NSString*percent = @"%";
            
            NSString*vote1 = [NSString stringWithFormat:@"%@ Votes (%@%@)",[[globalArray valueForKey:@"VoteCount1"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"Vote1Result"] objectAtIndex:indexPath.section],percent];
            
            
            NSString*vote2 = [NSString stringWithFormat:@"%@ Votes (%@%@)",[[globalArray valueForKey:@"VoteCount2"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"Vote2Result"] objectAtIndex:indexPath.section],percent];
            
            
            if ([[[globalArray valueForKey:@"Vote1Result"] objectAtIndex:indexPath.section] integerValue] > [[[globalArray valueForKey:@"Vote2Result"] objectAtIndex:indexPath.section] integerValue]) {
                cell.voteLabelLeft.textColor = [UIColor colorWithRed:0/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
                
                cell.votesLabelRight.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                //                [cell.leftTickImage setHidden:NO];
                //                [cell.rightTickImage setHidden:YES];
                
            }
            
            else if([[[globalArray valueForKey:@"Vote1Result"] objectAtIndex:indexPath.section] integerValue] == [[[globalArray valueForKey:@"Vote2Result"] objectAtIndex:indexPath.section] integerValue]){
                
                
                
                cell.voteLabelLeft.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                cell.votesLabelRight.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                //
                //                [cell.leftTickImage setHidden:YES];
                //                [cell.rightTickImage setHidden:YES];
            }
            
            else{
                
                
                cell.voteLabelLeft.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                cell.votesLabelRight.textColor = [UIColor colorWithRed:0/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
                
                //
                //                [cell.leftTickImage setHidden:YES];
                //                [cell.rightTickImage setHidden:NO];
            }
            
            cell.voteLabelLeft.text = vote1;
            cell.votesLabelRight.text = vote2;
            
            
            //Total HeyVote Counts
            
            
            NSString* totalVotes = [NSString stringWithFormat:@"%@ HeyVotes",[[globalArray valueForKey:@"VoteCount"] objectAtIndex:indexPath.section]];
            
            cell.totalVotesLabel.text = totalVotes;
            
            
            //Comments Count
            
            if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count]  >1) {
                
                NSString * totalComments = [NSString stringWithFormat:@"%ld comments",(long)[[[globalArray valueForKey:@"CommentCount"] objectAtIndex:indexPath.section] integerValue]];
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalComments];
                [attString addAttribute:NSUnderlineStyleAttributeName
                                  value:[NSNumber numberWithInt:1]
                                  range:(NSRange){0,[attString length]}];
                cell.totalComments.text =totalComments;
            }
            
            else{
                
                NSString * totalComments = [NSString stringWithFormat:@"%ld comments",(long)[[[globalArray valueForKey:@"CommentCount"] objectAtIndex:indexPath.section] integerValue]];
                
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalComments];
                [attString addAttribute:NSUnderlineStyleAttributeName
                                  value:[NSNumber numberWithInt:1]
                                  range:(NSRange){0,[attString length]}];
                cell.totalComments.text =totalComments;
                
            }
            
            
            //Post Title
            
            [cell.titleLabelView setHidden:YES];
            
            
            
            //Comment Attribute Label
            
            if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 1) {
                
                
                
                
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:YES];
                
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                
                
                
                
            }
            
            
            else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 2) {
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:NO];
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                NSString * commetAttrTextTwoo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:1];
                
                
                
                NSString * commentAttrTextt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:1];
                
                NSString * combinedTextt = [NSString stringWithFormat:@"%@ %@",commentAttrTextt,commetAttrTextTwoo];
                
                
                
                CGFloat boldTextFontSizee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range11 = [combinedTextt rangeOfString:commentAttrTextt];
                NSRange range22 = [combinedTextt rangeOfString:commetAttrTextTwoo];
                
                NSMutableAttributedString *attributedTextt = [[NSMutableAttributedString alloc] initWithString:combinedTextt];
                
                
                
                
                
                [attributedTextt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range22];
                
                
                
                [attributedTextt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizee]}
                                         range:range11];
                
                
                cell.commentAttributedLabelTwo.attributedText = attributedTextt;
                
                
                
                
                
                
                
            }
            
            
            else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 3) {
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:NO];
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                NSString * commetAttrTextTwoo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:1];
                
                
                
                NSString * commentAttrTextt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:1];
                
                NSString * combinedTextt = [NSString stringWithFormat:@"%@ %@",commentAttrTextt,commetAttrTextTwoo];
                
                
                
                CGFloat boldTextFontSizee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range11 = [combinedTextt rangeOfString:commentAttrTextt];
                NSRange range22 = [combinedTextt rangeOfString:commetAttrTextTwoo];
                
                NSMutableAttributedString *attributedTextt = [[NSMutableAttributedString alloc] initWithString:combinedTextt];
                
                
                
                
                
                [attributedTextt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range22];
                
                
                
                [attributedTextt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizee]}
                                         range:range11];
                
                
                cell.commentAttributedLabelTwo.attributedText = attributedTextt;
                
                
                
                
                NSString * commetAttrTextTwooo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:2];
                
                
                
                NSString * commentAttrTexttt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:2];
                
                NSString * combinedTexttt = [NSString stringWithFormat:@"%@ %@",commentAttrTexttt,commetAttrTextTwooo];
                
                
                
                CGFloat boldTextFontSizeee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range111 = [combinedTexttt rangeOfString:commentAttrTexttt];
                NSRange range222 = [combinedTexttt rangeOfString:commetAttrTextTwooo];
                
                NSMutableAttributedString *attributedTexttt = [[NSMutableAttributedString alloc] initWithString:combinedTexttt];
                
                
                
                
                
                [attributedTexttt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range222];
                
                
                
                [attributedTexttt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizeee]}
                                          range:range111];
                
                
                cell.commentAttributedLabelThree.attributedText = attributedTexttt;
                
                
                
                
                
                
            }
            
            
            
            else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] > 3) {
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:NO];
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                NSString * commetAttrTextTwoo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:1];
                
                
                
                NSString * commentAttrTextt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:1];
                
                NSString * combinedTextt = [NSString stringWithFormat:@"%@ %@",commentAttrTextt,commetAttrTextTwoo];
                
                
                
                CGFloat boldTextFontSizee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range11 = [combinedTextt rangeOfString:commentAttrTextt];
                NSRange range22 = [combinedTextt rangeOfString:commetAttrTextTwoo];
                
                NSMutableAttributedString *attributedTextt = [[NSMutableAttributedString alloc] initWithString:combinedTextt];
                
                
                
                
                
                [attributedTextt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range22];
                
                
                
                [attributedTextt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizee]}
                                         range:range11];
                
                
                cell.commentAttributedLabelTwo.attributedText = attributedTextt;
                
                
                
                
                NSString * commetAttrTextTwooo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:2];
                
                
                
                NSString * commentAttrTexttt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:2];
                
                NSString * combinedTexttt = [NSString stringWithFormat:@"%@ %@",commentAttrTexttt,commetAttrTextTwooo];
                
                
                
                CGFloat boldTextFontSizeee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range111 = [combinedTexttt rangeOfString:commentAttrTexttt];
                NSRange range222 = [combinedTexttt rangeOfString:commetAttrTextTwooo];
                
                NSMutableAttributedString *attributedTexttt = [[NSMutableAttributedString alloc] initWithString:combinedTexttt];
                
                
                
                
                
                [attributedTexttt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range222];
                
                
                
                [attributedTexttt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizeee]}
                                          range:range111];
                
                
                cell.commentAttributedLabelThree.attributedText = attributedTexttt;
                
                
                
                
                [cell.showMoreComments setHidden:NO];
                
            }
            
            // Post is Live Or Done
            
            if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:indexPath.section] integerValue]  == 0 ) {
                
                
                
                // [cell.timerCell setHidden:NO];
                // [cell.remainingLabel setHidden:NO];
                
                
                NSString *stringTimer =[[globalArray valueForKey:@"EndDate"] objectAtIndex:indexPath.section];
                
                
                NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
                NSArray *splitString = [stringTimer componentsSeparatedByCharactersInSet:delimiters];
                
                NSString *xString = [splitString objectAtIndex:0];
                NSString *yString = [splitString objectAtIndex:1];
                
                
                
                if ([yString containsString:@"-"]) {
                    
                    NSArray *arrrr = [yString componentsSeparatedByString:@"-"];
                    
                    
                    NSString* testOne = [arrrr objectAtIndex:0];
                    
                    
                    NSString* beforeConvert =[arrrr objectAtIndex:1];
                    
                    NSString*mystr=[beforeConvert substringToIndex:2];
                    
                    NSInteger multipliedVal = [mystr integerValue] * 3600000;
                    
                    NSString * finalVal = [NSString stringWithFormat:@"%ld",[testOne integerValue] - multipliedVal];
                    
                    
                    NSDate *tr = [NSDate dateWithTimeIntervalSince1970:[finalVal integerValue]/1000.0];
                    
                    
                    
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    
                    
                    NSString* localTime = [dateFormatter stringFromDate:tr];
                    
                    NSLog(@"localTime:%@", localTime);
                    
                    NSDateFormatter *dateFormatterCurrent=[[NSDateFormatter alloc] init];
                    [dateFormatterCurrent setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
                    
                    
                    
                    NSString* localCurrentTime = [dateFormatterCurrent stringFromDate:[NSDate date]];
                    NSLog(@"current time :%@",localCurrentTime);
                    
                    NSTimeInterval diff = [tr timeIntervalSinceDate:[NSDate date]];
                    
                    NSLog(@"difffereeenceee %f",diff*1000 );
                    
                    valText = diff*1000;
                    
                    
                    float seconds = valText / 1000.0;
                    float minutes = seconds / 60.0;
                    
                    
                    testVa = minutes/1440;
                    
                    
                    
                    //                    float percentVal = testVa * 100;
                    //
                    //                    float percentFinalVal = percentVal/100
                    //
                    
                    if ([[self calculateTimer] isEqualToString:@""]) {
                        [cell.timerCell setHidden:YES];
                        [cell.progresssView setHidden:YES];
                    }
                    
                    else{
                        
                        cell.timerCell.text =  [self calculateTimer];
                        
                        
                        
                    }
                    
                    //
                    //                    if (valText >0 && valText <86400000 ) {
                    ////                        _timerCalc = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runScheduledTask:) userInfo:nil repeats:NO];
                    //
                    //
                    //                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(valText / 1000.0)];
                    //
                    //                        NSString* localTimeee =[NSString stringWithFormat:@"%@",date];
                    //
                    //                        NSArray *seperateVal =  [localTimeee componentsSeparatedByString:@" "];
                    //
                    //                        NSArray *timeSplit = [[seperateVal objectAtIndex:1] componentsSeparatedByString:@":"];
                    //
                    //
                    //                      NSString*  exactTimeee = [NSString stringWithFormat:@"%@h. %@m. %@s.",[timeSplit objectAtIndex:0],[timeSplit objectAtIndex:1],[timeSplit objectAtIndex:2]];
                    //
                    //                        cell.timerCell.text  = exactTimeee;
                    //
                    //                        NSLog(@"timerrrr : %@",cell.timerCell.text);
                    //
                    //
                    //
                    //                    }
                    //
                    //
                    //
                    
                }
                
                
                
                /*******/
                [cell.yesNoMainView setHidden:NO];
                [cell.yesNoButtonView setHidden:YES];
                [cell.yesNoNotDoneButtonView setHidden:NO];
                cell.leftButton.userInteractionEnabled = YES;
                cell.rightButton.userInteractionEnabled = YES;
                
                [cell.leftButton setBackgroundColor:[UIColor whiteColor]];
                [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
                
                [cell.reheyVoteButton setHidden:YES];
                
                
                //Has Voted Or not Button View
                
                
                if ([[[globalArray valueForKey:@"hasVoted"] objectAtIndex:indexPath.section] integerValue]  == 0) {
                    
                    if ([voteResultAraay containsObject:[globalArray objectAtIndex:indexPath.section]]) {
                        
                        
                        
                        if ([voteResultVal isEqualToString:@"leftvoted"] || [voteResultVal isEqualToString:@"rightvoted"]) {
                            
                            
                            [cell.progresssView setHidden:NO];
                            [cell.timerCell setHidden:NO];
                            [cell.remainingLabel setHidden:NO];
                            
                            cell.circularProgress.progressTintColor = [UIColor colorWithRed:202.0f/255.0f
                                                                                      green:0.0f/255.0f
                                                                                       blue:20.0f/255.0f
                                                                                      alpha:0.7f];
                            cell.circularProgress.max = 1.0f;
                            cell.circularProgress.fillRadiusPx = 25;
                            cell.circularProgress.step = 0.1f;
                            cell.circularProgress.startAngle = (M_PI * 3) * 0.5;
                            cell.circularProgress.translatesAutoresizingMaskIntoConstraints = NO;
                            cell.circularProgress.outlineWidth = 1;
                            cell.circularProgress.outlineTintColor = [UIColor whiteColor];
                            cell.circularProgress.endPoint = [[HKCircularProgressEndPointSpike alloc] init];
                            
                            
                            [[HKCircularProgressView appearance] setAnimationDuration:5];
                            
                            cell.circularProgress.alwaysDrawOutline = YES;
                            
                            
                            cell.insideProgress.fillRadius = 1;
                            cell.insideProgress.progressTintColor = [UIColor lightGrayColor];
                            cell.insideProgress.translatesAutoresizingMaskIntoConstraints = NO;
                            [cell.circularProgress setCurrent:testVa
                                                     animated:YES];
                            [cell.insideProgress setCurrent:1.0f
                                                   animated:YES];
                            
                            
                            
                            NSString*uVoted;
                            
                            // [cell.yesNoMainView setHidden:YES];
                            
                            if ([voteResultVal isEqualToString:@"leftvoted"]) {
                                
                                cell.leftButton.userInteractionEnabled = NO;
                                cell.rightButton.userInteractionEnabled = NO;
                                
                                [cell.leftButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                                    green:200.0f/255.0f
                                                                                     blue:200.0f/255.0f
                                                                                    alpha:1.0f]];
                                [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
                                
                                
                                
                            }
                            
                            else if([voteResultVal isEqualToString:@"rightvoted"] == 1) {
                                
                                
                                cell.leftButton.userInteractionEnabled = NO;
                                cell.rightButton.userInteractionEnabled = NO;
                                
                                [cell.leftButton setBackgroundColor:[UIColor whiteColor]];
                                [cell.rightButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                                     green:200.0f/255.0f
                                                                                      blue:200.0f/255.0f
                                                                                     alpha:1.0f]];
                                
                                
                            }
                            
                            cell.youHaveVotedLabel.text =uVoted;
                        }
                        
                        else{
                            
                            
                            
                            [cell.yesNoMainView setHidden:NO];
                            [cell.yesNoButtonView setHidden:YES];
                            [cell.yesNoNotDoneButtonView setHidden:NO];
                        }
                        
                    }
                    
                }
                
                else if ([[[globalArray valueForKey:@"hasVoted"] objectAtIndex:indexPath.section] integerValue]  == 1 ) {
                    // [cell.yesNoMainView setHidden:YES];
                    
                    [cell.progresssView setHidden:NO];
                    [cell.timerCell setHidden:NO];
                    [cell.remainingLabel setHidden:NO];
                    
                    cell.circularProgress.progressTintColor = [UIColor colorWithRed:202.0f/255.0f
                                                                              green:0.0f/255.0f
                                                                               blue:20.0f/255.0f
                                                                              alpha:0.7f];
                    cell.circularProgress.max = 1.0f;
                    cell.circularProgress.fillRadiusPx = 25;
                    cell.circularProgress.step = 0.1f;
                    cell.circularProgress.startAngle = (M_PI * 3) * 0.5;
                    cell.circularProgress.translatesAutoresizingMaskIntoConstraints = NO;
                    cell.circularProgress.outlineWidth = 1;
                    cell.circularProgress.outlineTintColor = [UIColor whiteColor];
                    cell.circularProgress.endPoint = [[HKCircularProgressEndPointSpike alloc] init];
                    
                    
                    [[HKCircularProgressView appearance] setAnimationDuration:5];
                    
                    cell.circularProgress.alwaysDrawOutline = YES;
                    
                    
                    cell.insideProgress.fillRadius = 1;
                    cell.insideProgress.progressTintColor = [UIColor lightGrayColor];
                    cell.insideProgress.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.circularProgress setCurrent:testVa
                                             animated:YES];
                    [cell.insideProgress setCurrent:1.0f
                                           animated:YES];
                    
                    
                    
                    
                    NSString*uVoted;
                    
                    
                    if ([[[globalArray valueForKey:@"VoteOption"] objectAtIndex:indexPath.section] integerValue] == 0) {
                        
                        cell.leftButton.userInteractionEnabled = NO;
                        cell.rightButton.userInteractionEnabled = NO;
                        
                        [cell.leftButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                            green:200.0f/255.0f
                                                                             blue:200.0f/255.0f
                                                                            alpha:1.0f]];
                        [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
                        
                        
                    }
                    
                    else if([[[globalArray valueForKey:@"VoteOption"] objectAtIndex:indexPath.section] integerValue] == 1) {
                        
                        cell.leftButton.userInteractionEnabled = NO;
                        cell.rightButton.userInteractionEnabled = NO;
                        
                        
                        
                        [cell.leftButton setBackgroundColor:[UIColor whiteColor]];
                        [cell.rightButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                             green:200.0f/255.0f
                                                                              blue:200.0f/255.0f
                                                                             alpha:1.0f]];
                        
                        
                    }
                    
                    cell.youHaveVotedLabel.text =uVoted;
                }
                
                
                
                
                
            }
            
            
            
            else if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:indexPath.section] integerValue]  == 1) {
                [cell.timerCell setHidden:YES];
                [cell.remainingLabel setHidden:YES];
                
                [cell.yesNoMainView setHidden:NO];
                [cell.yesNoButtonView setHidden:NO];
                [cell.yesNoNotDoneButtonView setHidden:NO];
                cell.leftButton.userInteractionEnabled = NO;
                cell.rightButton.userInteractionEnabled = NO;
                
                
                [cell.reheyVoteButton setHidden:NO];
                
            }
            
            
            
            //Button Caption (YES/NO)
            [cell.leftButton setTitle:[[globalArray valueForKey:@"Caption1"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            [cell.rightButton setTitle:[[globalArray valueForKey:@"Caption2"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            [cell.leftResultButton setTitle:[[globalArray valueForKey:@"Caption1"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            [cell.rightResultButton setTitle:[[globalArray valueForKey:@"Caption2"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            //   return cell;
            
        }
        
        
        //CEll for Audio Post
        
        
        else  if ([[[globalArray valueForKey:@"PostType"] objectAtIndex:indexPath.section] integerValue] == 3) {
            
            
            NSString * locationName = [[globalArray valueForKey:@"LocationName"] objectAtIndex:indexPath.section];
            if ([locationName length] > 0) {
                [cell.checkInView setHidden:NO];
                [cell.checkinButton setTitle:locationName forState: UIControlStateNormal];
            }
            
            
            
            [cell.progresssView setHidden:YES];
            [cell.timerCell setHidden:YES];
            [cell.remainingLabel setHidden:YES];
            
            //Post Image
            
            
            
            [cell.proImageView setHidden:YES];
            [cell.buttonOverImage setHidden:YES];
            [cell.voiceView setHidden:NO];
            
            if ([[globalArray valueForKey:@"Image2Idf"] objectAtIndex:indexPath.section] == [NSNull null]) {
                [cell.doubleVoiceView setHidden:YES];
            }
            
            else{
                
                [cell.doubleVoiceView setHidden:NO];
            }
            
            
            //Post Vote percentage
            
            NSString*percent = @"%";
            
            NSString*vote1 = [NSString stringWithFormat:@"%@ Votes (%@%@)",[[globalArray valueForKey:@"VoteCount1"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"Vote1Result"] objectAtIndex:indexPath.section],percent];
            
            
            NSString*vote2 = [NSString stringWithFormat:@"%@ Votes (%@%@)",[[globalArray valueForKey:@"VoteCount2"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"Vote2Result"] objectAtIndex:indexPath.section],percent];
            
            
            if ([[[globalArray valueForKey:@"Vote1Result"] objectAtIndex:indexPath.section] integerValue] > [[[globalArray valueForKey:@"Vote2Result"] objectAtIndex:indexPath.section] integerValue]) {
                cell.voteLabelLeft.textColor = [UIColor colorWithRed:0/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
                
                cell.votesLabelRight.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                //                [cell.leftTickImage setHidden:NO];
                //                [cell.rightTickImage setHidden:YES];
                
            }
            
            else if([[[globalArray valueForKey:@"Vote1Result"] objectAtIndex:indexPath.section] integerValue] == [[[globalArray valueForKey:@"Vote2Result"] objectAtIndex:indexPath.section] integerValue]){
                
                
                
                cell.voteLabelLeft.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                cell.votesLabelRight.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                //                [cell.leftTickImage setHidden:YES];
                //                [cell.rightTickImage setHidden:YES];
            }
            
            else{
                
                
                cell.voteLabelLeft.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                cell.votesLabelRight.textColor = [UIColor colorWithRed:0/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
                
                
                //                [cell.leftTickImage setHidden:YES];
                //                [cell.rightTickImage setHidden:NO];
            }
            
            cell.voteLabelLeft.text = vote1;
            cell.votesLabelRight.text = vote2;
            
            
            //Total HeyVote Counts
            
            NSString* totalVotes = [NSString stringWithFormat:@"%@ HeyVotes",[[globalArray valueForKey:@"VoteCount"] objectAtIndex:indexPath.section]];
            
            cell.totalVotesLabel.text = totalVotes;
            
            
            
            //Comments Count
            
            if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count]  >1) {
                
                
                NSString * totalComments = [NSString stringWithFormat:@"%ld comments",(long)[[[globalArray valueForKey:@"CommentCount"] objectAtIndex:indexPath.section] integerValue]];
                
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalComments];
                
                [attString addAttribute:NSUnderlineStyleAttributeName
                                  value:[NSNumber numberWithInt:1]
                                  range:(NSRange){0,[attString length]}];
                cell.totalComments.text =totalComments;
            }
            
            else{
                
                NSString * totalComments = [NSString stringWithFormat:@"%ld comments",(long)[[[globalArray valueForKey:@"CommentCount"] objectAtIndex:indexPath.section] integerValue]];
                
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalComments];
                
                [attString addAttribute:NSUnderlineStyleAttributeName
                                  value:[NSNumber numberWithInt:1]
                                  range:(NSRange){0,[attString length]}];
                cell.totalComments.text =totalComments;
            }
            
            
            
            //Post Title
            
            [cell.titleLabelView setHidden:NO];
            
            cell.titleLabel.text = [[globalArray valueForKey:@"Title"] objectAtIndex:indexPath.section];
            
            //Comment Attribute Label
            
            if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 1) {
                
                
                
                
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:YES];
                
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                
                
                
                
            }
            
            
            else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 2) {
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:NO];
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                NSString * commetAttrTextTwoo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:1];
                
                
                
                NSString * commentAttrTextt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:1];
                
                NSString * combinedTextt = [NSString stringWithFormat:@"%@ %@",commentAttrTextt,commetAttrTextTwoo];
                
                
                
                CGFloat boldTextFontSizee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range11 = [combinedTextt rangeOfString:commentAttrTextt];
                NSRange range22 = [combinedTextt rangeOfString:commetAttrTextTwoo];
                
                NSMutableAttributedString *attributedTextt = [[NSMutableAttributedString alloc] initWithString:combinedTextt];
                
                
                
                
                
                [attributedTextt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range22];
                
                
                
                [attributedTextt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizee]}
                                         range:range11];
                
                
                cell.commentAttributedLabelTwo.attributedText = attributedTextt;
                
                
                
                
                
                
                
            }
            
            
            else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 3) {
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:NO];
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                NSString * commetAttrTextTwoo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:1];
                
                
                
                NSString * commentAttrTextt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:1];
                
                NSString * combinedTextt = [NSString stringWithFormat:@"%@ %@",commentAttrTextt,commetAttrTextTwoo];
                
                
                
                CGFloat boldTextFontSizee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range11 = [combinedTextt rangeOfString:commentAttrTextt];
                NSRange range22 = [combinedTextt rangeOfString:commetAttrTextTwoo];
                
                NSMutableAttributedString *attributedTextt = [[NSMutableAttributedString alloc] initWithString:combinedTextt];
                
                
                
                
                
                [attributedTextt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range22];
                
                
                
                [attributedTextt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizee]}
                                         range:range11];
                
                
                cell.commentAttributedLabelTwo.attributedText = attributedTextt;
                
                
                
                
                NSString * commetAttrTextTwooo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:2];
                
                
                
                NSString * commentAttrTexttt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:2];
                
                NSString * combinedTexttt = [NSString stringWithFormat:@"%@ %@",commentAttrTexttt,commetAttrTextTwooo];
                
                
                
                CGFloat boldTextFontSizeee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range111 = [combinedTexttt rangeOfString:commentAttrTexttt];
                NSRange range222 = [combinedTexttt rangeOfString:commetAttrTextTwooo];
                
                NSMutableAttributedString *attributedTexttt = [[NSMutableAttributedString alloc] initWithString:combinedTexttt];
                
                
                
                
                
                [attributedTexttt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range222];
                
                
                
                [attributedTexttt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizeee]}
                                          range:range111];
                
                
                cell.commentAttributedLabelThree.attributedText = attributedTexttt;
                
                
                
                
                
                
            }
            
            
            
            else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] > 3) {
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:NO];
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                NSString * commetAttrTextTwoo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:1];
                
                
                
                NSString * commentAttrTextt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:1];
                
                NSString * combinedTextt = [NSString stringWithFormat:@"%@ %@",commentAttrTextt,commetAttrTextTwoo];
                
                
                
                CGFloat boldTextFontSizee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range11 = [combinedTextt rangeOfString:commentAttrTextt];
                NSRange range22 = [combinedTextt rangeOfString:commetAttrTextTwoo];
                
                NSMutableAttributedString *attributedTextt = [[NSMutableAttributedString alloc] initWithString:combinedTextt];
                
                
                
                
                
                [attributedTextt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range22];
                
                
                
                [attributedTextt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizee]}
                                         range:range11];
                
                
                cell.commentAttributedLabelTwo.attributedText = attributedTextt;
                
                
                
                
                NSString * commetAttrTextTwooo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:2];
                
                
                
                NSString * commentAttrTexttt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:2];
                
                NSString * combinedTexttt = [NSString stringWithFormat:@"%@ %@",commentAttrTexttt,commetAttrTextTwooo];
                
                
                
                CGFloat boldTextFontSizeee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range111 = [combinedTexttt rangeOfString:commentAttrTexttt];
                NSRange range222 = [combinedTexttt rangeOfString:commetAttrTextTwooo];
                
                NSMutableAttributedString *attributedTexttt = [[NSMutableAttributedString alloc] initWithString:combinedTexttt];
                
                
                
                
                
                [attributedTexttt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range222];
                
                
                
                [attributedTexttt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizeee]}
                                          range:range111];
                
                
                cell.commentAttributedLabelThree.attributedText = attributedTexttt;
                
                
                
                
                [cell.showMoreComments setHidden:NO];
                
            }
            
            // Post is Live Or Done
            
            if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:indexPath.section] integerValue]  == 0 ) {
                
                
                
                //  [cell.timerCell setHidden:NO];
                // [cell.remainingLabel setHidden:NO];
                
                
                NSString *stringTimer =[[globalArray valueForKey:@"EndDate"] objectAtIndex:indexPath.section];
                
                
                NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
                NSArray *splitString = [stringTimer componentsSeparatedByCharactersInSet:delimiters];
                
                NSString *xString = [splitString objectAtIndex:0];
                NSString *yString = [splitString objectAtIndex:1];
                
                
                
                if ([yString containsString:@"-"]) {
                    
                    NSArray *arrrr = [yString componentsSeparatedByString:@"-"];
                    
                    
                    NSString* testOne = [arrrr objectAtIndex:0];
                    
                    
                    NSString* beforeConvert =[arrrr objectAtIndex:1];
                    
                    NSString*mystr=[beforeConvert substringToIndex:2];
                    
                    NSInteger multipliedVal = [mystr integerValue] * 3600000;
                    
                    NSString * finalVal = [NSString stringWithFormat:@"%ld",[testOne integerValue] - multipliedVal];
                    
                    
                    NSDate *tr = [NSDate dateWithTimeIntervalSince1970:[finalVal integerValue]/1000.0];
                    
                    
                    
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    
                    
                    NSString* localTime = [dateFormatter stringFromDate:tr];
                    
                    NSLog(@"localTime:%@", localTime);
                    
                    NSDateFormatter *dateFormatterCurrent=[[NSDateFormatter alloc] init];
                    [dateFormatterCurrent setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
                    
                    
                    
                    NSString* localCurrentTime = [dateFormatterCurrent stringFromDate:[NSDate date]];
                    NSLog(@"current time :%@",localCurrentTime);
                    
                    NSTimeInterval diff = [tr timeIntervalSinceDate:[NSDate date]];
                    
                    NSLog(@"difffereeenceee %f",diff*1000 );
                    
                    valText = diff*1000;
                    
                    
                    float seconds = valText / 1000.0;
                    float minutes = seconds / 60.0;
                    
                    
                    testVa = minutes/1440;
                    
                    
                    
                    //                    float percentVal = testVa * 100;
                    //
                    //                    float percentFinalVal = percentVal/100
                    //
                    
                    if ([[self calculateTimer] isEqualToString:@""]) {
                        [cell.timerCell setHidden:YES];
                        [cell.progresssView setHidden:YES];
                    }
                    
                    else{
                        //  [cell.timerCell setHidden:NO];
                        // [cell.remainingLabel setHidden:NO];
                        cell.timerCell.text =  [self calculateTimer];
                        
                        
                        
                    }
                    
                    //
                    //                    if (valText >0 && valText <86400000 ) {
                    ////                        _timerCalc = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runScheduledTask:) userInfo:nil repeats:NO];
                    //
                    //
                    //                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(valText / 1000.0)];
                    //
                    //                        NSString* localTimeee =[NSString stringWithFormat:@"%@",date];
                    //
                    //                        NSArray *seperateVal =  [localTimeee componentsSeparatedByString:@" "];
                    //
                    //                        NSArray *timeSplit = [[seperateVal objectAtIndex:1] componentsSeparatedByString:@":"];
                    //
                    //
                    //                      NSString*  exactTimeee = [NSString stringWithFormat:@"%@h. %@m. %@s.",[timeSplit objectAtIndex:0],[timeSplit objectAtIndex:1],[timeSplit objectAtIndex:2]];
                    //
                    //                        cell.timerCell.text  = exactTimeee;
                    //
                    //                        NSLog(@"timerrrr : %@",cell.timerCell.text);
                    //
                    //
                    //
                    //                    }
                    //
                    //
                    //
                    
                }
                
                
                
                /*******/
                [cell.yesNoMainView setHidden:NO];
                [cell.yesNoButtonView setHidden:YES];
                [cell.yesNoNotDoneButtonView setHidden:NO];
                cell.leftButton.userInteractionEnabled = YES;
                cell.rightButton.userInteractionEnabled = YES;
                
                [cell.leftButton setBackgroundColor:[UIColor whiteColor]];
                [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
                
                [cell.reheyVoteButton setHidden:YES];
                
                
                //Has Voted Or not Button View
                
                
                if ([[[globalArray valueForKey:@"hasVoted"] objectAtIndex:indexPath.section] integerValue]  == 0) {
                    
                    if ([voteResultAraay containsObject:[globalArray objectAtIndex:indexPath.section]]) {
                        
                        
                        
                        if ([voteResultVal isEqualToString:@"leftvoted"] || [voteResultVal isEqualToString:@"rightvoted"]) {
                            
                            
                            
                            
                            [cell.progresssView setHidden:YES];
                            
                            cell.circularProgress.progressTintColor = [UIColor colorWithRed:202.0f/255.0f
                                                                                      green:0.0f/255.0f
                                                                                       blue:20.0f/255.0f
                                                                                      alpha:0.7f];
                            cell.circularProgress.max = 1.0f;
                            cell.circularProgress.fillRadiusPx = 25;
                            cell.circularProgress.step = 0.1f;
                            cell.circularProgress.startAngle = (M_PI * 3) * 0.5;
                            cell.circularProgress.translatesAutoresizingMaskIntoConstraints = NO;
                            cell.circularProgress.outlineWidth = 1;
                            cell.circularProgress.outlineTintColor = [UIColor whiteColor];
                            cell.circularProgress.endPoint = [[HKCircularProgressEndPointSpike alloc] init];
                            
                            
                            [[HKCircularProgressView appearance] setAnimationDuration:5];
                            
                            cell.circularProgress.alwaysDrawOutline = YES;
                            
                            
                            cell.insideProgress.fillRadius = 1;
                            cell.insideProgress.progressTintColor = [UIColor lightGrayColor];
                            cell.insideProgress.translatesAutoresizingMaskIntoConstraints = NO;
                            [cell.circularProgress setCurrent:testVa
                                                     animated:YES];
                            [cell.insideProgress setCurrent:1.0f
                                                   animated:YES];
                            
                            
                            
                            NSString*uVoted;
                            
                            // [cell.yesNoMainView setHidden:YES];
                            
                            if ([voteResultVal isEqualToString:@"leftvoted"]) {
                                
                                cell.leftButton.userInteractionEnabled = NO;
                                cell.rightButton.userInteractionEnabled = NO;
                                
                                [cell.leftButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                                    green:200.0f/255.0f
                                                                                     blue:200.0f/255.0f
                                                                                    alpha:1.0f]];
                                [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
                                
                                
                                
                            }
                            
                            else if([voteResultVal isEqualToString:@"rightvoted"] == 1) {
                                
                                
                                cell.leftButton.userInteractionEnabled = NO;
                                cell.rightButton.userInteractionEnabled = NO;
                                
                                [cell.leftButton setBackgroundColor:[UIColor whiteColor]];
                                [cell.rightButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                                     green:200.0f/255.0f
                                                                                      blue:200.0f/255.0f
                                                                                     alpha:1.0f]];
                                
                                
                            }
                            
                            cell.youHaveVotedLabel.text =uVoted;
                        }
                        
                        else{
                            
                            
                            
                            [cell.yesNoMainView setHidden:NO];
                            [cell.yesNoButtonView setHidden:YES];
                            [cell.yesNoNotDoneButtonView setHidden:NO];
                        }
                        
                    }
                    
                }
                
                else if ([[[globalArray valueForKey:@"hasVoted"] objectAtIndex:indexPath.section] integerValue]  == 1 ) {
                    // [cell.yesNoMainView setHidden:YES];
                    
                    [cell.progresssView setHidden:YES];
                    
                    cell.circularProgress.progressTintColor = [UIColor colorWithRed:202.0f/255.0f
                                                                              green:0.0f/255.0f
                                                                               blue:20.0f/255.0f
                                                                              alpha:0.7f];
                    cell.circularProgress.max = 1.0f;
                    cell.circularProgress.fillRadiusPx = 25;
                    cell.circularProgress.step = 0.1f;
                    cell.circularProgress.startAngle = (M_PI * 3) * 0.5;
                    cell.circularProgress.translatesAutoresizingMaskIntoConstraints = NO;
                    cell.circularProgress.outlineWidth = 1;
                    cell.circularProgress.outlineTintColor = [UIColor whiteColor];
                    cell.circularProgress.endPoint = [[HKCircularProgressEndPointSpike alloc] init];
                    
                    
                    [[HKCircularProgressView appearance] setAnimationDuration:5];
                    
                    cell.circularProgress.alwaysDrawOutline = YES;
                    
                    
                    cell.insideProgress.fillRadius = 1;
                    cell.insideProgress.progressTintColor = [UIColor lightGrayColor];
                    cell.insideProgress.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.circularProgress setCurrent:testVa
                                             animated:YES];
                    [cell.insideProgress setCurrent:1.0f
                                           animated:YES];
                    
                    
                    
                    
                    NSString*uVoted;
                    
                    
                    if ([[[globalArray valueForKey:@"VoteOption"] objectAtIndex:indexPath.section] integerValue] == 0) {
                        
                        cell.leftButton.userInteractionEnabled = NO;
                        cell.rightButton.userInteractionEnabled = NO;
                        
                        [cell.leftButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                            green:200.0f/255.0f
                                                                             blue:200.0f/255.0f
                                                                            alpha:1.0f]];
                        [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
                        
                        
                    }
                    
                    else if([[[globalArray valueForKey:@"VoteOption"] objectAtIndex:indexPath.section] integerValue] == 1) {
                        
                        cell.leftButton.userInteractionEnabled = NO;
                        cell.rightButton.userInteractionEnabled = NO;
                        
                        
                        
                        [cell.leftButton setBackgroundColor:[UIColor whiteColor]];
                        [cell.rightButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                             green:200.0f/255.0f
                                                                              blue:200.0f/255.0f
                                                                             alpha:1.0f]];
                        
                        
                    }
                    
                    cell.youHaveVotedLabel.text =uVoted;
                }
                
                
                
                
                
            }
            
            
            
            else if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:indexPath.section] integerValue]  == 1) {
                [cell.timerCell setHidden:YES];
                [cell.remainingLabel setHidden:YES];
                
                [cell.yesNoMainView setHidden:NO];
                [cell.yesNoButtonView setHidden:NO];
                [cell.yesNoNotDoneButtonView setHidden:NO];
                cell.leftButton.userInteractionEnabled = NO;
                cell.rightButton.userInteractionEnabled = NO;
                
                
                [cell.reheyVoteButton setHidden:NO];
                
            }
            
            
            
            //Button Caption (YES/NO)
            [cell.leftButton setTitle:[[globalArray valueForKey:@"Caption1"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            [cell.rightButton setTitle:[[globalArray valueForKey:@"Caption2"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            [cell.leftResultButton setTitle:[[globalArray valueForKey:@"Caption1"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            [cell.rightResultButton setTitle:[[globalArray valueForKey:@"Caption2"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            
            
            
            
            //  return cell;
            
            
        }
        
        
        
        //CEll for video Post
        
        
        else  if ([[[globalArray valueForKey:@"PostType"] objectAtIndex:indexPath.section] integerValue] == 2) {
            
            
            NSString * locationName = [[globalArray valueForKey:@"LocationName"] objectAtIndex:indexPath.section];
            if ([locationName length] > 0) {
                [cell.checkInView setHidden:NO];
                [cell.checkinButton setTitle:locationName forState: UIControlStateNormal];
            }
            
            
            [cell.videoPreview setHidden:NO];
            
            [cell.progresssView setHidden:YES];
            [cell.timerCell setHidden:YES];
            [cell.remainingLabel setHidden:YES];
            
            //Post Image
            
            
            
            NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/api/media/play/%@/%@",[[globalArray valueForKey:@"Image1Idf"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"PostFolderPath"] objectAtIndex:indexPath.section]];
            
            MPMoviePlayerController *controller = [[MPMoviePlayerController alloc]
                                                   initWithContentURL:[NSURL URLWithString:imageString]];
            
            self.mc = controller; //Super important
            [controller prepareToPlay];
            controller.repeatMode = YES;
            [controller setControlStyle:MPMovieControlStyleNone];
            controller.view.userInteractionEnabled =YES;
            controller.scalingMode = MPMovieScalingModeAspectFill;
            [cell.videoPreview addSubview:controller.view]; //Show the view
            controller.view.frame = cell.videoPreview.bounds; //Set the size
            
            [controller play]; //Start playing
            
            
            
            
            
            cell.proImageView.image = [UIImage imageNamed:@"video-placeholder.png"];
            [cell.proImageView setHidden:NO];
            [cell.buttonOverImage setHidden:NO];
            [cell.voiceView setHidden:YES];
            
            
            
            
            
            
            NSString*percent = @"%";
            
            NSString*vote1 = [NSString stringWithFormat:@"%@ Votes (%@%@)",[[globalArray valueForKey:@"VoteCount1"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"Vote1Result"] objectAtIndex:indexPath.section],percent];
            
            
            NSString*vote2 = [NSString stringWithFormat:@"%@ Votes (%@%@)",[[globalArray valueForKey:@"VoteCount2"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"Vote2Result"] objectAtIndex:indexPath.section],percent];
            
            
            if ([[[globalArray valueForKey:@"Vote1Result"] objectAtIndex:indexPath.section] integerValue] > [[[globalArray valueForKey:@"Vote2Result"] objectAtIndex:indexPath.section] integerValue]) {
                cell.voteLabelLeft.textColor = [UIColor colorWithRed:0/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
                
                cell.votesLabelRight.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                //                [cell.leftTickImage setHidden:NO];
                //                [cell.rightTickImage setHidden:YES];
                
            }
            
            else if([[[globalArray valueForKey:@"Vote1Result"] objectAtIndex:indexPath.section] integerValue] == [[[globalArray valueForKey:@"Vote2Result"] objectAtIndex:indexPath.section] integerValue]){
                
                
                
                cell.voteLabelLeft.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                cell.votesLabelRight.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                //                [cell.leftTickImage setHidden:YES];
                //                [cell.rightTickImage setHidden:YES];
            }
            
            else{
                
                
                cell.voteLabelLeft.textColor = [UIColor colorWithRed:232/255.0 green:22/255.0 blue:42/255.0 alpha:1.0];
                
                cell.votesLabelRight.textColor = [UIColor colorWithRed:0/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
                
                
                //                [cell.leftTickImage setHidden:YES];
                //                [cell.rightTickImage setHidden:NO];
            }
            
            cell.voteLabelLeft.text = vote1;
            cell.votesLabelRight.text = vote2;
            
            
            //Total HeyVote Counts
            
            
            NSString* totalVotes = [NSString stringWithFormat:@"%@ HeyVotes",[[globalArray valueForKey:@"VoteCount"] objectAtIndex:indexPath.section]];
            
            cell.totalVotesLabel.text = totalVotes;
            
            
            //Comments Count
            
            if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count]  >1) {
                
                NSString * totalComments = [NSString stringWithFormat:@"%ld comments",(long)[[[globalArray valueForKey:@"CommentCount"] objectAtIndex:indexPath.section] integerValue]];
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalComments];
                [attString addAttribute:NSUnderlineStyleAttributeName
                                  value:[NSNumber numberWithInt:1]
                                  range:(NSRange){0,[attString length]}];
                cell.totalComments.text =totalComments;
            }
            
            else{
                
                NSString * totalComments = [NSString stringWithFormat:@"%ld comments",(long)[[[globalArray valueForKey:@"CommentCount"] objectAtIndex:indexPath.section] integerValue]];
                
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:totalComments];
                [attString addAttribute:NSUnderlineStyleAttributeName
                                  value:[NSNumber numberWithInt:1]
                                  range:(NSRange){0,[attString length]}];
                cell.totalComments.text =totalComments;
                
                
            }
            
            
            
            
            //Post Title
            
            [cell.titleLabelView setHidden:NO];
            
            cell.titleLabel.text = [[globalArray valueForKey:@"Title"] objectAtIndex:indexPath.section];
            
            //Comment Attribute Label
            
            if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 1) {
                
                
                
                
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:YES];
                
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
            }
            
            
            else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 2) {
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:NO];
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                NSString * commetAttrTextTwoo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:1];
                
                
                
                NSString * commentAttrTextt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:1];
                
                NSString * combinedTextt = [NSString stringWithFormat:@"%@ %@",commentAttrTextt,commetAttrTextTwoo];
                
                
                
                CGFloat boldTextFontSizee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range11 = [combinedTextt rangeOfString:commentAttrTextt];
                NSRange range22 = [combinedTextt rangeOfString:commetAttrTextTwoo];
                
                NSMutableAttributedString *attributedTextt = [[NSMutableAttributedString alloc] initWithString:combinedTextt];
                
                
                
                
                
                [attributedTextt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range22];
                
                
                
                [attributedTextt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizee]}
                                         range:range11];
                
                
                cell.commentAttributedLabelTwo.attributedText = attributedTextt;
                
                
                
                
                
                
                
            }
            
            
            else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 3) {
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:NO];
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                NSString * commetAttrTextTwoo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:1];
                
                
                
                NSString * commentAttrTextt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:1];
                
                NSString * combinedTextt = [NSString stringWithFormat:@"%@ %@",commentAttrTextt,commetAttrTextTwoo];
                
                
                
                CGFloat boldTextFontSizee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range11 = [combinedTextt rangeOfString:commentAttrTextt];
                NSRange range22 = [combinedTextt rangeOfString:commetAttrTextTwoo];
                
                NSMutableAttributedString *attributedTextt = [[NSMutableAttributedString alloc] initWithString:combinedTextt];
                
                
                
                
                
                [attributedTextt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range22];
                
                
                
                [attributedTextt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizee]}
                                         range:range11];
                
                
                cell.commentAttributedLabelTwo.attributedText = attributedTextt;
                
                
                
                
                NSString * commetAttrTextTwooo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:2];
                
                
                
                NSString * commentAttrTexttt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:2];
                
                NSString * combinedTexttt = [NSString stringWithFormat:@"%@ %@",commentAttrTexttt,commetAttrTextTwooo];
                
                
                
                CGFloat boldTextFontSizeee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range111 = [combinedTexttt rangeOfString:commentAttrTexttt];
                NSRange range222 = [combinedTexttt rangeOfString:commetAttrTextTwooo];
                
                NSMutableAttributedString *attributedTexttt = [[NSMutableAttributedString alloc] initWithString:combinedTexttt];
                
                
                
                
                
                [attributedTexttt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range222];
                
                
                
                [attributedTexttt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizeee]}
                                          range:range111];
                
                
                cell.commentAttributedLabelThree.attributedText = attributedTexttt;
                
                
                
                
                
                
            }
            
            
            
            else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] > 3) {
                //                [cell.commentAttributedLabel setHidden:NO];
                //                [cell.showMoreComments setHidden:NO];
                
                NSString * commetAttrTextTwo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:0];
                
                
                
                NSString * commentAttrText = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:0];
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                cell.commentAttributedLabel.attributedText = attributedText;
                
                
                
                NSString * commetAttrTextTwoo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:1];
                
                
                
                NSString * commentAttrTextt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:1];
                
                NSString * combinedTextt = [NSString stringWithFormat:@"%@ %@",commentAttrTextt,commetAttrTextTwoo];
                
                
                
                CGFloat boldTextFontSizee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range11 = [combinedTextt rangeOfString:commentAttrTextt];
                NSRange range22 = [combinedTextt rangeOfString:commetAttrTextTwoo];
                
                NSMutableAttributedString *attributedTextt = [[NSMutableAttributedString alloc] initWithString:combinedTextt];
                
                
                
                
                
                [attributedTextt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range22];
                
                
                
                [attributedTextt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizee]}
                                         range:range11];
                
                
                cell.commentAttributedLabelTwo.attributedText = attributedTextt;
                
                
                
                
                NSString * commetAttrTextTwooo = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Comment"] objectAtIndex:2];
                
                
                
                NSString * commentAttrTexttt = [[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"DisplayName"] objectAtIndex:2];
                
                NSString * combinedTexttt = [NSString stringWithFormat:@"%@ %@",commentAttrTexttt,commetAttrTextTwooo];
                
                
                
                CGFloat boldTextFontSizeee = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range111 = [combinedTexttt rangeOfString:commentAttrTexttt];
                NSRange range222 = [combinedTexttt rangeOfString:commetAttrTextTwooo];
                
                NSMutableAttributedString *attributedTexttt = [[NSMutableAttributedString alloc] initWithString:combinedTexttt];
                
                
                
                
                
                [attributedTexttt addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range222];
                
                
                
                [attributedTexttt setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSizeee]}
                                          range:range111];
                
                
                cell.commentAttributedLabelThree.attributedText = attributedTexttt;
                
                
                
                
                [cell.showMoreComments setHidden:NO];
                
            }
            
            
            // Post is Live Or Done
            
            if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:indexPath.section] integerValue]  == 0 ) {
                
                
                
                //  [cell.timerCell setHidden:NO];
                // [cell.remainingLabel setHidden:NO];
                
                
                NSString *stringTimer =[[globalArray valueForKey:@"EndDate"] objectAtIndex:indexPath.section];
                
                
                NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
                NSArray *splitString = [stringTimer componentsSeparatedByCharactersInSet:delimiters];
                
                NSString *xString = [splitString objectAtIndex:0];
                NSString *yString = [splitString objectAtIndex:1];
                
                
                
                if ([yString containsString:@"-"]) {
                    
                    NSArray *arrrr = [yString componentsSeparatedByString:@"-"];
                    
                    
                    NSString* testOne = [arrrr objectAtIndex:0];
                    
                    
                    NSString* beforeConvert =[arrrr objectAtIndex:1];
                    
                    NSString*mystr=[beforeConvert substringToIndex:2];
                    
                    NSInteger multipliedVal = [mystr integerValue] * 3600000;
                    
                    NSString * finalVal = [NSString stringWithFormat:@"%ld",[testOne integerValue] - multipliedVal];
                    
                    
                    NSDate *tr = [NSDate dateWithTimeIntervalSince1970:[finalVal integerValue]/1000.0];
                    
                    
                    
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    
                    
                    NSString* localTime = [dateFormatter stringFromDate:tr];
                    
                    NSLog(@"localTime:%@", localTime);
                    
                    NSDateFormatter *dateFormatterCurrent=[[NSDateFormatter alloc] init];
                    [dateFormatterCurrent setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
                    
                    
                    
                    NSString* localCurrentTime = [dateFormatterCurrent stringFromDate:[NSDate date]];
                    NSLog(@"current time :%@",localCurrentTime);
                    
                    NSTimeInterval diff = [tr timeIntervalSinceDate:[NSDate date]];
                    
                    NSLog(@"difffereeenceee %f",diff*1000 );
                    
                    valText = diff*1000;
                    
                    
                    float seconds = valText / 1000.0;
                    float minutes = seconds / 60.0;
                    
                    
                    testVa = minutes/1440;
                    
                    
                    
                    //                    float percentVal = testVa * 100;
                    //
                    //                    float percentFinalVal = percentVal/100
                    //
                    
                    if ([[self calculateTimer] isEqualToString:@""]) {
                        [cell.timerCell setHidden:YES];
                        [cell.progresssView setHidden:YES];
                    }
                    
                    else{
                        //  [cell.timerCell setHidden:NO];
                        //  [cell.remainingLabel setHidden:NO];
                        cell.timerCell.text =  [self calculateTimer];
                        
                        
                        
                    }
                    
                    //
                    //                    if (valText >0 && valText <86400000 ) {
                    ////                        _timerCalc = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runScheduledTask:) userInfo:nil repeats:NO];
                    //
                    //
                    //                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(valText / 1000.0)];
                    //
                    //                        NSString* localTimeee =[NSString stringWithFormat:@"%@",date];
                    //
                    //                        NSArray *seperateVal =  [localTimeee componentsSeparatedByString:@" "];
                    //
                    //                        NSArray *timeSplit = [[seperateVal objectAtIndex:1] componentsSeparatedByString:@":"];
                    //
                    //
                    //                      NSString*  exactTimeee = [NSString stringWithFormat:@"%@h. %@m. %@s.",[timeSplit objectAtIndex:0],[timeSplit objectAtIndex:1],[timeSplit objectAtIndex:2]];
                    //
                    //                        cell.timerCell.text  = exactTimeee;
                    //
                    //                        NSLog(@"timerrrr : %@",cell.timerCell.text);
                    //
                    //
                    //
                    //                    }
                    //
                    //
                    //
                    
                }
                
                
                
                /*******/
                [cell.yesNoMainView setHidden:NO];
                [cell.yesNoButtonView setHidden:YES];
                [cell.yesNoNotDoneButtonView setHidden:NO];
                cell.leftButton.userInteractionEnabled = YES;
                cell.rightButton.userInteractionEnabled = YES;
                
                [cell.leftButton setBackgroundColor:[UIColor whiteColor]];
                [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
                
                [cell.reheyVoteButton setHidden:YES];
                
                
                //Has Voted Or not Button View
                
                
                if ([[[globalArray valueForKey:@"hasVoted"] objectAtIndex:indexPath.section] integerValue]  == 0) {
                    
                    if ([voteResultAraay containsObject:[globalArray objectAtIndex:indexPath.section]]) {
                        
                        
                        
                        if ([voteResultVal isEqualToString:@"leftvoted"] || [voteResultVal isEqualToString:@"rightvoted"]) {
                            
                            
                            
                            
                            [cell.progresssView setHidden:YES];
                            
                            cell.circularProgress.progressTintColor = [UIColor colorWithRed:202.0f/255.0f
                                                                                      green:0.0f/255.0f
                                                                                       blue:20.0f/255.0f
                                                                                      alpha:0.7f];
                            cell.circularProgress.max = 1.0f;
                            cell.circularProgress.fillRadiusPx = 25;
                            cell.circularProgress.step = 0.1f;
                            cell.circularProgress.startAngle = (M_PI * 3) * 0.5;
                            cell.circularProgress.translatesAutoresizingMaskIntoConstraints = NO;
                            cell.circularProgress.outlineWidth = 1;
                            cell.circularProgress.outlineTintColor = [UIColor whiteColor];
                            cell.circularProgress.endPoint = [[HKCircularProgressEndPointSpike alloc] init];
                            
                            
                            [[HKCircularProgressView appearance] setAnimationDuration:5];
                            
                            cell.circularProgress.alwaysDrawOutline = YES;
                            
                            
                            cell.insideProgress.fillRadius = 1;
                            cell.insideProgress.progressTintColor = [UIColor lightGrayColor];
                            cell.insideProgress.translatesAutoresizingMaskIntoConstraints = NO;
                            [cell.circularProgress setCurrent:testVa
                                                     animated:YES];
                            [cell.insideProgress setCurrent:1.0f
                                                   animated:YES];
                            
                            
                            
                            NSString*uVoted;
                            
                            // [cell.yesNoMainView setHidden:YES];
                            
                            if ([voteResultVal isEqualToString:@"leftvoted"]) {
                                
                                cell.leftButton.userInteractionEnabled = NO;
                                cell.rightButton.userInteractionEnabled = NO;
                                
                                [cell.leftButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                                    green:200.0f/255.0f
                                                                                     blue:200.0f/255.0f
                                                                                    alpha:1.0f]];
                                [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
                                
                                
                                
                            }
                            
                            else if([voteResultVal isEqualToString:@"rightvoted"] == 1) {
                                
                                
                                cell.leftButton.userInteractionEnabled = NO;
                                cell.rightButton.userInteractionEnabled = NO;
                                
                                [cell.leftButton setBackgroundColor:[UIColor whiteColor]];
                                [cell.rightButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                                     green:200.0f/255.0f
                                                                                      blue:200.0f/255.0f
                                                                                     alpha:1.0f]];
                                
                                
                            }
                            
                            cell.youHaveVotedLabel.text =uVoted;
                        }
                        
                        else{
                            
                            
                            
                            [cell.yesNoMainView setHidden:NO];
                            [cell.yesNoButtonView setHidden:YES];
                            [cell.yesNoNotDoneButtonView setHidden:NO];
                        }
                        
                    }
                    
                }
                
                else if ([[[globalArray valueForKey:@"hasVoted"] objectAtIndex:indexPath.section] integerValue]  == 1 ) {
                    // [cell.yesNoMainView setHidden:YES];
                    
                    //                    [cell.progresssView setHidden:YES];
                    //                    [cell.timerCell setHidden:NO];
                    //                    [cell.remainingLabel setHidden:NO];
                    //
                    cell.circularProgress.progressTintColor = [UIColor colorWithRed:202.0f/255.0f
                                                                              green:0.0f/255.0f
                                                                               blue:20.0f/255.0f
                                                                              alpha:0.7f];
                    cell.circularProgress.max = 1.0f;
                    cell.circularProgress.fillRadiusPx = 25;
                    cell.circularProgress.step = 0.1f;
                    cell.circularProgress.startAngle = (M_PI * 3) * 0.5;
                    cell.circularProgress.translatesAutoresizingMaskIntoConstraints = NO;
                    cell.circularProgress.outlineWidth = 1;
                    cell.circularProgress.outlineTintColor = [UIColor whiteColor];
                    cell.circularProgress.endPoint = [[HKCircularProgressEndPointSpike alloc] init];
                    
                    
                    [[HKCircularProgressView appearance] setAnimationDuration:5];
                    
                    cell.circularProgress.alwaysDrawOutline = YES;
                    
                    
                    cell.insideProgress.fillRadius = 1;
                    cell.insideProgress.progressTintColor = [UIColor lightGrayColor];
                    cell.insideProgress.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.circularProgress setCurrent:testVa
                                             animated:YES];
                    [cell.insideProgress setCurrent:1.0f
                                           animated:YES];
                    
                    
                    
                    
                    NSString*uVoted;
                    
                    
                    if ([[[globalArray valueForKey:@"VoteOption"] objectAtIndex:indexPath.section] integerValue] == 0) {
                        
                        cell.leftButton.userInteractionEnabled = NO;
                        cell.rightButton.userInteractionEnabled = NO;
                        
                        [cell.leftButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                            green:200.0f/255.0f
                                                                             blue:200.0f/255.0f
                                                                            alpha:1.0f]];
                        [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
                        
                        
                    }
                    
                    else if([[[globalArray valueForKey:@"VoteOption"] objectAtIndex:indexPath.section] integerValue] == 1) {
                        
                        cell.leftButton.userInteractionEnabled = NO;
                        cell.rightButton.userInteractionEnabled = NO;
                        
                        
                        
                        [cell.leftButton setBackgroundColor:[UIColor whiteColor]];
                        [cell.rightButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                             green:200.0f/255.0f
                                                                              blue:200.0f/255.0f
                                                                             alpha:1.0f]];
                        
                        
                    }
                    
                    cell.youHaveVotedLabel.text =uVoted;
                }
                
                
                
                
                
            }
            
            
            
            else if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:indexPath.section] integerValue]  == 1) {
                [cell.timerCell setHidden:YES];
                [cell.remainingLabel setHidden:YES];
                
                [cell.yesNoMainView setHidden:NO];
                [cell.yesNoButtonView setHidden:NO];
                [cell.yesNoNotDoneButtonView setHidden:NO];
                cell.leftButton.userInteractionEnabled = NO;
                cell.rightButton.userInteractionEnabled = NO;
                
                
                [cell.reheyVoteButton setHidden:NO];
                
            }
            
            
            //Button Caption (YES/NO)
            [cell.leftButton setTitle:[[globalArray valueForKey:@"Caption1"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            [cell.rightButton setTitle:[[globalArray valueForKey:@"Caption2"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            [cell.leftResultButton setTitle:[[globalArray valueForKey:@"Caption1"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            [cell.rightResultButton setTitle:[[globalArray valueForKey:@"Caption2"] objectAtIndex:indexPath.section] forState: UIControlStateNormal];
            
            //   return cell;
            
            
        }
        
        
        
        
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:
                cellIdentifier];
        if (cell == nil) {
            cell = [[globalViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    
    return cell;
    
}




// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (globalArray.count == 0) {
        return 1;
    }
    else{
        return [globalArray count];
        
    }
}



#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    NSArray *collectionViewArray = self.colorArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    //    return collectionViewArray.count;
    
    return [nameArr count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionIdentifier" forIndexPath:indexPath];
    
    if (nameArr.count == 0) {
        
    }else{
        
        cell.hashLabels.text = [NSString stringWithFormat:@"#%@",[[nameArr valueForKey:@"HashTag"] objectAtIndex:indexPath.row]];
        
        //[cell.hashLabels sizeToFit];
        
        // [cell.hashLabels sizeToFit];
        
        //        //get the width and height of the label (CGSize contains two parameters: width and height)
        labelSize = cell.hashLabels.frame.size;
        //
        //        NSLog(@"\n width  = %f height = %f", labelSize.width,labelSize.height);
        //
        
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //
    //    return [(NSString*)[[nameArr valueForKey:@"HashTag"] objectAtIndex:indexPath.row] sizeWithAttributes:NULL];
    return CGSizeMake([[[nameArr valueForKey:@"HashTag"] objectAtIndex:indexPath.row] length]+ 60, 15);
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    side = collectionView.frame.size.width/2-5;
//    height= collectionView.frame.size.height/2+collectionView.frame.size.height/2;
//
//
//    return CGSizeMake(side, height);
//}
////- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point
////{
////
////	return
////}
//
//
//
//-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
//{
//    CGRect buttonFrame = [button convertRect:button.bounds toView:_travelFeedTableView];
//    return [_travelFeedTableView indexPathForRowAtPoint:buttonFrame.origin];
//}
//
//


- (NSString *) calculateTimer
{
    // Here count down timer is only for visible rows not for each rows.
    NSString*  exactTimeee;
    //  NSArray *listOFCurrentCell = [_myTableView visibleCells]; // Returns the table cells that are visible in the table view.
    // for(globalViewCell *theMycustomCell in listOFCurrentCell)
    //  {
    if (valText >0 && valText <86400000 ) {
        
        
        
        secondsLeft = valText;
        
        
        secondsLeft--;
        
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(secondsLeft / 1000.0)];
        
        NSString* localTime =[NSString stringWithFormat:@"%@",date];
        
        NSArray *seperateVal =  [localTime componentsSeparatedByString:@" "];
        
        NSArray *timeSplit = [[seperateVal objectAtIndex:1] componentsSeparatedByString:@":"];
        
        if ([[timeSplit objectAtIndex:0] isEqualToString:@"00"]) {
            exactTimeee = [NSString stringWithFormat:@"%@m. %@s.",[timeSplit objectAtIndex:1],[timeSplit objectAtIndex:2]];
            
            
        }
        
        else {
            
            exactTimeee = [NSString stringWithFormat:@"%@h. %@m. %@s.",[timeSplit objectAtIndex:0],[timeSplit objectAtIndex:1],[timeSplit objectAtIndex:2]];
            
            
        }
        
        
        
        
        // Timer.text = exactTime;
        //[_myTableView reloadData];
        if (secondsLeft==0) {
            [_timerCalc invalidate];
            
            exactTime = @"";
        }
        
        
        
        
        
        
        // recentVal = exactTimeee;
        //  }
        
        
        
        
    }
    
    
    return exactTimeee;
}

- (void)runScheduledTask: (NSTimer *) runningTimer {
    if ([timerLoad isEqualToString:@""]) {
        
        //
        //          NSArray *visible       = [self.myTableView indexPathsForVisibleRows];
        //         NSIndexPath *indexpath = (NSIndexPath*)[visible objectAtIndex:0];
        //
        //        //  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        //
        //          globalViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexpath];
        //
        
        [_myTableView reloadData];
        
    }
    
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.mc stop];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (globalArray.count >0) {
        
        if ([[[globalArray valueForKey:@"ReHeyVotePostId"] objectAtIndex:section] integerValue]==0) {
            
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
            button.tag = section;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button.backgroundColor = [UIColor clearColor];
            
            // Doing the Decoration Part
            view.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
            view.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
            view.layer.shadowRadius = 0.0f;
            view.layer.shadowOpacity = 0.1f;
            
            
            /* Create custom view to display section header... */
            
            UILabel *label;
            //  label = [[UILabel alloc] initWithFrame:CGRectMake(58, 24, 200, 20)];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(58, 14, 200, 20)];
            [label setFont:[UIFont boldSystemFontOfSize:15]];
            NSString *string =[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:section];
            
            
            /* Section header is in 0th index... */
            [label setText:string];
            //  [label sizeToFit];
            
            [label setTextColor:[UIColor blackColor]];
            
            if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:section] integerValue]  == 0 ) {
                
                
                //  Timer = [[UILabel alloc] initWithFrame:CGRectMake(_myTableView.frame.size.width - 130, 24, 130, 20)];
                
                Timer = [[UILabel alloc] initWithFrame:CGRectMake(58, 32, 300, 20)];
                [Timer setFont:[UIFont boldSystemFontOfSize:14]];
                
                
                
                Timer.textAlignment = NSTextAlignmentRight;
                
                NSString *stringTimer =[[globalArray valueForKey:@"EndDate"] objectAtIndex:section];
                
                
                NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
                NSArray *splitString = [stringTimer componentsSeparatedByCharactersInSet:delimiters];
                
                NSString *xString = [splitString objectAtIndex:0];
                NSString *yString = [splitString objectAtIndex:1];
                
                
                
                if ([yString containsString:@"-"]) {
                    
                    NSArray *arrrr = [yString componentsSeparatedByString:@"-"];
                    
                    
                    NSString* testOne = [arrrr objectAtIndex:0];
                    
                    
                    NSString* beforeConvert =[arrrr objectAtIndex:1];
                    
                    NSString*mystr=[beforeConvert substringToIndex:2];
                    
                    NSInteger multipliedVal = [mystr integerValue] * 3600000;
                    
                    NSString * finalVal = [NSString stringWithFormat:@"%ld",[testOne integerValue] - multipliedVal];
                    
                    
                    NSDate *tr = [NSDate dateWithTimeIntervalSince1970:[finalVal integerValue]/1000.0];
                    
                    
                    
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    
                    
                    NSString* localTime = [dateFormatter stringFromDate:tr];
                    
                    NSLog(@"localTime:%@", localTime);
                    
                    NSDateFormatter *dateFormatterCurrent=[[NSDateFormatter alloc] init];
                    [dateFormatterCurrent setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
                    
                    
                    
                    NSString* localCurrentTime = [dateFormatterCurrent stringFromDate:[NSDate date]];
                    NSLog(@"current time :%@",localCurrentTime);
                    
                    NSTimeInterval diff = [tr timeIntervalSinceDate:[NSDate date]];
                    
                    NSLog(@"difffereeenceee %f",diff*1000 );
                    
                    valText = diff*1000;
                    
                    
                    
                    
                    if([[self calculateTimer] isEqualToString:@""]){
                        
                        [Timer setText:@""];
                        
                    }
                    
                    else{
                        
                        
                        [Timer setText:[self calculateTimer]];
                        //  [Timer sizeToFit];
                    }
                    [view addSubview:Timer];
                    [Timer setTextColor:[UIColor darkGrayColor]];
                    
                }
                
            }
            
            NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[globalArray valueForKey:@"ImgIdf"] objectAtIndex:section],[[globalArray valueForKey:@"FolderPath"] objectAtIndex:section]];
            
            
            
            UIImageView *labelImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 40, 40)];
            
            [labelImage  sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"imagesPerson.jpeg"]];
            
            labelImage.layer.cornerRadius = labelImage.frame.size.height /2;
            labelImage.layer.masksToBounds = YES;
            labelImage.layer.borderWidth = 0;
            
            
            
            [view addSubview:labelImage];
            
            
            [view addSubview:label];
            
            
            [view addSubview:button];
            
            
            [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
            
            return view;
            
        }
        
        else{
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
            button.tag = section;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button.backgroundColor = [UIColor clearColor];
            
            // Doing the Decoration Part
            view.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
            view.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
            view.layer.shadowRadius = 0.0f;
            view.layer.shadowOpacity = 0.1f;
            
            
            /* Create custom view to display section header... */
            
            UILabel *label;
            label = [[UILabel alloc] initWithFrame:CGRectMake(58, 14, 200, 20)];
            [label setFont:[UIFont boldSystemFontOfSize:15]];
            NSString *string =[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:section];
            
            
            NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[globalArray valueForKey:@"ImgIdf"] objectAtIndex:section],[[globalArray valueForKey:@"FolderPath"] objectAtIndex:section]];
            
            /* Section header is in 0th index... */
            [label setText:string];
            //  [label sizeToFit];
            [label setTextColor:[UIColor blackColor]];
            
            
            if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:section] integerValue]  == 0 ) {
                
                Timer = [[UILabel alloc] initWithFrame:CGRectMake(_myTableView.frame.size.width - 120, 14, 120, 20)];
                [Timer setFont:[UIFont boldSystemFontOfSize:14]];
                
                
                Timer.textAlignment = NSTextAlignmentRight;
                
                NSString *stringTimer =[[globalArray valueForKey:@"EndDate"] objectAtIndex:section];
                
                
                NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
                NSArray *splitString = [stringTimer componentsSeparatedByCharactersInSet:delimiters];
                
                NSString *xString = [splitString objectAtIndex:0];
                NSString *yString = [splitString objectAtIndex:1];
                
                
                
                if ([yString containsString:@"-"]) {
                    
                    NSArray *arrrr = [yString componentsSeparatedByString:@"-"];
                    
                    
                    NSString* testOne = [arrrr objectAtIndex:0];
                    
                    
                    NSString* beforeConvert =[arrrr objectAtIndex:1];
                    
                    NSString*mystr=[beforeConvert substringToIndex:2];
                    
                    NSInteger multipliedVal = [mystr integerValue] * 3600000;
                    
                    NSString * finalVal = [NSString stringWithFormat:@"%ld",[testOne integerValue] - multipliedVal];
                    
                    
                    NSDate *tr = [NSDate dateWithTimeIntervalSince1970:[finalVal integerValue]/1000.0];
                    
                    
                    
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    
                    
                    NSString* localTime = [dateFormatter stringFromDate:tr];
                    
                    NSLog(@"localTime:%@", localTime);
                    
                    NSDateFormatter *dateFormatterCurrent=[[NSDateFormatter alloc] init];
                    [dateFormatterCurrent setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
                    
                    
                    
                    NSString* localCurrentTime = [dateFormatterCurrent stringFromDate:[NSDate date]];
                    NSLog(@"current time :%@",localCurrentTime);
                    
                    NSTimeInterval diff = [tr timeIntervalSinceDate:[NSDate date]];
                    
                    NSLog(@"difffereeenceee %f",diff*1000 );
                    
                    valText = diff*1000;
                    
                    
                    
                    
                    if([[self calculateTimer] isEqualToString:@""]){
                        
                        [Timer setText:@""];
                    }
                    
                    else{
                        [Timer setText:[self calculateTimer]];
                        //  [Timer sizeToFit];
                    }
                    
                    /* Section header is in 0th index... */
                    
                    
                    [Timer setTextColor:[UIColor darkGrayColor]];
                    [view addSubview:Timer];
                    
                }
                
            }
            
            
            
            UILabel *labelSub = [[UILabel alloc] initWithFrame:CGRectMake(58, 32, 300, 20)];
            [labelSub setFont:[UIFont boldSystemFontOfSize:12]];
            
            
            NSString* rehey = [NSString stringWithFormat:@"has Re-HeyVoted %@'s post",[[globalArray valueForKey:@"ReHeyVoteUserName"] objectAtIndex:section]];
            
            /* Section header is in 0th index... */
            [labelSub setText:rehey];
            
            [labelSub setTextColor:[UIColor lightGrayColor]];
            
            
            
            UIImageView *labelImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 40, 40)];
            
            [labelImage  sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"imagesPerson.jpeg"]];
            
            labelImage.layer.cornerRadius = labelImage.frame.size.height /2;
            labelImage.layer.masksToBounds = YES;
            labelImage.layer.borderWidth = 0;
            
            
            
            
            
            
            
            
            
            [view addSubview:labelImage];
            
            
            [view addSubview:label];
            
            [view addSubview:labelSub];
            [view addSubview:button];
            
            
            
            
            
            [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
            
            return view;
            
        }
        
        
    }
    
    
    
    return nil;
}


-(void)buttonAction:(id)sender{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        
        BOOL interNetCheck=[WebServiceUrl InternetCheck];
        if (interNetCheck==YES ) {
            
            UIView *newView = [[UIView alloc]init];
            newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:newView];
            
            [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
            
            
            
            
            NSDictionary *jsonDictionary =@{
                                            @"contactToken":[[globalArray valueForKey:@"UserIdf"] objectAtIndex:indexPath.section],
                                            @"isWeb":@"false"                                           };
            
            
            
            
            
            
            NSError *error;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                
                                                               options:0
                                
                                                                 error:&error];
            
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON OUTPUT: %@",JSONString);
            
            NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/viewprofileExternal_N4"]];
            
            
            
            [requestPost setHTTPMethod:@"POST"];
            
            
            
            [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
            
            
            
            NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            [requestPost setHTTPBody: requestData];
            
            //  [requestPost addValue:@"hhhffftttuuu" forHTTPHeaderField:@"Value"];
            
            
            
            [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
            
            // NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:requestPost delegate:self];
            
            [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (error) {
                    //do something with error
                } else {
                    
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    //            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
                    //            NSString *newLineStr = @"\n";
                    //            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
                    //
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (dic==nil) {
                            
                            
                            [GMDCircleLoader hideFromView:newView animated:YES];
                            [newView removeFromSuperview];
                            
                            
                        }
                        else{
                            
                            
                            NSLog(@"hjfshjfhs%@",dic);
                            
                            
                            
                            
                            NSMutableArray*arrayVal = [[NSMutableArray alloc]init];
                            
                            [arrayVal addObject:[dic valueForKey:@"ViewProfileExternal_N4Result"]];
                            
                            [GMDCircleLoader hideFromView:newView animated:YES];
                            [newView removeFromSuperview];
                            
                            
                            
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            heyVoteProfileVC *myVC = (heyVoteProfileVC *)[storyboard instantiateViewControllerWithIdentifier:@"heyVoteProfileVC"];
                            myVC.profileArray = arrayVal;
                            myVC.contactToke = [[globalArray valueForKey:@"Token"] objectAtIndex:indexPath.section];
                            [self PushAnimation];
                            [self.navigationController pushViewController:myVC animated:NO];
                            
                            
                        }
                        
                        
                        
                        
                    });
                }
            }];
        }
        
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        
        
    }
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//}

//-(CGFloat)tableView:(UITableView *)tableView
//estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (IBAction)homeButton:(id)sender {
}

- (IBAction)centerButton:(id)sender {
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraViewController *myVC = (CameraViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    
    
    
    [self presentViewController:myVC animated:YES completion:nil];
    
}

- (IBAction)searchButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    searchTabViewController *myVC = (searchTabViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchTabViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
}

- (IBAction)profileButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    profileViewController *myVC = (profileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
    
    
}

- (IBAction)contactsButton:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactsTabViewController *myVC = (ContactsTabViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ContactsTabViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
    
    
    
}

-(void)PushAnimation
{
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.0f;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
}




-(void)callWebServiceRefresh:(int)indexVal{
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        
        NSDictionary *jsonDictionary =@{
                                        
                                        @"isWeb":@"false",
                                        @"pageId":[NSNumber numberWithInt:indexVal],
                                        @"pageSize":[NSNumber numberWithInt:5],
                                        @"categoryId":[NSNumber numberWithInteger:categoryID],
                                        @"statusId":[NSNumber numberWithInteger:statusID]
                                        
                                        
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/GetPostList_N5"]];
        
        
        
        [requestPost setHTTPMethod:@"POST"];
        
        
        
        [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        
        
        
        NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        [requestPost setHTTPBody: requestData];
        
        //  [requestPost addValue:@"hhhffftttuuu" forHTTPHeaderField:@"Value"];
        
        
        
        [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
        
        // NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:requestPost delegate:self];
        
        [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                //do something with error
            } else {
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                //            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
                //            NSString *newLineStr = @"\n";
                //            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
                //
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (dic==nil) {
                        
                        [ _refreshControl endRefreshing];
                        
                        [_myTableView setUserInteractionEnabled:YES];
                        
                    }
                    else{
                        
                        
                        NSLog(@"hjfshjfhs%@",dic);
                        
                        
                        if (indexVal == 0) {
                            globalArray = [[NSMutableArray alloc]init];
                        }
                        
                        
                        NSMutableArray* dataArray = [[NSMutableArray alloc]init];
                        
                        
                        [dataArray addObjectsFromArray:[dic valueForKey:@"GetPostList_N5Result"]];
                        
                        if (dataArray.count > 0) {
                            [globalArray addObjectsFromArray:dataArray];
                            
                            [_myTableView reloadData];
                            
                        }
                        
                        
                        
                        [ _refreshControl endRefreshing];
                        [_myTableView setUserInteractionEnabled:YES];
                        
                    }
                    
                    
                    
                    
                });
            }
        }];
    }
    
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
}




-(void)callWebService:(int)indexVal{
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        
                                        @"isWeb":@"false",
                                        @"pageId":[NSNumber numberWithInt:indexVal],
                                        @"pageSize":[NSNumber numberWithInt:5],
                                        @"categoryId":[NSNumber numberWithInteger:categoryID],
                                        @"statusId":[NSNumber numberWithInteger:statusID]
                                        
                                        
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/GetPostList_N5"]];
        
        
        
        [requestPost setHTTPMethod:@"POST"];
        
        
        
        [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        
        
        
        NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        [requestPost setHTTPBody: requestData];
        
        //  [requestPost addValue:@"hhhffftttuuu" forHTTPHeaderField:@"Value"];
        
        
        
        [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
        
        // NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:requestPost delegate:self];
        
        [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                //do something with error
            } else {
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                //            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
                //            NSString *newLineStr = @"\n";
                //            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
                //
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (dic==nil) {
                        
                        [ _refreshControl endRefreshing];
                        
                        [GMDCircleLoader hideFromView:newView animated:YES];
                        [newView removeFromSuperview];
                        
                    }
                    else{
                        
                        NSLog(@"hjfshjfhs%@",dic);
                        
                        
                        if (indexVal == 0) {
                            globalArray = [[NSMutableArray alloc]init];
                        }
                        
                        
                        NSMutableArray* dataArray = [[NSMutableArray alloc]init];
                        
                        
                        [dataArray addObjectsFromArray:[dic valueForKey:@"GetPostList_N5Result"]];
                        
                        if (dataArray.count > 0) {
                            
                            [_noPostView setHidden:YES];
                            [globalArray addObjectsFromArray:dataArray];
                            
                            [_myTableView reloadData];
                            
                            [_noPostView setHidden:YES];
                            
                            
                        }
                        
                        
                        if (indexVal == 0) {
                            
                            
                            if (globalArray.count == 0) {
                                [_noPostView setHidden:NO];
                            }
                            
                            else{
                                
                                [_noPostView setHidden:YES];
                            }
                            
                        }
                        
                        
                        
                        [ _refreshControl endRefreshing];
                        
                        [GMDCircleLoader hideFromView:newView animated:YES];
                        [newView removeFromSuperview];
                        
                        timerLoad = @"";
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                });
            }
        }];
    }
    
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
}



-(void)callNewUpdates: (NSTimer *) runningTimer{
    
    if (globalArray.count > 0) {
        
        
        
        NSMutableArray * newArrayyy = [[NSMutableArray alloc]init];
        
        [newArrayyy addObject:[globalArray objectAtIndex:0]];
        
        
        int newValUpdates = 0;
        BOOL interNetCheck=[WebServiceUrl InternetCheck];
        if (interNetCheck==YES ) {
            
            //        UIView *newView = [[UIView alloc]init];
            //        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            //        [self.view addSubview:newView];
            //
            //        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
            //
            
            
            
            NSDictionary *jsonDictionary =@{
                                            
                                            @"isWeb":@"false",
                                            @"pageId":[NSNumber numberWithInt:newValUpdates],
                                            @"pageSize":[NSNumber numberWithInt:5],
                                            @"categoryId":[NSNumber numberWithInteger:categoryID],
                                            @"statusId":[NSNumber numberWithInteger:statusID]
                                            
                                            
                                            };
            
            
            
            NSError *error;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                
                                                               options:0
                                
                                                                 error:&error];
            
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON OUTPUT: %@",JSONString);
            
            NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/GetPostList_N5"]];
            
            
            
            [requestPost setHTTPMethod:@"POST"];
            
            
            
            [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
            
            
            
            NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            [requestPost setHTTPBody: requestData];
            
            //  [requestPost addValue:@"hhhffftttuuu" forHTTPHeaderField:@"Value"];
            
            
            
            [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
            
            // NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:requestPost delegate:self];
            
            [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (error) {
                    //do something with error
                } else {
                    
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    //            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
                    //            NSString *newLineStr = @"\n";
                    //            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
                    //
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (dic==nil) {
                            
                            [ _refreshControl endRefreshing];
                            
                            //  [GMDCircleLoader hideFromView:newView animated:YES];
                            //  [newView removeFromSuperview];
                            
                        }
                        else{
                            
                            
                            NSLog(@"hjfshjfhs%@",dic);
                            
                            
                            if (newValUpdates == 0) {
                                globalArray = [[NSMutableArray alloc]init];
                            }
                            
                            
                            NSMutableArray* dataArray = [[NSMutableArray alloc]init];
                            
                            NSMutableArray* secArray = [[NSMutableArray alloc]init];
                            
                            
                            [dataArray addObjectsFromArray:[dic valueForKey:@"GetPostList_N5Result"]];
                            
                            if (dataArray.count > 0) {
                                
                                
                                [globalArray addObjectsFromArray:dataArray];
                                
                                [_myTableView reloadData];
                                
                                [secArray addObject:[globalArray objectAtIndex:0]];
                                
                                
                            }
                            
                            
                            if ([newArrayyy isEqualToArray:secArray]) {
                                
                            }
                            
                            else{
                                [heyVoteUpdates setHidden:NO];
                                
                            }
                            
                            
                            
                            [ _refreshControl endRefreshing];
                            
                            //  [GMDCircleLoader hideFromView:newView animated:YES];
                            // [newView removeFromSuperview];
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                    });
                }
            }];
        }
        
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        
    }
    
}





-(void)callProfileView{
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        
        NSDictionary *jsonDictionary =@{
                                        
                                        @"isWeb":@"false",
                                        
                                        
                                        
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/GetBasicProfileData_n1"]];
        
        
        [requestPost setHTTPMethod:@"POST"];
        
        
        
        [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        
        
        
        NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        [requestPost setHTTPBody: requestData];
        
        //  [requestPost addValue:@"hhhffftttuuu" forHTTPHeaderField:@"Value"];
        
        
        
        [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
        
        // NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:requestPost delegate:self];
        
        [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                //do something with error
            } else {
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                //            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
                //            NSString *newLineStr = @"\n";
                //            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
                //
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (dic==nil) {
                        
                        
                        
                    }
                    else{
                        
                        
                        NSLog(@"hjfshjfhs%@",dic);
                        
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"basicInformation"];
                        
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        
                        [_qatarButton setTitle:[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"basicInformation"] allObjects] valueForKey:@"Country"] objectAtIndex:0] forState:UIControlStateNormal];
                        
                        
                    }
                    
                    
                });
            }
        }];
    }
    
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
}




- (IBAction)homwSlider:(id)sender {
    
    if (_homeSlider.value>10 && _homeSlider.value<60) {
        [_globalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_qatarButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
        [_privateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _homeSlider.value = 50;
        
        categoryID = 1;
        
        
        if (_homeSlider.value == 50) {
            [self callWebService:0];
        }
        
        
        
    }
    
    else if (_homeSlider.value>60&& _homeSlider.value<100){
        [_globalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_qatarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_privateButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
        _homeSlider.value = 100;
        categoryID = 2;
        
        
        if (_homeSlider.value == 100) {
            [self callWebService:0];
        }
        
    }
    
    else if(_homeSlider.value <40){
        
        [_globalButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
        [_qatarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_privateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _homeSlider.value = 0;
        
        categoryID = 0;
        
        
        if (_homeSlider.value == 0) {
            [self callWebService:0];
        }
        
    }
}

- (IBAction)globalButton:(id)sender {
    
    [_globalButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
    [_qatarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_privateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _homeSlider.value = 0;
    
    categoryID = 0 ;
    
    [self callWebService:0];
}

- (IBAction)qatarButton:(id)sender {
    
    [_globalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_qatarButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
    [_privateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _homeSlider.value = 50;
    
    categoryID = 2;
    
    [self callWebService:0];
}

- (IBAction)privateButton:(id)sender {
    [_globalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_qatarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_privateButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
    _homeSlider.value = 100;
    
    categoryID = 1;
    
    [self callWebService:0];
}



- (IBAction)homwSliderTwo:(id)sender {
    
    if (_homeSliderTwo.value>10 && _homeSliderTwo.value<60) {
        [_funButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_seriousButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
        [_generalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _homeSliderTwo.value = 50;
        
        // categoryID = 1;
        
        statusID =2;
        
        if (_homeSliderTwo.value == 50) {
            [self callWebService:0];
        }
        
        
        
    }
    
    else if (_homeSliderTwo.value>60&& _homeSliderTwo.value<100){
        [_funButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_seriousButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_generalButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
        _homeSliderTwo.value = 100;
        //categoryID = 2;
        statusID =0;
        
        
        if (_homeSliderTwo.value == 100) {
            [self callWebService:0];
        }
        
    }
    
    else if(_homeSliderTwo.value <40){
        
        [_funButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
        [_seriousButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_generalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _homeSliderTwo.value = 0;
        
        //  categoryID = 0;
        statusID = 1;
        
        
        if (_homeSliderTwo.value == 0) {
            [self callWebService:0];
        }
        
    }
}

- (IBAction)funButton:(id)sender {
    
    [_funButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
    [_seriousButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_generalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _homeSliderTwo.value = 0;
    
    statusID = 1 ;
    
    [self callWebService:0];
}

- (IBAction)seriousButton:(id)sender {
    
    [_funButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_seriousButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
    [_generalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _homeSliderTwo.value = 50;
    
    statusID = 2;
    
    [self callWebService:0];
}

- (IBAction)generalButton:(id)sender {
    [_funButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_seriousButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_generalButton setTitleColor:[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1] forState:UIControlStateNormal];
    _homeSliderTwo.value = 100;
    
    statusID = 0;
    
    [self callWebService:0];
}


- (IBAction)leftButton:(id)sender {
    
    // timerLoad = @"invalid";
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath != nil)
    {
        [voteResultAraay addObject:[globalArray objectAtIndex:indexPath.section]];
        
        
        NSInteger IDval = [[[globalArray valueForKey:@"Id"] objectAtIndex:indexPath.section] integerValue];
        
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:indexPath.section] integerValue]  == 0) {
            
            
            if ( [[[globalArray objectAtIndex:indexPath.section] valueForKey:@"hasVoted"] integerValue ]==0) {
                
                
                
                cell.leftButton.userInteractionEnabled = NO;
                cell.rightButton.userInteractionEnabled = NO;
                
                
                
                [cell.leftButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                    green:200.0f/255.0f
                                                                     blue:200.0f/255.0f
                                                                    alpha:1.0f]];
                [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
                
                if ([[[globalArray valueForKey:@"PostType"] objectAtIndex:indexPath.section] integerValue] == 1) {
                    
                    [cell.progresssView setHidden:NO];
                    
                    cell.circularProgress.progressTintColor = [UIColor colorWithRed:202.0f/255.0f
                                                                              green:0.0f/255.0f
                                                                               blue:20.0f/255.0f
                                                                              alpha:0.7f];
                    cell.circularProgress.max = 1.0f;
                    cell.circularProgress.fillRadiusPx = 25;
                    cell.circularProgress.step = 0.1f;
                    cell.circularProgress.startAngle = (M_PI * 3) * 0.5;
                    cell.circularProgress.translatesAutoresizingMaskIntoConstraints = NO;
                    cell.circularProgress.outlineWidth = 1;
                    cell.circularProgress.outlineTintColor = [UIColor whiteColor];
                    cell.circularProgress.endPoint = [[HKCircularProgressEndPointSpike alloc] init];
                    
                    
                    [[HKCircularProgressView appearance] setAnimationDuration:5];
                    
                    cell.circularProgress.alwaysDrawOutline = YES;
                    
                    
                    cell.insideProgress.fillRadius = 1;
                    cell.insideProgress.progressTintColor = [UIColor lightGrayColor];
                    cell.insideProgress.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.circularProgress setCurrent:testVa
                                             animated:YES];
                    [cell.insideProgress setCurrent:1.0f
                                           animated:YES];
                    
                    
                }
                NSString*uVoted = [NSString stringWithFormat:@"You have voted for \"%@\"",cell.leftButton.currentTitle];
                
                cell.youHaveVotedLabel.text =uVoted;
                
                
                NSInteger newVall = [cell.totalVotesLabel.text integerValue] + 1;
                cell.totalVotesLabel.text = [NSString stringWithFormat:@"%ld HeyVotes",(long)newVall];
                
                
                
                if ([[[globalArray valueForKey:@"PostTypeId"] objectAtIndex:indexPath.section] integerValue] == 2) {
                    
                    
                    BOOL interNetCheck=[WebServiceUrl InternetCheck];
                    if (interNetCheck==YES ) {
                        
                        
                        
                        
                        
                        NSString*uVoted = [NSString stringWithFormat:@"%@",cell.leftButton.currentTitle];
                        
                        NSString * commentAttrText = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"basicInformation"] allObjects] valueForKey:@"UserName"] objectAtIndex:0] ;
                        
                        NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,uVoted];
                        
                        CGFloat boldTextFontSize = 12.0f;
                        
                        //  cell.commentAttributedLabel.text = combinedText;
                        
                        NSRange range1 = [combinedText rangeOfString:commentAttrText];
                        NSRange range2 = [combinedText rangeOfString:uVoted];
                        
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                        
                        
                        
                        
                        
                        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                        
                        
                        
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                                range:range1];
                        
                        
                        
                        if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 0){
                            [self showToast:@"Please wait.."];
                            
                        }
                        
                        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 1)
                        {
                            cell.commentAttributedLabel.attributedText = attributedText;
                            
                        }
                        
                        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 2){
                            
                            cell.commentAttributedLabelTwo.attributedText = attributedText;
                        }
                        
                        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 3) {
                            
                            cell.commentAttributedLabelThree.attributedText = attributedText;
                            
                        }
                        
                        
                        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] > 3) {
                            
                            cell.commentAttributedLabelThree.attributedText = attributedText;
                        }
                        
                        
                        
                        NSDictionary *jsonDictionary =@{
                                                        
                                                        @"isWeb":@"false",
                                                        @"postId":[NSNumber numberWithInteger:[[[globalArray objectAtIndex:indexPath.section] valueForKey:@"Id"] integerValue]],
                                                        @"info":@{
                                                                
                                                                @"Comment":uVoted
                                                                }
                                                        
                                                        };
                        
                        
                        
                        
                        NSError *error;
                        
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                            
                                                                           options:0
                                            
                                                                             error:&error];
                        
                        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                        
                        NSLog(@"JSON OUTPUT: %@",JSONString);
                        
                        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/addcomment"]];
                        
                        
                        
                        [requestPost setHTTPMethod:@"POST"];
                        
                        
                        
                        [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                        
                        
                        
                        NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                        
                        
                        
                        [requestPost setHTTPBody: requestData];
                        
                        
                        [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                        
                        
                        
                        [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                            if (error) {
                                //do something with error
                            } else {
                                
                                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if (dic==nil) {
                                        
                                        
                                        //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                        //                                    [newView removeFromSuperview];
                                        
                                        
                                    }
                                    else{
                                        
                                        
                                        NSLog(@"hjfshjfhs%@",dic);
                                        
                                        
                                        //  [self callWebServiceRefresh:0];
                                        
                                        
                                        
                                        
                                        //
                                        //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                        //                                    [newView removeFromSuperview];
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                });
                            }
                        }];
                    }
                    
                    else{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                        message:@""
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
                
                BOOL interNetCheck=[WebServiceUrl InternetCheck];
                if (interNetCheck==YES ) {
                    
                    
                    
                    
                    
                    //
                    //                    UIView *newView = [[UIView alloc]init];
                    //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                    //                    [self.view addSubview:newView];
                    //
                    //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
                    //
                    
                    
                    
                    NSDictionary *jsonDictionary =@{
                                                    
                                                    @"isWeb":@"false",
                                                    @"voteOption":@"false",
                                                    @"postId":[NSNumber numberWithInteger:IDval]
                                                    
                                                    };
                    
                    
                    
                    
                    
                    
                    NSError *error;
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                        
                                                                       options:0
                                        
                                                                         error:&error];
                    
                    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"JSON OUTPUT: %@",JSONString);
                    
                    NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/vote"]];
                    
                    
                    
                    [requestPost setHTTPMethod:@"POST"];
                    
                    
                    
                    [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                    
                    
                    
                    NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                    
                    
                    
                    [requestPost setHTTPBody: requestData];
                    
                    
                    [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                    
                    
                    
                    [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        if (error) {
                            //do something with error
                        } else {
                            
                            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (dic==nil) {
                                    
                                    
                                    //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                    //                                    [newView removeFromSuperview];
                                    
                                    
                                }
                                else{
                                    
                                    
                                    NSLog(@"hjfshjfhs%@",dic);
                                    
                                    
                                    [self callWebServiceRefresh:0];
                                    voteResultVal = @"leftvoted";
                                    
                                    
                                    //
                                    //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                    //                                    [newView removeFromSuperview];
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                            });
                        }
                    }];
                }
                
                else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                    message:@""
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    
                }
                
                
            }
            
            //   [cell.yesNoMainView setHidden:YES];
            
            
            
            
        }
        
        
    }
    
}

- (IBAction)rightButton:(id)sender {
    
    //  timerLoad = @"invalid";
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        [voteResultAraay addObject:[globalArray objectAtIndex:indexPath.section]];
        
        NSInteger IDval = [[[globalArray valueForKey:@"Id"] objectAtIndex:indexPath.section] integerValue];
        
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:indexPath.section] integerValue]  == 0) {
            
            
            
            
            if ( [[[globalArray objectAtIndex:indexPath.section] valueForKey:@"hasVoted"] integerValue ]==0) {
                
                
                
                
                cell.leftButton.userInteractionEnabled = NO;
                cell.rightButton.userInteractionEnabled = NO;
                
                
                
                [cell.leftButton setBackgroundColor:[UIColor whiteColor]];
                [cell.rightButton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f
                                                                     green:200.0f/255.0f
                                                                      blue:200.0f/255.0f
                                                                     alpha:1.0f]];
                
                if ([[[globalArray valueForKey:@"PostType"] objectAtIndex:indexPath.section] integerValue] == 1) {
                    [cell.progresssView setHidden:NO];
                    
                    cell.circularProgress.progressTintColor = [UIColor colorWithRed:202.0f/255.0f
                                                                              green:0.0f/255.0f
                                                                               blue:20.0f/255.0f
                                                                              alpha:0.7f];
                    cell.circularProgress.max = 1.0f;
                    cell.circularProgress.fillRadiusPx = 25;
                    cell.circularProgress.step = 0.1f;
                    cell.circularProgress.startAngle = (M_PI * 3) * 0.5;
                    cell.circularProgress.translatesAutoresizingMaskIntoConstraints = NO;
                    cell.circularProgress.outlineWidth = 1;
                    cell.circularProgress.outlineTintColor = [UIColor whiteColor];
                    cell.circularProgress.endPoint = [[HKCircularProgressEndPointSpike alloc] init];
                    
                    
                    [[HKCircularProgressView appearance] setAnimationDuration:5];
                    
                    cell.circularProgress.alwaysDrawOutline = YES;
                    
                    
                    cell.insideProgress.fillRadius = 1;
                    cell.insideProgress.progressTintColor = [UIColor lightGrayColor];
                    cell.insideProgress.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.circularProgress setCurrent:testVa
                                             animated:YES];
                    [cell.insideProgress setCurrent:1.0f
                                           animated:YES];
                    
                }
                
                NSString*uVoted = [NSString stringWithFormat:@"You have voted for \"%@\"",cell.rightButton.currentTitle];
                
                cell.youHaveVotedLabel.text =uVoted;
                
                
                NSInteger newVall = [cell.totalVotesLabel.text integerValue] + 1;
                cell.totalVotesLabel.text = [NSString stringWithFormat:@"%ld HeyVotes",(long)newVall];
                
                
                
                if ([[[globalArray valueForKey:@"PostTypeId"] objectAtIndex:indexPath.section] integerValue] == 2) {
                    
                    
                    BOOL interNetCheck=[WebServiceUrl InternetCheck];
                    if (interNetCheck==YES ) {
                        
                        
                        
                        
                        
                        NSString*uVoted = [NSString stringWithFormat:@"%@",cell.rightButton.currentTitle];
                        
                        NSString * commentAttrText = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"basicInformation"] allObjects] valueForKey:@"UserName"] objectAtIndex:0] ;
                        
                        NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,uVoted];
                        
                        CGFloat boldTextFontSize = 12.0f;
                        
                        //  cell.commentAttributedLabel.text = combinedText;
                        
                        NSRange range1 = [combinedText rangeOfString:commentAttrText];
                        NSRange range2 = [combinedText rangeOfString:uVoted];
                        
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                        
                        
                        
                        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                        
                        
                        
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                                range:range1];
                        
                        
                        
                        if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 0){
                            [self showToast:@"Please wait.."];
                            
                        }
                        
                        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 1)
                        {
                            cell.commentAttributedLabel.attributedText = attributedText;
                            
                        }
                        
                        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 2){
                            
                            cell.commentAttributedLabelTwo.attributedText = attributedText;
                        }
                        
                        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 3) {
                            
                            cell.commentAttributedLabelThree.attributedText = attributedText;
                            
                        }
                        
                        
                        else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] > 3) {
                            
                            cell.commentAttributedLabelThree.attributedText = attributedText;
                        }
                        
                        
                        
                        NSDictionary *jsonDictionary =@{
                                                        
                                                        @"isWeb":@"false",
                                                        @"postId":[NSNumber numberWithInteger:[[[globalArray objectAtIndex:indexPath.section] valueForKey:@"Id"] integerValue]],
                                                        @"info":@{
                                                                
                                                                @"Comment":uVoted
                                                                }
                                                        
                                                        };
                        
                        
                        
                        
                        NSError *error;
                        
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                            
                                                                           options:0
                                            
                                                                             error:&error];
                        
                        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                        
                        NSLog(@"JSON OUTPUT: %@",JSONString);
                        
                        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/addcomment"]];
                        
                        
                        
                        [requestPost setHTTPMethod:@"POST"];
                        
                        
                        
                        [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                        
                        
                        
                        NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                        
                        
                        
                        [requestPost setHTTPBody: requestData];
                        
                        
                        [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                        
                        
                        
                        [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                            if (error) {
                                //do something with error
                            } else {
                                
                                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if (dic==nil) {
                                        
                                        
                                        //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                        //                                    [newView removeFromSuperview];
                                        
                                        
                                    }
                                    else{
                                        
                                        
                                        NSLog(@"hjfshjfhs%@",dic);
                                        
                                        
                                        // [self callWebServiceRefresh:0];
                                        
                                        
                                        
                                        
                                        //
                                        //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                        //                                    [newView removeFromSuperview];
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                });
                            }
                        }];
                    }
                    
                    else{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                        message:@""
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                BOOL interNetCheck=[WebServiceUrl InternetCheck];
                if (interNetCheck==YES ) {
                    
                    
                    
                    
                    
                    //
                    //                    UIView *newView = [[UIView alloc]init];
                    //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                    //                    [self.view addSubview:newView];
                    //
                    //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
                    //
                    
                    
                    
                    NSDictionary *jsonDictionary =@{
                                                    
                                                    @"isWeb":@"false",
                                                    @"voteOption":@"true",
                                                    @"postId":[NSNumber numberWithInteger:IDval]
                                                    
                                                    };
                    
                    
                    
                    
                    
                    
                    NSError *error;
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                        
                                                                       options:0
                                        
                                                                         error:&error];
                    
                    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"JSON OUTPUT: %@",JSONString);
                    
                    NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/vote"]];
                    
                    
                    
                    [requestPost setHTTPMethod:@"POST"];
                    
                    
                    
                    [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                    
                    
                    
                    NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                    
                    
                    
                    [requestPost setHTTPBody: requestData];
                    
                    
                    [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                    
                    
                    
                    [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        if (error) {
                            //do something with error
                        } else {
                            
                            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (dic==nil) {
                                    
                                    
                                    //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                    //                                    [newView removeFromSuperview];
                                    
                                    
                                }
                                else{
                                    
                                    
                                    NSLog(@"hjfshjfhs%@",dic);
                                    
                                    
                                    //
                                    //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                    //                                    [newView removeFromSuperview];
                                    
                                    [self callWebServiceRefresh:0];
                                    voteResultVal = @"rightvoted";
                                    
                                }
                                
                                
                                
                                
                            });
                        }
                    }];
                }
                
                else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                    message:@""
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    
                }
                
                
            }
            
            //  [cell.yesNoMainView setHidden:YES];
            
            
        }
        
        
    }
    
}

- (IBAction)showMoreComments:(id)sender {
    
    commentViewVal = @"val";
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        NSInteger IDval = [[[globalArray valueForKey:@"Id"] objectAtIndex:indexPath.section] integerValue];
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        
        
        BOOL interNetCheck=[WebServiceUrl InternetCheck];
        if (interNetCheck==YES ) {
            //
            UIView *newView = [[UIView alloc]init];
            newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:newView];
            
            [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
            
            
            
            
            NSDictionary *jsonDictionary =@{
                                            
                                            @"isWeb":@"false",
                                            @"postId":[NSNumber numberWithInteger:IDval],
                                            @"pageId":[NSNumber numberWithInteger:0],
                                            @"pageSize":@"5"
                                            
                                            };
            
            
            
            
            
            
            NSError *error;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                
                                                               options:0
                                
                                                                 error:&error];
            
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON OUTPUT: %@",JSONString);
            
            NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/getComments"]];
            
            
            
            [requestPost setHTTPMethod:@"POST"];
            
            
            
            [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
            
            
            
            NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            [requestPost setHTTPBody: requestData];
            
            
            [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
            
            
            
            [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (error) {
                    //do something with error
                } else {
                    
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (dic==nil) {
                            
                            
                            [GMDCircleLoader hideFromView:newView animated:YES];
                            [newView removeFromSuperview];
                            
                            
                        }
                        else{
                            
                            
                            NSLog(@"hjfshjfhs%@",dic);
                            
                            
                            NSMutableArray* arrayVal = [[NSMutableArray alloc]init];
                            
                            [arrayVal addObjectsFromArray:[dic valueForKey:@"GetCommentsResult"]];
                            
                            
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            CommentVC *myVC = (CommentVC *)[storyboard instantiateViewControllerWithIdentifier:@"CommentVC"];
                            
                            myVC.arrayVal = arrayVal;
                            
                            [self presentViewController:myVC animated:YES completion:nil];
                            
                            
                            
                            
                            
                            
                            
                            
                            [GMDCircleLoader hideFromView:newView animated:YES];
                            [newView removeFromSuperview];
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                    });
                }
            }];
        }
        
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        
        
        
        
        
    }
    
}

-(void)showToast:(NSString*)msg{
    
    [self.view makeToast:msg
                duration:1.0
                position:CSToastPositionCenter];
}


- (IBAction)reHeyVote:(id)sender {
    
    NSLog(@"reheyvote Clicked");
    
    
    
    NSString*stringVal = @"Re-HeyVote in progress...";
    [self showToast:stringVal];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        NSInteger IDval = [[[globalArray valueForKey:@"Id"] objectAtIndex:indexPath.section] integerValue];
        
        
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        
        
        
        BOOL interNetCheck=[WebServiceUrl InternetCheck];
        if (interNetCheck==YES ) {
            //
            //                    UIView *newView = [[UIView alloc]init];
            //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            //                    [self.view addSubview:newView];
            //
            //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
            //
            
            
            
            NSDictionary *jsonDictionary =@{
                                            
                                            @"isWeb":@"false",
                                            @"postId":[NSNumber numberWithInteger:IDval]
                                            
                                            };
            
            
            
            
            
            
            NSError *error;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                
                                                               options:0
                                
                                                                 error:&error];
            
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON OUTPUT: %@",JSONString);
            
            NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/ReHeyVote"]];
            
            
            
            [requestPost setHTTPMethod:@"POST"];
            
            
            
            [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
            
            
            
            NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            [requestPost setHTTPBody: requestData];
            
            
            [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
            
            
            
            [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (error) {
                    //do something with error
                } else {
                    
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (dic==nil) {
                            
                            
                            //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                            //                                    [newView removeFromSuperview];
                            
                            
                        }
                        else{
                            
                            
                            NSLog(@"hjfshjfhs%@",dic);
                            
                            NSString*stringValll = @"Re-HeyVoted successfully";
                            [self showToast:stringValll];
                            
                            
                            //
                            //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                            //                                    [newView removeFromSuperview];
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                    });
                }
            }];
        }
        
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            
        }
        
        
        
        
        
        
    }
    
}

- (IBAction)shareButton:(id)sender {
    
    timerLoad = @"invalid";
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        
        NSString*stringURl = [NSString stringWithFormat:@"https://www.heyvote.com/?share=%@",[[globalArray objectAtIndex:indexPath.section]valueForKey:@"PostToken"]];
        
        
        NSURL * strUrl = [NSURL URLWithString:stringURl];
        
        
        //   UIImage *imagetoshare = _img; //this is your image to share
        NSArray *activityItems = @[strUrl];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
        [self presentViewController:activityVC animated:TRUE completion:nil];
        
        
        
        
        
    }
    
}

- (IBAction)moreButton:(id)sender {
    timerLoad = @"invalid";
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        
        if ([[[globalArray valueForKey:@"CanDelete"] objectAtIndex:indexPath.section] integerValue] == 1) {
            
            
            
            if ([cell.deleteView isHidden]) {
                [cell.deleteView setHidden:NO];
                
                cell.deleteView.layer.shadowColor = [UIColor blackColor].CGColor;
                cell.deleteView.layer.shadowOffset = CGSizeMake(5, 5);
                cell.deleteView.layer.shadowOpacity = 0.5;
                cell.deleteView.layer.shadowRadius = 1.0;
                cell.deleteView.layer.cornerRadius = 5.0;
                
                cell.deleteView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     cell.deleteView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                 } completion:^(BOOL finished) {
                                     
                                 }];
                
                
                
                
            }
            
            else{
                
                [cell.deleteView setHidden:YES];
                
                
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     cell.deleteView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                                 } completion:^(BOOL finished) {
                                     cell.deleteView.hidden = TRUE;
                                 }];
            }
            
            
            
            
            
        }
        
        else{
            
            
            if ([cell.moreButtonView isHidden]) {
                [cell.moreButtonView setHidden:NO];
                
                
                
                if ([[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"basicInformation"] allObjects] valueForKey:@"isSpecial"] objectAtIndex:0] integerValue] == 1) {
                    [cell.spamView setHidden:NO];
                    
                    
                    
                    cell.spamView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         cell.spamView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                     } completion:^(BOOL finished) {
                                         
                                     }];
                    
                }
                
                else{
                    [cell.spamView setHidden:YES];
                    
                }
                
                
                
                cell.moreButtonView.layer.shadowColor = [UIColor blackColor].CGColor;
                cell.moreButtonView.layer.shadowOffset = CGSizeMake(5, 5);
                cell.moreButtonView.layer.shadowOpacity = 0.5;
                cell.moreButtonView.layer.shadowRadius = 1.0;
                cell.moreButtonView.layer.cornerRadius = 5.0;
                
                cell.moreButtonView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     cell.moreButtonView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                 } completion:^(BOOL finished) {
                                     
                                 }];
                
                
                
                
            }
            
            else{
                
                [cell.moreButtonView setHidden:YES];
                [cell.spamView setHidden:YES];
                
                
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     cell.moreButtonView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                                 } completion:^(BOOL finished) {
                                     cell.moreButtonView.hidden = TRUE;
                                 }];
            }
            
            
            
            
        }
        
        
        
        
    }
    
}

- (IBAction)moreFollow:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        
        
        NSString * moreFollowString = [NSString stringWithFormat:@"Follow %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
        
        
        
        if ([cell.moreFollow.currentTitle isEqualToString:moreFollowString]) {
            followUnfolloww = @"unfollow";
            
            NSString * moreFollowStringg = [NSString stringWithFormat:@"Unfollow %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
            [cell.moreFollow setTitle:moreFollowStringg forState: UIControlStateNormal];
            
            
            BOOL interNetCheck=[WebServiceUrl InternetCheck];
            if (interNetCheck==YES ) {
                //
                //                    UIView *newView = [[UIView alloc]init];
                //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                //                    [self.view addSubview:newView];
                //
                //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
                //
                
                
                
                NSDictionary *jsonDictionary =@{
                                                
                                                @"isWeb":@"false",
                                                @"follow":@"true",
                                                @"contactToken":[[globalArray valueForKey:@"Token"] objectAtIndex:indexPath.section]
                                                
                                                };
                
                
                
                
                
                
                NSError *error;
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                    
                                                                   options:0
                                    
                                                                     error:&error];
                
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"JSON OUTPUT: %@",JSONString);
                
                NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/followunfollowuser"]];
                
                
                
                [requestPost setHTTPMethod:@"POST"];
                
                
                
                [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                
                
                
                NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                
                
                
                [requestPost setHTTPBody: requestData];
                
                
                [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                
                
                
                [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (error) {
                        //do something with error
                    } else {
                        
                        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (dic==nil) {
                                
                                
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                            }
                            else{
                                
                                
                                NSLog(@"hjfshjfhs%@",dic);
                                
                                
                                
                                
                                //
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                        });
                    }
                }];
            }
            
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [cell.moreFollow setTitle:moreFollowString forState: UIControlStateNormal];
                
                
            }
            
            
            
        }
        
        else{
            
            followUnfolloww = @"follow";
            
            NSString * moreFollowStringg = [NSString stringWithFormat:@"Follow %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
            [cell.moreFollow setTitle:moreFollowStringg forState: UIControlStateNormal];
            
            
            
            
            {
                
                
                
                BOOL interNetCheck=[WebServiceUrl InternetCheck];
                if (interNetCheck==YES ) {
                    //
                    //                    UIView *newView = [[UIView alloc]init];
                    //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                    //                    [self.view addSubview:newView];
                    //
                    //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
                    //
                    
                    
                    
                    NSDictionary *jsonDictionary =@{
                                                    
                                                    @"isWeb":@"false",
                                                    @"follow":@"false",
                                                    @"contactToken":[[globalArray valueForKey:@"Token"] objectAtIndex:indexPath.section]
                                                    
                                                    };
                    
                    
                    
                    
                    
                    
                    NSError *error;
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                        
                                                                       options:0
                                        
                                                                         error:&error];
                    
                    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"JSON OUTPUT: %@",JSONString);
                    
                    NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/followunfollowuser"]];
                    
                    
                    
                    [requestPost setHTTPMethod:@"POST"];
                    
                    
                    
                    [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                    
                    
                    
                    NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                    
                    
                    
                    [requestPost setHTTPBody: requestData];
                    
                    
                    [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                    
                    
                    
                    [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        if (error) {
                            //do something with error
                        } else {
                            
                            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (dic==nil) {
                                    
                                    
                                    //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                    //                                    [newView removeFromSuperview];
                                    
                                    
                                }
                                else{
                                    
                                    
                                    NSLog(@"hjfshjfhs%@",dic);
                                    
                                    
                                    
                                    
                                    //
                                    //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                    //                                    [newView removeFromSuperview];
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                            });
                        }
                    }];
                }
                
                else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                    message:@""
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    NSString * moreFollowStringg = [NSString stringWithFormat:@"Unfollow %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
                    [cell.moreFollow setTitle:moreFollowStringg forState: UIControlStateNormal];
                }
                
                
                
            }
            
            
        }
        
        
        
    }
}

- (IBAction)moreBlock:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        
        
        NSString * moreFollowString = [NSString stringWithFormat:@"Block %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
        
        
        if ([cell.moreBlock.currentTitle isEqualToString:moreFollowString]) {
            
            
            blockUnblockk = @"unblock";
            
            
            NSString * moreFollowStringg = [NSString stringWithFormat:@"Unblock %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
            [cell.moreBlock setTitle:moreFollowStringg forState: UIControlStateNormal];
            
            
            
            BOOL interNetCheck=[WebServiceUrl InternetCheck];
            if (interNetCheck==YES ) {
                //
                //                    UIView *newView = [[UIView alloc]init];
                //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                //                    [self.view addSubview:newView];
                //
                //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
                //
                
                
                
                NSDictionary *jsonDictionary =@{
                                                
                                                @"isWeb":@"false",
                                                @"allowed":[NSNumber numberWithInteger:0],
                                                @"contactToken":[[globalArray valueForKey:@"Token"] objectAtIndex:indexPath.section]
                                                
                                                };
                
                
                
                
                
                
                NSError *error;
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                    
                                                                   options:0
                                    
                                                                     error:&error];
                
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"JSON OUTPUT: %@",JSONString);
                
                NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/blockunblockuser"]];
                
                
                
                [requestPost setHTTPMethod:@"POST"];
                
                
                
                [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                
                
                
                NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                
                
                
                [requestPost setHTTPBody: requestData];
                
                
                [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                
                
                
                [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (error) {
                        //do something with error
                    } else {
                        
                        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (dic==nil) {
                                
                                
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                            }
                            else{
                                
                                
                                NSLog(@"hjfshjfhs%@",dic);
                                
                                
                                
                                
                                //
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                        });
                    }
                }];
            }
            
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                NSString * moreFollowStringg = [NSString stringWithFormat:@"Block %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
                [cell.moreBlock setTitle:moreFollowStringg forState: UIControlStateNormal];
                
            }
            
            
            
            
            
        }
        
        else{
            
            
            blockUnblockk = @"block";
            
            NSString * moreFollowStringg = [NSString stringWithFormat:@"Block %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
            [cell.moreBlock setTitle:moreFollowStringg forState: UIControlStateNormal];
            
            
            BOOL interNetCheck=[WebServiceUrl InternetCheck];
            if (interNetCheck==YES ) {
                //
                //                    UIView *newView = [[UIView alloc]init];
                //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                //                    [self.view addSubview:newView];
                //
                //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
                //
                
                
                
                NSDictionary *jsonDictionary =@{
                                                
                                                @"isWeb":@"false",
                                                @"allowed":[NSNumber numberWithInteger:1],
                                                @"contactToken":[[globalArray valueForKey:@"Token"] objectAtIndex:indexPath.section]
                                                
                                                };
                
                
                
                
                
                
                NSError *error;
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                    
                                                                   options:0
                                    
                                                                     error:&error];
                
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"JSON OUTPUT: %@",JSONString);
                
                NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/blockunblockuser"]];
                
                
                
                [requestPost setHTTPMethod:@"POST"];
                
                
                
                [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                
                
                
                NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                
                
                
                [requestPost setHTTPBody: requestData];
                
                
                [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                
                
                
                [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (error) {
                        //do something with error
                    } else {
                        
                        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (dic==nil) {
                                
                                
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                            }
                            else{
                                
                                
                                NSLog(@"hjfshjfhs%@",dic);
                                
                                
                                
                                //
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                        });
                    }
                }];
            }
            
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                NSString * moreFollowStringg = [NSString stringWithFormat:@"Unblock %@",[[globalArray valueForKey:@"UserDisplayName"] objectAtIndex:indexPath.section]];
                [cell.moreBlock setTitle:moreFollowStringg forState: UIControlStateNormal];
                
            }
            
        }
        
        
        
    }
}

- (IBAction)moreReport:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        
        
        BOOL interNetCheck=[WebServiceUrl InternetCheck];
        if (interNetCheck==YES ) {
            //
            //                    UIView *newView = [[UIView alloc]init];
            //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            //                    [self.view addSubview:newView];
            //
            //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
            //
            
            
            
            NSDictionary *jsonDictionary =@{
                                            
                                            @"isWeb":@"false",
                                            @"postId":[NSNumber numberWithInteger:[[[globalArray objectAtIndex:indexPath.section] valueForKey:@"Id"] integerValue]]
                                            
                                            };
            
            
            
            
            
            
            NSError *error;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                
                                                               options:0
                                
                                                                 error:&error];
            
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON OUTPUT: %@",JSONString);
            
            NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/SpamPost"]];
            
            
            
            [requestPost setHTTPMethod:@"POST"];
            
            
            
            [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
            
            
            
            NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            [requestPost setHTTPBody: requestData];
            
            
            [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
            
            
            
            [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (error) {
                    //do something with error
                } else {
                    
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (dic==nil) {
                            
                            
                            //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                            //                                    [newView removeFromSuperview];
                            
                            
                        }
                        else{
                            
                            
                            [self showToast:@"Reported Successfully"];
                            
                            NSLog(@"hjfshjfhs%@",dic);
                            
                            
                            
                            
                            //
                            //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                            //                                    [newView removeFromSuperview];
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                    });
                }
            }];
        }
        
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        
        
        
        
        
        
        
    }
}


- (IBAction)commentSendButton:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        
        if ([cell.commentTextField.text length] == 0) {
            
        }
        
        else{
            
            
            BOOL interNetCheck=[WebServiceUrl InternetCheck];
            if (interNetCheck==YES ) {
                
                
                
                NSString * commetAttrTextTwo = cell.commentTextField.text;
                
                
                
                NSString * commentAttrText = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"basicInformation"] allObjects] valueForKey:@"UserName"] objectAtIndex:0] ;
                
                NSString * combinedText = [NSString stringWithFormat:@"%@ %@",commentAttrText,commetAttrTextTwo];
                
                CGFloat boldTextFontSize = 12.0f;
                
                //  cell.commentAttributedLabel.text = combinedText;
                
                NSRange range1 = [combinedText rangeOfString:commentAttrText];
                NSRange range2 = [combinedText rangeOfString:commetAttrTextTwo];
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedText];
                
                
                
                
                
                [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
                
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                
                
                if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 0){
                    [self showToast:@"Posting your comment.."];
                    
                }
                
                else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 1)
                {
                    cell.commentAttributedLabel.attributedText = attributedText;
                    
                }
                
                else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 2){
                    
                    cell.commentAttributedLabelTwo.attributedText = attributedText;
                }
                
                else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] == 3) {
                    
                    cell.commentAttributedLabelThree.attributedText = attributedText;
                    
                }
                
                
                else if ([[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] count] > 3) {
                    
                    cell.commentAttributedLabelThree.attributedText = attributedText;
                }
                
                
                
                NSDictionary *jsonDictionary =@{
                                                
                                                @"isWeb":@"false",
                                                @"postId":[NSNumber numberWithInteger:[[[globalArray objectAtIndex:indexPath.section] valueForKey:@"Id"] integerValue]],
                                                @"info":@{
                                                        
                                                        @"Comment":cell.commentTextField.text
                                                        }
                                                
                                                };
                
                
                cell.commentTextField.text = @"";
                
                NSError *error;
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                    
                                                                   options:0
                                    
                                                                     error:&error];
                
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"JSON OUTPUT: %@",JSONString);
                
                NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/addcomment"]];
                
                
                
                [requestPost setHTTPMethod:@"POST"];
                
                
                
                [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                
                
                
                NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                
                
                
                [requestPost setHTTPBody: requestData];
                
                
                [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                
                
                
                [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (error) {
                        //do something with error
                    } else {
                        
                        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (dic==nil) {
                                
                                
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                            }
                            else{
                                
                                
                                NSLog(@"hjfshjfhs%@",dic);
                                
                                
                                [self callWebServiceRefresh:0];
                                
                                
                                
                                
                                //
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                                
                            }
                            
                            
                            
                        });
                    }
                }];
            }
            
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
            }
            
            
            
            
        }
        
        
    }
    
}



- (IBAction)buttonOverImage:(id)sender {
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        if ([[[globalArray valueForKey:@"PostType"] objectAtIndex:indexPath.section] integerValue] == 2) {
            
        }
        
        else{
            
            [_myTableView setUserInteractionEnabled:NO];
            _zoomImageView.image = cell.proImageView.image;
            [_zoomView setHidden:NO];
            
        }
    }
}

- (IBAction)doubleVoicePlayLeftButton:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath != nil)
    {
        NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/api/media/playaudio/%@/%@",[[globalArray valueForKey:@"Image1Idf"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"PostFolderPath"] objectAtIndex:indexPath.section]];
        
    }
}

- (IBAction)doubleVoicePlayRightButton:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath != nil)
    {
        NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/api/media/playaudio/%@/%@",[[globalArray valueForKey:@"Image2Idf"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"PostFolderPath"] objectAtIndex:indexPath.section]];
        
    }
    
}

- (IBAction)singleVoicePlayButton:(id)sender {
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        
        
        NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/api/media/playaudio/%@/%@",[[globalArray valueForKey:@"Image1Idf"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"PostFolderPath"] objectAtIndex:indexPath.section]];
        
        //         NSString *urlstr = @"http://jesusredeems.in/media/Media Advt/mp3_player/Songs/viduthalaiyin geethangal_vol1/93.Ellame Koodum.mp3";
        
        //     urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:imageString];
        
        //
        //        NSData *data = [NSData dataWithContentsOfURL:url];
        //        _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        //
        //      [_audioPlayer self];
        //
        //        [_audioPlayer play];
        //
        
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:[NSURL fileURLWithPath:imageString]
                        error:&error];
        if (error)
        {
            NSLog(@"Error in _audioPlayer: %@",
                  [error localizedDescription]);
        } else {
            _audioPlayer.delegate = self;
            [_audioPlayer play];
        }
        
        
        
        
        //
        //
        //        NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/api/media/play/%@/%@",[[globalArray valueForKey:@"Image1Idf"] objectAtIndex:indexPath.section],[[globalArray valueForKey:@"PostFolderPath"] objectAtIndex:indexPath.section]];
        //
        //        MPMoviePlayerController *controller = [[MPMoviePlayerController alloc]
        //                                               initWithContentURL:[NSURL URLWithString:imageString]];
        //
        //        self.mc = controller; //Super important
        //        [controller prepareToPlay];
        //        controller.repeatMode = YES;
        //        [controller setControlStyle:MPMovieControlStyleNone];
        //        controller.view.userInteractionEnabled =YES;
        //        controller.scalingMode = MPMovieScalingModeAspectFill;
        //        [cell.videoPreview addSubview:controller.view]; //Show the view
        //        controller.view.frame = cell.videoPreview.bounds; //Set the size
        //
        //        [controller play]; //Start playing
        //
        //
        //
        
        
        
        
        
        
        //
        //        [cell.mySpinner startAnimating];
        //
        //
        //
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            //Do background work
        //
        //          NSData *data = [NSData dataFromBase64String:imageString];
        //
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                //Update UI
        //                 NSError *error;
        //                audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
        //                [audioPlayer prepareToPlay];
        //                [audioPlayer play];
        //                [cell.mySpinner stopAnimating];
        //
        //
        //            });
        //        });
        //
        //
        
        
        
        
    }
}


-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%@",error);
}

- (IBAction)deleteButton:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (indexPath != nil)
    {
        
        
        
        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
        
        
        BOOL interNetCheck=[WebServiceUrl InternetCheck];
        if (interNetCheck==YES ) {
            
            [self showToast:@"Deletion in progress.."];
            
            //
            //                    UIView *newView = [[UIView alloc]init];
            //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            //                    [self.view addSubview:newView];
            //
            //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
            //
            
            
            
            NSDictionary *jsonDictionary =@{
                                            
                                            @"isWeb":@"false",
                                            @"postId":[NSNumber numberWithInteger:[[[globalArray objectAtIndex:indexPath.section] valueForKey:@"Id"] integerValue]]
                                            
                                            };
            
            
            
            
            
            
            NSError *error;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                
                                                               options:0
                                
                                                                 error:&error];
            
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON OUTPUT: %@",JSONString);
            
            NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/deletepost"]];
            
            
            
            [requestPost setHTTPMethod:@"POST"];
            
            
            
            [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
            
            
            
            NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            [requestPost setHTTPBody: requestData];
            
            
            [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
            
            
            
            [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (error) {
                    //do something with error
                } else {
                    
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (dic==nil) {
                            
                            
                            //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                            //                                    [newView removeFromSuperview];
                            
                            
                        }
                        else{
                            
                            
                            
                            [globalArray removeObjectAtIndex:indexPath.section];
                            
                            [_myTableView reloadData];
                            
                            
                            [self showToast:@"Deleted Successfully"];
                            
                            NSLog(@"hjfshjfhs%@",dic);
                            
                            
                            
                            
                            //
                            //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                            //                                    [newView removeFromSuperview];
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                    });
                }
            }];
        }
        
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
}

- (IBAction)firstCommentButton:(id)sender {
    //
    //
    //    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    //    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    //    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    //    if (indexPath != nil)
    //    {
    //
    //        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
    //
    //        BOOL interNetCheck=[WebServiceUrl InternetCheck];
    //        if (interNetCheck==YES ) {
    //
    //            UIView *newView = [[UIView alloc]init];
    //            newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //            [self.view addSubview:newView];
    //
    //            [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
    //
    //
    //
    //
    //            NSDictionary *jsonDictionary =@{
    //                                            @"contactToken":[[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Id"] objectAtIndex:0],
    //                                            @"isWeb":@"false"                                           };
    //
    //
    //
    //
    //
    //
    //            NSError *error;
    //
    //            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
    //
    //                                                               options:0
    //
    //                                                                 error:&error];
    //
    //            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    //
    //            NSLog(@"JSON OUTPUT: %@",JSONString);
    //
    //            NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/viewprofileExternal"]];
    //
    //
    //
    //            [requestPost setHTTPMethod:@"POST"];
    //
    //
    //
    //            [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
    //
    //
    //
    //            NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    //
    //
    //
    //            [requestPost setHTTPBody: requestData];
    //
    //            //  [requestPost addValue:@"hhhffftttuuu" forHTTPHeaderField:@"Value"];
    //
    //
    //
    //            [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
    //
    //            // NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:requestPost delegate:self];
    //
    //            [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    //                if (error) {
    //                    //do something with error
    //                } else {
    //
    //                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //                    //            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
    //                    //            NSString *newLineStr = @"\n";
    //                    //            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
    //                    //
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                        if (dic==nil) {
    //
    //
    //                            [GMDCircleLoader hideFromView:newView animated:YES];
    //                            [newView removeFromSuperview];
    //
    //
    //                        }
    //                        else{
    //
    //
    //                            NSLog(@"hjfshjfhs%@",dic);
    //
    //
    //
    //
    //                            NSMutableArray*arrayVal = [[NSMutableArray alloc]init];
    //
    //                            [arrayVal addObject:[dic valueForKey:@"ViewProfileExternalResult"]];
    //
    //                            [GMDCircleLoader hideFromView:newView animated:YES];
    //                            [newView removeFromSuperview];
    //
    //
    //
    //
    //                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //                            heyVoteProfileVC *myVC = (heyVoteProfileVC *)[storyboard instantiateViewControllerWithIdentifier:@"heyVoteProfileVC"];
    //                            myVC.profileArray = arrayVal;
    //                            myVC.contactToke = [[globalArray valueForKey:@"Token"] objectAtIndex:indexPath.section];
    //                            [self PushAnimation];
    //                            [self.navigationController pushViewController:myVC animated:NO];
    //
    //
    //                        }
    //
    //
    //
    //
    //                    });
    //                }
    //            }];
    //        }
    //
    //        else{
    //
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
    //                                                            message:@""
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"OK"
    //                                                  otherButtonTitles:nil];
    //            [alert show];
    //
    //
    //        }
    //
    //
    //    }
    //
    //
    //
    //
    //
    //
}

- (IBAction)secondCommentButton:(id)sender {
    //
    //
    //    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    //    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    //    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    //    if (indexPath != nil)
    //    {
    //
    //        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
    //
    //        BOOL interNetCheck=[WebServiceUrl InternetCheck];
    //        if (interNetCheck==YES ) {
    //
    //            UIView *newView = [[UIView alloc]init];
    //            newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //            [self.view addSubview:newView];
    //
    //            [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
    //
    //
    //
    //
    //            NSDictionary *jsonDictionary =@{
    //                                            @"contactToken":[[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"Id"] objectAtIndex:1],
    //                                            @"isWeb":@"false"                                           };
    //
    //
    //
    //
    //
    //
    //            NSError *error;
    //
    //            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
    //
    //                                                               options:0
    //
    //                                                                 error:&error];
    //
    //            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    //
    //            NSLog(@"JSON OUTPUT: %@",JSONString);
    //
    //            NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/viewprofileExternal"]];
    //
    //
    //
    //            [requestPost setHTTPMethod:@"POST"];
    //
    //
    //
    //            [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
    //
    //
    //
    //            NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    //
    //
    //
    //            [requestPost setHTTPBody: requestData];
    //
    //            //  [requestPost addValue:@"hhhffftttuuu" forHTTPHeaderField:@"Value"];
    //
    //
    //
    //            [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
    //
    //            // NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:requestPost delegate:self];
    //
    //            [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    //                if (error) {
    //                    //do something with error
    //                } else {
    //
    //                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //                    //            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
    //                    //            NSString *newLineStr = @"\n";
    //                    //            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
    //                    //
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                        if (dic==nil) {
    //
    //
    //                            [GMDCircleLoader hideFromView:newView animated:YES];
    //                            [newView removeFromSuperview];
    //
    //
    //                        }
    //                        else{
    //
    //
    //                            NSLog(@"hjfshjfhs%@",dic);
    //
    //
    //
    //
    //                            NSMutableArray*arrayVal = [[NSMutableArray alloc]init];
    //
    //                            [arrayVal addObject:[dic valueForKey:@"ViewProfileExternalResult"]];
    //
    //                            [GMDCircleLoader hideFromView:newView animated:YES];
    //                            [newView removeFromSuperview];
    //
    //
    //
    //
    //                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //                            heyVoteProfileVC *myVC = (heyVoteProfileVC *)[storyboard instantiateViewControllerWithIdentifier:@"heyVoteProfileVC"];
    //                            myVC.profileArray = arrayVal;
    //                            myVC.contactToke = [[globalArray valueForKey:@"Token"] objectAtIndex:indexPath.section];
    //                            [self PushAnimation];
    //                            [self.navigationController pushViewController:myVC animated:NO];
    //
    //
    //                        }
    //
    //
    //
    //
    //                    });
    //                }
    //            }];
    //        }
    //
    //        else{
    //
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
    //                                                            message:@""
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"OK"
    //                                                  otherButtonTitles:nil];
    //            [alert show];
    //
    //
    //        }
    //
    //
    //    }
    //
    //
    //
    //
    //
    //
}









- (IBAction)previewCloseButton:(id)sender {
    
    previewVal = @"";
    [_myTableView setUserInteractionEnabled:YES];
    
    [_myTableView reloadData];
    [_previewView setHidden:YES];
    
    arr = [[NSMutableArray alloc]init];
}
- (IBAction)previewLeftButton:(id)sender {
    
    
    NSInteger IDval = [[[globalArray valueForKey:@"Id"] objectAtIndex:[[arr firstObject] section]] integerValue];
    
    
    if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:[[arr firstObject] section]] integerValue]  == 0) {
        
        
        
        
        if ( [[[globalArray objectAtIndex:[[arr firstObject] section]] valueForKey:@"hasVoted"] integerValue ]==0) {
            
            BOOL interNetCheck=[WebServiceUrl InternetCheck];
            if (interNetCheck==YES ) {
                //
                //                    UIView *newView = [[UIView alloc]init];
                //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                //                    [self.view addSubview:newView];
                //
                //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
                //
                
                
                
                NSDictionary *jsonDictionary =@{
                                                
                                                @"isWeb":@"false",
                                                @"voteOption":@"false",
                                                @"postId":[NSNumber numberWithInteger:IDval]
                                                
                                                };
                
                
                
                
                
                
                NSError *error;
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                    
                                                                   options:0
                                    
                                                                     error:&error];
                
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"JSON OUTPUT: %@",JSONString);
                
                NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/vote"]];
                
                
                
                [requestPost setHTTPMethod:@"POST"];
                
                
                
                [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                
                
                
                NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                
                
                
                [requestPost setHTTPBody: requestData];
                
                
                [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                
                
                
                [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (error) {
                        //do something with error
                    } else {
                        
                        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (dic==nil) {
                                
                                
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                            }
                            else{
                                
                                
                                NSLog(@"hjfshjfhs%@",dic);
                                
                                
                                
                                voteResultVal = @"leftvoted";
                                
                                
                                //
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                        });
                    }
                }];
            }
            
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
            }
            
            
        }
        
        [_previewButtonView setHidden:YES];
        [_previewYouHaveVoted setHidden:NO];
        
        
        NSString*uVoted = [NSString stringWithFormat:@"You have voted for \"%@\"",_previewLeftButton.currentTitle];
        
        _previewYouVotedText.text =uVoted;
        
        
        
    }
    
    
}
- (IBAction)previewRightButton:(id)sender {
    
    
    NSInteger IDval = [[[globalArray valueForKey:@"Id"] objectAtIndex:[[arr firstObject] section] ] integerValue];
    
    if ([[[globalArray valueForKey:@"isDone"] objectAtIndex:[[arr firstObject] section]] integerValue]  == 0) {
        
        
        
        
        if ( [[[globalArray objectAtIndex:[[arr firstObject] section]] valueForKey:@"hasVoted"] integerValue ]==0) {
            
            BOOL interNetCheck=[WebServiceUrl InternetCheck];
            if (interNetCheck==YES ) {
                //
                //                    UIView *newView = [[UIView alloc]init];
                //                    newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                //                    [self.view addSubview:newView];
                //
                //                    [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
                //
                
                
                
                NSDictionary *jsonDictionary =@{
                                                
                                                @"isWeb":@"false",
                                                @"voteOption":@"true",
                                                @"postId":[NSNumber numberWithInteger:IDval]
                                                
                                                };
                
                
                
                
                
                
                NSError *error;
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                    
                                                                   options:0
                                    
                                                                     error:&error];
                
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"JSON OUTPUT: %@",JSONString);
                
                NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/vote"]];
                
                
                
                [requestPost setHTTPMethod:@"POST"];
                
                
                
                [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
                
                
                
                NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
                
                
                
                [requestPost setHTTPBody: requestData];
                
                
                [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
                
                
                
                [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (error) {
                        //do something with error
                    } else {
                        
                        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (dic==nil) {
                                
                                
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                            }
                            else{
                                
                                
                                NSLog(@"hjfshjfhs%@",dic);
                                
                                
                                //
                                //                                    [GMDCircleLoader hideFromView:newView animated:YES];
                                //                                    [newView removeFromSuperview];
                                
                                
                                voteResultVal = @"rightvoted";
                                
                            }
                            
                            
                            
                            
                        });
                    }
                }];
            }
            
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
            }
            
            
        }
        
        [_previewButtonView setHidden:YES];
        [_previewYouHaveVoted setHidden:NO];
        
        
        NSString*uVoted = [NSString stringWithFormat:@"You have voted for \"%@\"",_previewRightButton.currentTitle];
        
        _previewYouVotedText.text =uVoted;
        
        
    }
    
    
}




//ZOOM IMAGE VIEW INSIDE SCROLL VIEW


-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    
    
    CGSize boundsSize = _zoomView.bounds.size;
    CGRect contentsFrame = _zoomImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    _zoomImageView.frame = contentsFrame;
    
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomImageView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
}


- (IBAction)zoomCloseButton:(id)sender {
    [_myTableView setUserInteractionEnabled:YES];
    [_zoomView setHidden:YES];
}
- (IBAction)CheckInButton:(id)sender {
}

- (IBAction)hashCloseButton:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)newHeyVotes:(id)sender {
    
    [heyVoteUpdates setHidden:YES];
    
    [_myTableView setContentOffset:CGPointZero animated:YES];
    
    if ([_secondHeader alpha] == 0.0f) {
        
        
        
        //fade in
        [UIView animateWithDuration:0.5f animations:^{
            _secondHeader.alpha = 1.0f;
            _headerView.frame = HeaderRect;
            _myTableView.frame = tabRect;
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}
- (IBAction)thirdCommentButton:(id)sender {
    //
    //
    //    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    //    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    //    globalViewCell*cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    //    if (indexPath != nil)
    //    {
    //
    //        NSLog(@"%@",[globalArray objectAtIndex:indexPath.section]);
    //
    //        BOOL interNetCheck=[WebServiceUrl InternetCheck];
    //        if (interNetCheck==YES ) {
    //            
    //            UIView *newView = [[UIView alloc]init];
    //            newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //            [self.view addSubview:newView];
    //            
    //            [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
    //            
    //            
    //            
    //            
    //            NSDictionary *jsonDictionary =@{
    //                                            @"contactToken":[[[[[globalArray valueForKey:@"combo"] objectAtIndex:indexPath.section] valueForKey:@"lstComments"] valueForKey:@"UserIdf"] objectAtIndex:2],
    //                                            @"isWeb":@"false"                                           };
    //            
    //            
    //            
    //            
    //            
    //            
    //            NSError *error;
    //            
    //            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
    //                                
    //                                                               options:0
    //                                
    //                                                                 error:&error];
    //            
    //            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    //            
    //            NSLog(@"JSON OUTPUT: %@",JSONString);
    //            
    //            NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/viewprofileExternal"]];
    //            
    //            
    //            
    //            [requestPost setHTTPMethod:@"POST"];
    //            
    //            
    //            
    //            [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
    //            
    //            
    //            
    //            NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    //            
    //            
    //            
    //            [requestPost setHTTPBody: requestData];
    //            
    //            //  [requestPost addValue:@"hhhffftttuuu" forHTTPHeaderField:@"Value"];
    //            
    //            
    //            
    //            [requestPost addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"] forHTTPHeaderField:@"hjtyu34"];
    //            
    //            // NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:requestPost delegate:self];
    //            
    //            [NSURLConnection sendAsynchronousRequest:requestPost queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    //                if (error) {
    //                    //do something with error
    //                } else {
    //                    
    //                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //                    //            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
    //                    //            NSString *newLineStr = @"\n";
    //                    //            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
    //                    //
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //                        
    //                        if (dic==nil) {
    //                            
    //                            
    //                            [GMDCircleLoader hideFromView:newView animated:YES];
    //                            [newView removeFromSuperview];
    //                            
    //                            
    //                        }
    //                        else{
    //                            
    //                            
    //                            NSLog(@"hjfshjfhs%@",dic);
    //                            
    //                            
    //                            
    //                            
    //                            NSMutableArray*arrayVal = [[NSMutableArray alloc]init];
    //                            
    //                            [arrayVal addObject:[dic valueForKey:@"ViewProfileExternalResult"]];
    //                            
    //                            [GMDCircleLoader hideFromView:newView animated:YES];
    //                            [newView removeFromSuperview];
    //                            
    //                            
    //                            
    //                            
    //                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //                            heyVoteProfileVC *myVC = (heyVoteProfileVC *)[storyboard instantiateViewControllerWithIdentifier:@"heyVoteProfileVC"];
    //                            myVC.profileArray = arrayVal;
    //                            myVC.contactToke = [[globalArray valueForKey:@"Token"] objectAtIndex:indexPath.section];
    //                            [self PushAnimation];
    //                            [self.navigationController pushViewController:myVC animated:NO];
    //                            
    //                            
    //                        }
    //                        
    //                        
    //                        
    //                        
    //                    });
    //                }
    //            }];
    //        }
    //        
    //        else{
    //            
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check your Internet Connection"
    //                                                            message:@""
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"OK"
    //                                                  otherButtonTitles:nil];
    //            [alert show];
    //            
    //            
    //        }
    //        
    //        
    //    }
    //    
    //    
    //    
    //    
    //    
    //    
}
@end
