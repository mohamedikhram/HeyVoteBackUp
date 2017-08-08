//
//  heyVoteProfileVC.m
//  HeyVote
//
//  Created by Ikhram Khan on 5/14/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "heyVoteProfileVC.h"

#import "GMDCircleLoader.h"
#import "UIView+Toast.h"
#import "WebServiceUrl.h"
#import "UIImageView+WebCache.h"
#import "CommentVC.h"
#import "NSData+Base64.h"
#import "GetPostDetailsViewController.h"

@interface heyVoteProfileVC (){
    NSMutableArray *arr;
    NSString * exactTime;
      UILabel *Timer;
    UIActivityIndicatorView *spinner;
    NSMutableArray* indexArrayVal;
    NSString*indexxxx;
    int newVal;
    CGRect screenRect;
     NSMutableArray* nameArr;
    CGFloat screenHeight;
    NSString* voteResultVal;
    CGRect screenRectios;
    CGFloat screenWidthios;
    NSString* followUnfolloww;
    
    NSString* blockUnblockk;
 
    AVPlayer *playergg ;
    
    NSMutableArray * voteResultsAraay;
   
    int valText ;
    float testVa;
    NSMutableArray * voteResultAraay;
    NSString * timerLoad;
    NSString* commentViewVal;
     NSString * previewVal;
}

@end

@implementation heyVoteProfileVC
@synthesize audioPlayer;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    timerLoad = @"";
     previewVal = @"";
    
    
     voteResultAraay = [[NSMutableArray alloc]init];
    
    
    
    screenRectios = [[UIScreen mainScreen] bounds];
    screenWidthios = screenRectios.size.width;
    
    screenRect= [[UIScreen mainScreen] bounds];
    
    screenHeight= screenRect.size.height;
    voteResultsAraay = [[NSMutableArray alloc] init];
    
    [_imageZoomView setHidden:YES];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
   
    tap.numberOfTapsRequired = 1;
    _profileImage.userInteractionEnabled = YES;
    [_profileImage addGestureRecognizer:tap];
    

    //[_myTableView setHidden:YES];
    voteResultVal = @"";
    
   
    
    NSLog(@"arrrayyyyy : %@",_profileArray);
    
    indexArrayVal = [[NSMutableArray alloc]init];
    
    
    NSString *statusLab = [NSString stringWithFormat:@"Status : %@",[[_profileArray valueForKey:@"Status"] objectAtIndex:0]];
    _statusLabel.text =statusLab;
    
    _nameLabel.text =[[_profileArray valueForKey:@"DisplayName"] objectAtIndex:0];
    
     NSString *heyVoteCount = [NSString stringWithFormat:@"HeyVotes : %@",[[_profileArray valueForKey:@"HeyVotesCount"] objectAtIndex:0]];
    NSString *heyVoteCountFollowers = [NSString stringWithFormat:@"Followers : %@",[[_profileArray valueForKey:@"FollowerCount"] objectAtIndex:0]];
     NSString *heyVoteCountFollowing = [NSString stringWithFormat:@"Following : %@",[[_profileArray valueForKey:@"FollowingCount"] objectAtIndex:0]];
    _heyVotesLabel.text = heyVoteCount;
    _followersLabel.text =heyVoteCountFollowers;
    _followingLabel.text = heyVoteCountFollowing;
    
    
    if ([[[_profileArray valueForKey:@"isFollowing"] objectAtIndex:0] integerValue] == 0) {
        [self.followUnfollow setTitle:@"FOLLOW" forState:UIControlStateNormal];
        
        
        
         followUnfolloww = @"follow";
    }
    
    else{
        
        [self.followUnfollow setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
        
        followUnfolloww = @"unfollow";
    }
    if ([[[_profileArray valueForKey:@"isAllowed"] objectAtIndex:0] integerValue] == 1) {
        [self.blockUnblock setTitle:@"BLOCK USER" forState:UIControlStateNormal];
        
        blockUnblockk = @"block";
    }
    
    else{
        
        [self.blockUnblock setTitle:@"UNBLOCK USER" forState:UIControlStateNormal];
        
         blockUnblockk = @"unblock";
    }
    
    NSString *labOne = [NSString stringWithFormat:@"%@ is ranked %@",[[_profileArray valueForKey:@"DisplayName"] objectAtIndex:0],[[_profileArray valueForKey:@"GlobalRank"] objectAtIndex:0]];
    
    NSString *labOneTwo = [NSString stringWithFormat:@"No of Views in %@ : %@",[[_profileArray valueForKey:@"Territory"] objectAtIndex:0],[[_profileArray valueForKey:@"TerritoryViewCount"] objectAtIndex:0]];
    
       NSString *labOneTwoThree = [NSString stringWithFormat:@"No of Views in Global : %@",[[_profileArray valueForKey:@"GlobalViewCount"] objectAtIndex:0]];
    
    
    
    _labelOne.text =labOne;
    _labelTwo.text = labOneTwo;
    _labelThree.text = labOneTwoThree;
    
    if ([[[_profileArray valueForKey:@"ImageIdf"] objectAtIndex:0] isEqual:[NSNull null]]) {
        
        NSLog(@"no imagesss");
        
    }
    
    else{
        
        NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[_profileArray valueForKey:@"ImageIdf"] objectAtIndex:0],[[_profileArray valueForKey:@"FolderPath"] objectAtIndex:0]];
        
        [_profileImage  sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"imagesPerson.jpeg"]];
    }
    
    
    
    
    
    if (indexArrayVal.count == 0) {
        newVal = 0;
        [self callProfileView:newVal];
    }
    

}

