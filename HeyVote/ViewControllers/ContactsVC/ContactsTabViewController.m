//
//  ContactsTabViewController.m
//  HeyVote
//
//  Created by Ikhram Khan on 4/28/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "ContactsTabViewController.h"
#import "KTSContactsManager.h"
#import "contactsViewCell.h"
#import "homeViewController.h"
#import "GMDCircleLoader.h"
#import "UIView+Toast.h"
#import "WebServiceUrl.h"
#import "followingContactsCell.h"
#import "UIImageView+WebCache.h"
#import "searchTabViewController.h"
#import "heyVoteProfileVC.h"
#import "CameraViewController.h"
#import "profileViewController.h"

@interface ContactsTabViewController () <KTSContactsManagerDelegate>

@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) KTSContactsManager *contactsManager;

@end

@implementation ContactsTabViewController{
    
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
    self.contactsManager = [KTSContactsManager sharedManager];
    self.contactsManager.delegate = self;
    self.contactsManager.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES] ];
    [self loadData];
    
  namesArray = [[NSMutableArray alloc] init];
    
       NSMutableDictionary *sampleDict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [self.tableData count]; i++) {
        
     
        
         NSDictionary *contact = [self.tableData objectAtIndex:i];
        
        NSString *firstName = contact[@"firstName"];
       NSString * fullName = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@", contact[@"lastName"]]];
        
        NSString * phonenumber;

        
        if ([[[_tableData objectAtIndex:i]valueForKey:@"phones"] count] == 0) {
            phonenumber = @"";
        }
        
        else{
             phonenumber = [NSString stringWithFormat:@"%@",[[[[_tableData objectAtIndex:i]valueForKey:@"phones"]valueForKey:@"value"]objectAtIndex:0] ];
            
        }
        
        [sampleDict setObject:fullName forKey:@"Name"];
        [sampleDict setObject:phonenumber forKey:@"Number"];
        
        
       
        [namesArray addObject:sampleDict];
        sampleDict = [[NSMutableDictionary alloc] init];
        
        
        
    }
    
    
    selectVar = @"phone";
    [_phoneView setHidden:NO];
    [_followingView setHidden:YES];
    
   //  [self callWebService];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"designerArray"];
    if (data.length == 0 ){
       [self callWebService];
         [_phoneTableView reloadData];
        
    }
    
    else{
        
        dictValArray = [[NSMutableArray alloc]init];
        NSMutableArray * newArray = [[NSMutableArray alloc]init];
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"designerArray"];
        newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [dictValArray addObjectsFromArray:newArray];
        [_phoneTableView reloadData];
    }
    
    
  
        [_phoneTableView reloadData];
   
    
    
    //  self.searchResult = [NSMutableArray arrayWithCapacity:[namesArray count]];
 
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"designerArray"];
    
    if (data.length == 0 && dictValArray.count > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dictValArray]  forKey:@"designerArray"];
        [defaults synchronize];
        
    }
}

