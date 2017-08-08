//
//  profileDetailsViewController.m
//  HeyVote
//
//  Created by Ikhram Khan on 6/3/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "profileDetailsViewController.h"

#import "GMDCircleLoader.h"
#import "UIView+Toast.h"
#import "WebServiceUrl.h"
#import "UIImageView+WebCache.h"
#import "FollowFollowingViewController.h"


#import "UIView+Toast.h"
#import "GMDCircleLoader.h"

#import "WebServiceUrl.h"
#import "UIImageView+WebCache.h"

@interface profileDetailsViewController (){
    
    
    NSMutableArray * arrayVal;
    
    NSString* moodStr;
    
    NSString*   base64StringDouble ;
    
}

@end

@implementation profileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [_nameText setLimit:20];
    [_textFieldView setHidden:NO];
    
    [self.moodSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
    [self.moodSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateHighlighted];
    

    _moodSlider.value = 0;
    
    
    _funLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
    _seriousLabel.textColor =[UIColor lightGrayColor];
    _generalLabel.textColor = [UIColor lightGrayColor];
    
    
    [_moodView setHidden:YES];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    UITapGestureRecognizer *singleFingerTappp =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(singleFingerTappp:)];
    
    [_textFieldView addGestureRecognizer:singleFingerTappp];
    
    [_moodView addGestureRecognizer:singleFingerTap];
    
    [_nameText resignFirstResponder];

    [self callMainWebService];
    
    moodStr = @"Fun";
    
    
    
}