//- (void) awakeFromNib{
//    [self.myCollectionView registerClass:[HeyVoteProfileCollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionView"];
//}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    commentViewVal = @"";
    
    
}


- (void) handleImageTap:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    _zoomingImage.image =_profileImage.image;
    [_imageZoomView setHidden:NO];
    

    
    
   }




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
  

    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
       
    voteResultsAraay = [[NSMutableArray alloc]init];
}

-(void)callProfileView:(int)indexVal{
    
   
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
                                         @"pageId":[NSNumber numberWithInt:indexVal],
                                        @"pageSize":[NSNumber numberWithInt:15],
                                        @"contactToken":_contactToke
                                        
                                        
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/posts/GetContactPostsList_N4"]];
        
        
        
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
                        
                        
//                        [GMDCircleLoader hideFromView:newView animated:YES];
//                        [newView removeFromSuperview];
//                        
                        
                    }
                    else{
                        
                        
                        NSLog(@"hjfshjfhs%@",dic);
                        
                        NSMutableArray* dataArray = [[NSMutableArray alloc]init];
                        
                        
                        [dataArray addObjectsFromArray:[dic valueForKey:@"GetContactPostsList_N4Result"]];
                        
                        if (dataArray.count > 0) {
                            [indexArrayVal addObjectsFromArray:dataArray];
                            
                            
                            if (indexArrayVal.count == 0) {
                                
                                [self.scrollableMainView setScrollEnabled:YES];
                                self.scrollableMainView.contentSize=CGSizeMake(self.mainView.bounds.size.width,_mainView.frame.size.height );
                            }
                            
                            else{
                                
                                [self.scrollableMainView setScrollEnabled:YES];
                                self.scrollableMainView.contentSize=CGSizeMake(self.mainView.bounds.size.width,_mainView.frame.size.height + _myCollectionView.frame.size.height);
                                
                            }
                            
                            
                            
                     
                            
                             [_myCollectionView reloadData];
                            
                            
//                            [_myTableView setContentOffset:CGPointMake(0, _myTableView.contentInset.top) animated:NO];
//                            
//                            _myTableView.frame = CGRectMake(_myTableView.frame.origin.x, _myTableView.frame.origin.y, _myTableView.frame.size.width, _myTableView.frame.size.height*19);
//                            
//                            
//                            
//                            [self.scrollableMainView setScrollEnabled:YES];
//                            self.scrollableMainView.contentSize=CGSizeMake(self.mainView.bounds.size.width,_myTableView.frame.size.height - _mainView.frame.size.height);

                        }
                    
                        
                        else{
                            
                           newVal = 1000;
                        }
                       
                        
                        
                        
                     
//                        
//                        [GMDCircleLoader hideFromView:newView animated:YES];
//                        [newView removeFromSuperview];
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





#pragma mark - CollectionView
#pragma mark DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:      (NSInteger)section
{
    return [indexArrayVal count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collectionView");
    static NSString *CellIdentifier = @"myCollectionView";
    HeyVoteProfileCollectionViewCell *cell = (HeyVoteProfileCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
   //   cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    if (newVal == 1000) {
        
    }
    
    else{
        
        if (indexPath.row == [indexArrayVal count]-1 ) {
            
            
            int plusVal = newVal+1;
            newVal = plusVal;
            
            [self callProfileView:plusVal];
            
            
        }
    }
    
    
    if (indexArrayVal.count >0) {

    
    if ([[[indexArrayVal valueForKey:@"PostType"] objectAtIndex:indexPath.section] integerValue] == 1) {
        
        NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[indexArrayVal valueForKey:@"Image1Idf"] objectAtIndex:indexPath.row],[[indexArrayVal valueForKey:@"PostFolderPath"] objectAtIndex:indexPath.row]];
        
        [cell.postImageView  sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@""]];
    }
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (screenHeight==736.000000)
        
    {
        
        
        return CGSizeMake(136.66, 136.66);
        
        
    }
    
    else if (screenHeight==667.000000)
        
    {
        
        return CGSizeMake(123.66, 123.66);
        
        
        
    }
    
    else if(screenHeight==568.000000)
        
    {
        
        return CGSizeMake(105.33, 105.33);
        

    }

    
    return CGSizeMake(105.33, 105.33);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[indexArrayVal objectAtIndex:indexPath
                 .row]);
    