-(void)callWebService{
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        @"lstContacts":namesArray,
                                        @"isWeb":@"false"                                           };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/contacts/AddContacts_N1"]];
        
        
        
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
                         selectVar = @"phone";
                        
                        NSLog(@"%@",dic);
                        NSMutableDictionary * dictVal = [[NSMutableDictionary alloc]init];
                        
                         NSMutableDictionary * greenVal = [[NSMutableDictionary alloc]init];
                        
                       dictValArray = [[NSMutableArray alloc]init];
                        
                        for (int i=0; i<[dic count]; i++) {
                            
                            
                            if ([[dic valueForKey:@"ContactToken"] objectAtIndex:i] != [NSNull null]) {
                                
                                 [greenVal setObject:[[dic valueForKey:@"Name"] objectAtIndex:i] forKey:@"Name"];
                                [greenVal setObject:[[dic valueForKey:@"Number"] objectAtIndex:i] forKey:@"Number"];
                                [greenVal setObject:[[dic valueForKey:@"ContactToken"] objectAtIndex:i] forKey:@"ContactToken"];
                                   [greenVal setObject:[[dic valueForKey:@"FolderPath"] objectAtIndex:i] forKey:@"FolderPath"];
                                
                                     [greenVal setObject:[[dic valueForKey:@"ImageIdf"] objectAtIndex:i] forKey:@"ImageIdf"];

                                
                            }
                            
                            [dictVal setObject:[[dic valueForKey:@"Name"] objectAtIndex:i] forKey:@"Name"];
                            [dictVal setObject:[[dic valueForKey:@"Number"] objectAtIndex:i] forKey:@"Number"];
                            [dictVal setObject:[[dic valueForKey:@"ContactToken"] objectAtIndex:i] forKey:@"ContactToken"];
                            
                             [dictVal setObject:[[dic valueForKey:@"FolderPath"] objectAtIndex:i] forKey:@"FolderPath"];
                            
                            
                            
                            
                            
                            [dictVal setObject:[[dic valueForKey:@"ImageIdf"] objectAtIndex:i] forKey:@"ImageIdf"];
                            
                            if ([greenVal count] >0) {
                                 [greenValArray addObject:greenVal];
                                greenVal = [[NSMutableDictionary alloc] init];
                            }
                           
                            
                            [dictValArray addObject:dictVal];
                            
                            dictVal = [[NSMutableDictionary alloc] init];
                            
                            
                        }
                      
                        
               
                        [_phoneTableView reloadData];
                        
                        [GMDCircleLoader hideFromView:newView animated:YES];
                        [newView removeFromSuperview];
                        
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:greenValArray forKey:@"greenValue"];
                        [defaults synchronize];
         
                        
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
                                        @"isWeb":@"false"};
        
        
        
      
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

- (void)loadData
{
    [self.contactsManager importContacts:^(NSArray *contacts)
     {
         self.tableData = contacts;
         [self.phoneTableView reloadData];
         NSLog(@"contacts: %@",contacts);
     }];
}

-(void)addressBookDidChange
{
    NSLog(@"Address Book Change");
    [self loadData];
}

