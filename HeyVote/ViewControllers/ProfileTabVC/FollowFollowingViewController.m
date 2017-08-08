//
//  FollowFollowingViewController.m
//  HeyVote
//
//  Created by Ikhram Khan on 7/29/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "FollowFollowingViewController.h"

#import "contactsViewCell.h"

#import "GMDCircleLoader.h"
#import "UIView+Toast.h"
#import "WebServiceUrl.h"
#import "followingContactsCell.h"
#import "UIImageView+WebCache.h"

#import "heyVoteProfileVC.h"


@interface FollowFollowingViewController ()

@property (strong, nonatomic) NSArray *tableData;


@end

@implementation FollowFollowingViewController{
    
    NSMutableArray * namesArray;
    NSMutableArray * dictValArray;
    
    NSMutableArray * greenValArray;
    NSString*selectVar;
    NSMutableArray *followingArray;
    
    NSString*contactTokenVal;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    namesArray = [[NSMutableArray alloc]init];
    dictValArray = [[NSMutableArray alloc]init];
    followingArray = [[NSMutableArray alloc]init];
    greenValArray = [[NSMutableArray alloc]init];
    
    [_phoneContacts setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_followingContacts setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
   
   
    
    selectVar = @"phone";
    [_phoneView setHidden:NO];
    [_followingView setHidden:YES];
    
    [self callWebService];
    
    //  self.searchResult = [NSMutableArray arrayWithCapacity:[namesArray count]];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
}

-(void)callWebService{
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        @"isFollowerList":@"true",
                                        @"isWeb":@"false"                                           };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/contacts/getfollowerfollowinglist"]];
        
        
        
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
                        
                        if (dic.count == 0) {
                            
                        }
                        
                        else{
                            
                            dictValArray = [[NSMutableArray alloc]init];
                            
                            [dictValArray addObjectsFromArray:[dic valueForKey:@"GetFollowerFollowingListResult"]];
                            [_phoneTableView reloadData];
                        }
                        
                        
                        
                        
                        //                        NSMutableDictionary * dictVal = [[NSMutableDictionary alloc]init];
                        //                        dictValArray = [[NSMutableArray alloc]init];
                        //
                        //                        for (int i=0; i<[dic count]; i++) {
                        //
                        //                            [dictVal setObject:[[dic valueForKey:@"Name"] objectAtIndex:i] forKey:@"Name"];
                        //                            [dictVal setObject:[[dic valueForKey:@"Number"] objectAtIndex:i] forKey:@"Number"];
                        //                            [dictVal setObject:[[dic valueForKey:@"ContactToken"] objectAtIndex:i] forKey:@"ContactToken"];
                        //                            [dictValArray addObject:dictVal];
                        //
                        //                            dictVal = [[NSMutableDictionary alloc] init];
                        //
                        //                        }
                        
                        [_phoneTableView reloadData];
                        
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


-(void)callWebServiceTwo{
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        @"isFollowerList":@"false",
                                        @"isWeb":@"false"                                           };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/contacts/getfollowerfollowinglist"]];
        
        
        
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
                        
                        if (dic.count == 0) {
                            
                        }
                        
                        else{
                            
                            followingArray = [[NSMutableArray alloc]init];
                            
                            [followingArray addObjectsFromArray:[dic valueForKey:@"GetFollowerFollowingListResult"]];
                            [_followingTableView reloadData];
                        }
                        
                        
                        
                        
                        //                        NSMutableDictionary * dictVal = [[NSMutableDictionary alloc]init];
                        //                        dictValArray = [[NSMutableArray alloc]init];
                        //
                        //                        for (int i=0; i<[dic count]; i++) {
                        //
                        //                            [dictVal setObject:[[dic valueForKey:@"Name"] objectAtIndex:i] forKey:@"Name"];
                        //                            [dictVal setObject:[[dic valueForKey:@"Number"] objectAtIndex:i] forKey:@"Number"];
                        //                            [dictVal setObject:[[dic valueForKey:@"ContactToken"] objectAtIndex:i] forKey:@"ContactToken"];
                        //                            [dictValArray addObject:dictVal];
                        //
                        //                            dictVal = [[NSMutableDictionary alloc] init];
                        //
                        //                        }
                        
                        [_followingTableView reloadData];
                        
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    
}
#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    
    
    
   if (tableView == _phoneTableView) {
        
        return [dictValArray count];
        
        
        
        
    }
    
    else {
        
        
        
        return [followingArray count];
    }
    
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    if (tableView == _phoneTableView) {
        
        static NSString *simpleTableIdentifier = @"phoneCell";
        
        contactsViewCell *cell = (contactsViewCell*)[_phoneTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[contactsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        
        
     
                cell.nameLabel.text = [[[[[dictValArray valueForKey:@"lstContacts"] objectAtIndex:indexPath.row]objectAtIndex:0] valueForKey:@"Name"] capitalizedString] ;
                
                cell.nameLabel.textColor = [UIColor colorWithRed:47/255.0f green:137/255.0f blue:109/255.0f alpha:1.0f];
                
                NSString*imageStr = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[dictValArray valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row],[[dictValArray valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
                
                
                [cell.phoneImage  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"userContacts.png"]];
           
        
        
        
  
        
        
        
        return cell;
        
    }
    
    else if (tableView == _followingTableView){
        
        
        static NSString *simpleTableIdentifier = @"followingCell";
        
        followingContactsCell *cell = (followingContactsCell*)[_followingTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[followingContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        
        if (followingArray.count != 0) {
            cell.profileName.text = [[[[[followingArray valueForKey:@"lstContacts"] objectAtIndex:indexPath.row]objectAtIndex:0] valueForKey:@"Name"] capitalizedString] ;
            
            cell.profileName.textColor = [UIColor colorWithRed:47/255.0f green:137/255.0f blue:109/255.0f alpha:1.0f];
            
            NSString*imageStr = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[followingArray valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row],[[followingArray valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
            
            
            [cell.profileImage  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"userContacts.png"]];
            
        }
        
        return cell;
        
        
        
    }
    return nil;
}

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    
    
    NSLog(@"Section:%ld Row:%ld selected and its data is %@",
          (long)indexPath.section,(long)indexPath.row,nameLabel.text);
    
    
 if(tableView ==_phoneTableView){
        
 
           contactTokenVal =[[[[dictValArray valueForKey:@"lstContacts"] objectAtIndex:indexPath.row]objectAtIndex:0] valueForKey:@"contactToken"];
            
            [self callProfileView];
     
    }
    
    else{
        
        NSLog(@"haiiii%@",[[[[followingArray valueForKey:@"lstContacts"] objectAtIndex:indexPath.row]objectAtIndex:0] valueForKey:@"Name"]);
        
        contactTokenVal =[[[[followingArray valueForKey:@"lstContacts"] objectAtIndex:indexPath.row]objectAtIndex:0] valueForKey:@"contactToken"];
        [self callProfileView];
        
    }
    
    
}

-(void)callProfileView{
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        @"contactToken":contactTokenVal,
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
                        
                        
                        
                        
                        
                        
                        //                        NSMutableDictionary * dictVal = [[NSMutableDictionary alloc]init];
                        //                        dictValArray = [[NSMutableArray alloc]init];
                        //
                        //                        for (int i=0; i<[dic count]; i++) {
                        //
                        //                            [dictVal setObject:[[dic valueForKey:@"Name"] objectAtIndex:i] forKey:@"Name"];
                        //                            [dictVal setObject:[[dic valueForKey:@"Number"] objectAtIndex:i] forKey:@"Number"];
                        //                            [dictVal setObject:[[dic valueForKey:@"ContactToken"] objectAtIndex:i] forKey:@"ContactToken"];
                        //                            [dictValArray addObject:dictVal];
                        //
                        //                            dictVal = [[NSMutableDictionary alloc] init];
                        //
                        //                        }
                        
                        
                        
                        NSMutableArray*arrayVal = [[NSMutableArray alloc]init];
                        
                        [arrayVal addObject:[dic valueForKey:@"ViewProfileExternal_N4Result"]];
                        
                        [GMDCircleLoader hideFromView:newView animated:YES];
                        [newView removeFromSuperview];
                        
                        
                        
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        heyVoteProfileVC *myVC = (heyVoteProfileVC *)[storyboard instantiateViewControllerWithIdentifier:@"heyVoteProfileVC"];
                        myVC.profileArray = arrayVal;
                        myVC.contactToke = contactTokenVal;
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
-(void)PushAnimation
{
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.0f;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
}



- (IBAction)phoneContacts:(id)sender {
    
    selectVar = @"phone";
    [_phoneContacts setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_followingContacts setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_phoneView setHidden:NO];
    [_followingView setHidden:YES];
    
    
    [_phoneTableView reloadData];
    
    
}
- (IBAction)followingContacts:(id)sender {
    selectVar = @"follow";
    
    [_phoneTableView reloadData];

    
    
    [_followingContacts setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_phoneContacts setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_phoneView setHidden:YES];
    [_followingView setHidden:NO];
    
    [self callWebServiceTwo];
    
    
    [_followingTableView reloadData];
    
}
- (IBAction)followCloseButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end