//    NSIndexPath *indexPathhh = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
//    [_myTableView scrollToRowAtIndexPath:indexPathhh
//                         atScrollPosition:UITableViewScrollPositionTop
//                                 animated:YES];
//    
//    [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
//                                   selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];
//    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GetPostDetailsViewController *myVC = (GetPostDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GetPostDetailsViewController"];
    myVC.postIdVal = [[indexArrayVal valueForKey:@"Id"] objectAtIndex:indexPath.row];
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

- (IBAction)followUnfollow:(id)sender {
    
    if ([_followUnfollow.currentTitle isEqualToString:@"FOLLOW"]) {
         [self.followUnfollow setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
        
     followUnfolloww = @"unfollow";
                
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
                                                    @"contactToken":_contactToke
                                                    
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
                     [self.followUnfollow setTitle:@"FOLLOW" forState:UIControlStateNormal];
                    
                    
                }
                
        
    
        
    }
    
    else if ([_followUnfollow.currentTitle isEqualToString:@"UNFOLLOW"]){
         [self.followUnfollow setTitle:@"FOLLOW" forState:UIControlStateNormal];
         followUnfolloww = @"follow";
        
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
                                            @"contactToken":_contactToke
                                            
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
            
            
             [self.followUnfollow setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
            
        }
        
        

        
    }
    
}
- (IBAction)blockUnblock:(id)sender {
    
    if ([_blockUnblock.currentTitle isEqualToString:@"BLOCK USER"]) {
        [self.blockUnblock setTitle:@"UNBLOCK USER" forState:UIControlStateNormal];
        
        blockUnblockk = @"unblock";
        
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
                                            @"contactToken":_contactToke
                                            
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
            [self.blockUnblock setTitle:@"BLOCK USER" forState:UIControlStateNormal];
            
            
        }
        
        
        
        
    }
    
    else if ([_blockUnblock.currentTitle isEqualToString:@"UNBLOCK USER"]){
        [self.blockUnblock setTitle:@"BLOCK USER" forState:UIControlStateNormal];
         blockUnblockk = @"block";
        
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
                                            @"contactToken":_contactToke
                                            
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
            
            
            [self.blockUnblock setTitle:@"UNBLOCK USER" forState:UIControlStateNormal];
            
        }
        
        
        
        
    }
    
}
- (IBAction)closeButton:(id)sender {
    
   [self.navigationController popViewControllerAnimated:NO];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did end decelerating");
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    NSLog(@"Did end dragging");
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did begin decelerating");
    
  

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"Did begin dragging");
    

    
}



@end