-(void)updateStatus{
    
    
    
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        
                                        @"isWeb":@"false",
                                        @"status":moodStr
                                        
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/updatestatus_n"]];
        
        
        
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
                        
                        
                        
                        [self showToast:@"Updated Successfully"];
                        
                        
                        
                        
                        
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



-(void)uploadPicture{
    
    
    
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        
                                        @"isWeb":@"false",
                                        @"data":base64StringDouble
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/changepicture"]];
        
        
        
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
                        
                        
                        
                        [self showToast:@"Updated Successfully"];
                        
                        
                        
                        
                        
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



-(void)updateUserName{
    
    
    
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        
                                        @"isWeb":@"false",
                                        @"name":_nameText.text
                                        
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/updatename"]];
        
        
        
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
                        
                        
                        
                        [self showToast:@"Updated Successfully"];
                        
                        
                        
                        
                        
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


-(void)callMainWebService{
    
    

    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
       
        
        
                            UIView *newView = [[UIView alloc]init];
                            newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                            [self.view addSubview:newView];
        
                            [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        
        
        NSDictionary *jsonDictionary =@{
                                        
                                        @"isWeb":@"false",
                                        @"contactToken":[[NSUserDefaults standardUserDefaults] valueForKey:@"tokenVal"]
                                        
                                        };
        
        
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/viewprofileOwner_N4"]];
        
        
        
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
                       arrayVal = [[NSMutableArray alloc]init];
                        arrayVal = [dic valueForKey:@"ViewProfileOwner_N4Result"];
                        
                        
                        
                        
                        if (arrayVal.count > 0) {
                            
                            
                            _nameText.text = [arrayVal valueForKey:@"DisplayName"];
                            _moodLabelText.text =[NSString stringWithFormat:@"Mood : %@",[arrayVal valueForKey:@"Status"]];
                            _heyvotesTotal.text = [NSString stringWithFormat:@"HeyVotes : %ld",(long)[[arrayVal valueForKey:@"HeyVotesCount"] integerValue]];
                            
                            _followersTotal.text = [NSString stringWithFormat:@"Followers : %ld",(long)[[arrayVal valueForKey:@"FollowerCount"] integerValue]];
                            
                            _followingTotal.text = [NSString stringWithFormat:@"Followings : %ld",(long)[[arrayVal valueForKey:@"FollowingCount"] integerValue]];
                            
                            
                            
                            
                            _yourrank.text = [NSString stringWithFormat:@"You are ranked %ld",(long)[[arrayVal valueForKey:@"GlobalRank"] integerValue]];
                            
                            _yourViewLocal.text = [NSString stringWithFormat:@"No of Views in %@ : %ld",[arrayVal valueForKey:@"Territory"],(long)[[arrayVal valueForKey:@"TerritoryViewCount"] integerValue]];
                            
                            _yourViewGlobal.text = [NSString stringWithFormat:@"No of Views in Global : %ld",(long)[[arrayVal valueForKey:@"GlobalViewCount"] integerValue]];
                            
                            if ([arrayVal valueForKey:@"ImageIdf"] != nil) {
                                
                                
                                NSString * imageString = [NSString stringWithFormat:@"https://www.heyvote.com/Home/GetImage/%@/%@",[arrayVal valueForKey:@"ImageIdf"],[arrayVal valueForKey:@"FolderPath"]];
                                
                                [_profileImageView  sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                                
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
       
                        
                        
                        
                        
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


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    
    [_moodView setHidden:YES];
    
    
}


- (void)singleFingerTappp:(UITapGestureRecognizer *)recognizer {
    
    
    [_textFieldView setHidden:YES];
    [_nameText becomeFirstResponder];
    
    
   
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        NSLog(@"cancel");
        
        _nameText.text = [arrayVal valueForKey:@"DisplayName"];
        
        
    }
    else
    {
        NSLog(@"okkk");
        
        if ([[arrayVal valueForKey:@"DisplayName"] isEqualToString:_nameText.text]) {
            
        }
        else{
            
              [self updateUserName];
        }
        
      
        
        
      
        
    
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    
    [super viewDidDisappear:YES];
    
    [_nameText resignFirstResponder];
    
  [_textFieldView setHidden:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updateButton:(id)sender {
    _moodLabelText.text = [NSString stringWithFormat:@"Mood : %@",moodStr];
    [_moodView setHidden:YES];
    
    [self updateStatus];
    
}
- (IBAction)moodEditButton:(id)sender {
     [_moodView setHidden:NO];
    
}
- (IBAction)sliderValue:(id)sender {
    
    
    if (_moodSlider.value>3 && _moodSlider.value<60) {
     
        
        _funLabel.textColor = [UIColor lightGrayColor];
        _seriousLabel.textColor =[UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
        _generalLabel.textColor = [UIColor lightGrayColor];
        
        _moodSlider.value = 50;
        
         moodStr = @"Serious";
        
      
        
    }
    
    else if (_moodSlider.value>55&& _moodSlider.value<100){
        _funLabel.textColor = [UIColor lightGrayColor];
        _seriousLabel.textColor =[UIColor lightGrayColor];
        _generalLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
        _moodSlider.value = 100;
        
         moodStr = @"General";
   
    }
    
    else if(_moodSlider.value <45){
        
        _funLabel.textColor = [UIColor colorWithRed:(212/255.f) green:(0/255.f) blue:(25/255.f) alpha:1];
        _seriousLabel.textColor =[UIColor lightGrayColor];
        _generalLabel.textColor = [UIColor lightGrayColor];
        
        _moodSlider.value = 0;
        
         moodStr = @"Fun";
        
  
    }
    
    
}
- (IBAction)profileImageChabgeButton:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate:self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
    

}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            
            
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

- (UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
    original = nil;
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
 
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
    
   
    
    
    base64StringDouble = [UIImagePNGRepresentation([self compressForUpload:image scale:1.0f])
                                      base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    
    
    base64StringDouble = [base64StringDouble stringByReplacingOccurrencesOfString:@"/"
                                                           withString:@"_"];
    
    base64StringDouble = [base64StringDouble stringByReplacingOccurrencesOfString:@"+"
                                                           withString:@"-"];
    


    
    if (base64StringDouble.length >0) {
        [self uploadPicture];
        
        _profileImageView.image = image;
    }
        [self dismissViewControllerAnimated:YES completion:nil];
    

    
}




- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];    }
}


-(void)choosePhotoFromExistingImages{
    
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}






#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
    
    
}

-(void)showToast:(NSString*)msg{
    
    [self.view makeToast:msg
                duration:1.0
                position:CSToastPositionCenter];
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
    
    [_nameText resignFirstResponder];
    
    [_textFieldView setHidden:NO];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure want to change your profile name"
                                                    message:@""
                                                   delegate:self    // <------
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    
    [alert show];
    

 
  
}




- (IBAction)closeButton:(id)sender {
    
   [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)followFollowersButton:(id)sender {
    
    
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    FollowFollowingViewController *myVC = (FollowFollowingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FollowFollowingViewController"];
//  
//    
//    [self presentViewController:myVC animated:YES completion:nil];
//    
//    
//    
    
    
}
@end