-(BOOL)filterToContact:(NSDictionary *)contact
{
    return YES;
    return ![contact[@"company"] isEqualToString:@""];
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

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [searchResult count];
    }
    
   else if (tableView == _phoneTableView) {
     
            return [dictValArray count];
        
            
            
       
    }
    
    else if(tableView ==_followingTableView){
        
            
        
        return [followingArray count];
            }
        
    
    return 1;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    if (tableView == _phoneTableView || tableView == self.searchDisplayController.searchResultsTableView) {
        
              static NSString *simpleTableIdentifier = @"phoneCell";
    
    contactsViewCell *cell = (contactsViewCell*)[_phoneTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[contactsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
 
        
       
        
        if ([[[searchResult valueForKey:@"ContactToken"] objectAtIndex:indexPath.row] isEqual:[NSNull null]] || [[searchResult valueForKey:@"ContactToken"] objectAtIndex:indexPath.row] == nil ) {
            cell.nameLabel.text= [[searchResult valueForKey:@"Name"] objectAtIndex:indexPath.row];
            cell.nameLabel.textColor = [UIColor colorWithRed:173/255.0f green:18/255.0f blue:34/255.0f alpha:1.0f];
            
            NSString*imageStr = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[searchResult valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row],[[searchResult valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
            
                  [cell.phoneImage  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"userContacts.png"]];

            [cell.inviteButton setHidden:NO];
           
            
        }
        
        else{
            cell.nameLabel.text= [[searchResult valueForKey:@"Name"] objectAtIndex:indexPath.row];
            cell.nameLabel.textColor = [UIColor colorWithRed:47/255.0f green:137/255.0f blue:109/255.0f alpha:1.0f];
             NSString*imageStr = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[searchResult valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row],[[searchResult valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
                  [cell.phoneImage  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"userContacts.png"]];
            
                        [cell.inviteButton setHidden:YES];
        }
      
        

    }
    else
    {
       
        
        if ([[[dictValArray valueForKey:@"ContactToken"] objectAtIndex:indexPath.row] isEqual:[NSNull null]] || [[dictValArray valueForKey:@"ContactToken"] objectAtIndex:indexPath.row] == nil ) {
            cell.nameLabel.text = [[dictValArray valueForKey:@"Name"] objectAtIndex:indexPath.row];
            cell.nameLabel.textColor = [UIColor colorWithRed:173/255.0f green:18/255.0f blue:34/255.0f alpha:1.0f];
            [cell.inviteButton setHidden:NO];
            
               NSString*imageStr = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[dictValArray valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row],[[dictValArray valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
            
             [cell.phoneImage  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"userContacts.png"]];
            
            
        }
        
        else{
            cell.nameLabel.text = [[dictValArray valueForKey:@"Name"] objectAtIndex:indexPath.row];
            cell.nameLabel.textColor = [UIColor colorWithRed:47/255.0f green:137/255.0f blue:109/255.0f alpha:1.0f];
            NSString*imageStr = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[[dictValArray valueForKey:@"ImageIdf"] objectAtIndex:indexPath.row],[[dictValArray valueForKey:@"FolderPath"] objectAtIndex:indexPath.row]];
            
                  [cell.phoneImage  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"userContacts.png"]];
            [cell.inviteButton setHidden:YES];
        }
     
    }
    
    
    
    
    
    
    
    
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
    

    
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        
        if ([[[searchResult valueForKey:@"ContactToken"] objectAtIndex:indexPath.row] isEqual:[NSNull null]]) {
            NSMutableArray * phoneVal = [[NSMutableArray alloc] init];
            [phoneVal addObject:[[searchResult valueForKey:@"Number"] objectAtIndex:indexPath.row]];
            
            NSString *messageBody = [NSString stringWithFormat:@"Hi %@,\n\nI invite you to download HeyVote.\n\nIt is the first voting social media in the world, and does not have fake accounts and all votes are real.\n\nFor Android smart phones\nhttps://play.google.com/store/apps/details?id=com.appcandles.heyvote",[[searchResult valueForKey:@"Name"] objectAtIndex:indexPath.row]];
            
            
            [self sendSMS:messageBody recipientList:[[dictValArray valueForKey:@"Number"] objectAtIndex:indexPath.row]];
            
        }
        
        else{
            
            
            contactTokenVal =[[searchResult valueForKey:@"ContactToken"] objectAtIndex:indexPath.row];
            [self callProfileView];
           
        }
    
    
    }
    
    else if(tableView ==_phoneTableView){
        
        
        if ([[[dictValArray valueForKey:@"ContactToken"] objectAtIndex:indexPath.row] isEqual:[NSNull null]]) {
            
            NSMutableArray * phoneVal = [[NSMutableArray alloc] init];
            [phoneVal addObject:[[dictValArray valueForKey:@"Number"] objectAtIndex:indexPath.row]];
            
            NSString *messageBody = [NSString stringWithFormat:@"Hi %@,\n\nI invite you to download HeyVote.\n\nIt is the first voting social media in the world, and does not have fake accounts and all votes are real.\n\nFor Android smart phones\nhttps://play.google.com/store/apps/details?id=com.appcandles.heyvote",[[dictValArray valueForKey:@"Name"] objectAtIndex:indexPath.row]];
            
            [self sendSMS:messageBody recipientList:phoneVal];
            
        }
        
        else{
            contactTokenVal =[[dictValArray valueForKey:@"ContactToken"] objectAtIndex:indexPath.row];
            
            [self callProfileView];
         
        }
        
        
        
    }
    
    else{
       
        NSLog(@"haiiii%@",[[[[followingArray valueForKey:@"lstContacts"] objectAtIndex:indexPath.row]objectAtIndex:0] valueForKey:@"Name"]);
        
        contactTokenVal =[[[[followingArray valueForKey:@"lstContacts"] objectAtIndex:indexPath.row]objectAtIndex:0] valueForKey:@"UserIdf"];
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




- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
   
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Name contains[c] %@", searchText];
        
        searchResult = [dictValArray filteredArrayUsingPredicate:resultPredicate];
        


        
    
}



-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{

        [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
        
        [_phoneTableView reloadData];
        
        return YES;

    
  

}


- (IBAction)homeButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeViewController *myVC = (homeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    [self PushAnimation];
    [self.navigationController pushViewController:myVC animated:NO];
    
    

}

- (IBAction)contactButton:(id)sender {

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
    _mySearchbar.text = nil;
    [_phoneTableView reloadData];
    [_mySearchbar resignFirstResponder];
   
   
    [_followingContacts setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_phoneContacts setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_phoneView setHidden:YES];
    [_followingView setHidden:NO];
   
  [self callWebServiceTwo];
    
    
    [_followingTableView reloadData];
    
}
@end
