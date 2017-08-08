//
//  searchTabViewController.m
//  HeyVote
//
//  Created by Ikhram Khan on 5/14/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "searchTabViewController.h"
#import "homeViewController.h"
#import "ContactsTabViewController.h"
#import "GMDCircleLoader.h"
#import "UIView+Toast.h"
#import "WebServiceUrl.h"
#import "UIImageView+WebCache.h"
#import "searchTableCell.h"
#import "heyVoteProfileVC.h"
#import "CameraViewController.h"
#import "profileViewController.h"

@interface searchTabViewController (){
    
    NSString* contactTokenVal;
    
}

@end

@implementation searchTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableData = [[NSMutableArray alloc]init];
    [self.searchTabBar setReturnKeyType:UIReturnKeyDone];
    [self.searchTabBar setEnablesReturnKeyAutomatically:NO];
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainMenu:)
                                                 name:@"loginComplete" object:nil];
    
  

}
- (void)showMainMenu:(NSNotification *)note {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeViewController *myVC = (homeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
}
- (IBAction)homeButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeViewController *myVC = (homeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
    
    
    
}

- (IBAction)contactButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactsTabViewController *myVC = (ContactsTabViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ContactsTabViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
    
}


- (IBAction)centerButton:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraViewController *myVC = (CameraViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    
    
    
    [self presentViewController:myVC animated:YES completion:nil];
}

- (IBAction)searchButton:(id)sender {
}

- (IBAction)profileButton:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    profileViewController *myVC = (profileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    
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






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // [_searchTabBar resignFirstResponder];
    static NSString *CellIdentifier = @"Cell";
    searchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[searchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    
    if (_tableData.count == 0) {
        
    }
    
    else{
        cell.searchName.text = [[_tableData valueForKey:@"DisplayName"] objectAtIndex:indexPath.row];
        
        
          NSString*imageStr = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[_tableData valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row],[[_tableData valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
        
        
         [cell.searchImage  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"userContacts.png"]];
        
        
    }
    
    
    return cell;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
    
    contactTokenVal = [[_tableData valueForKey:@"UserIdf"] objectAtIndex:indexPath.row];
    
     [self callProfileView];
    
    
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



- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    NSLog(@"searchBarTextDidBeginEditing");
    
  

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"The search text is: %@", searchText);
    
    [self callWebService:searchText];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar {
    NSLog(@"searchBarTextDidEndEditing");
    
    
    if ([theSearchBar.text length] == 0) {
        _tableData = [[NSMutableArray alloc]init];
        
        [_searchTableView reloadData];
    }
    [theSearchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
  
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    _tableData = [[NSMutableArray alloc]init];
    
    [_searchTableView reloadData];
    [_searchTabBar resignFirstResponder];
}


-(void)callWebService :(NSString*)searchVal{
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
//        UIView *newView = [[UIView alloc]init];
//        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//        [self.view addSubview:newView];
//        
//        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        @"searchString":searchVal,
                                        @"pageId":@"0",
                                        @"pageSize":@"5" };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/Searchusers_n2"]];
        
        
        
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
                        
                        
                    }
                    else{
                        _tableData = [[NSMutableArray alloc] init];
                        
                        [_tableData addObjectsFromArray:[dic valueForKey:@"SearchUsers_N2Result"]];
                        
                        [_searchTableView reloadData];
                        
//                        [GMDCircleLoader hideFromView:newView animated:YES];
//                        [newView removeFromSuperview];
                        
          
                        
                        
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




@end
