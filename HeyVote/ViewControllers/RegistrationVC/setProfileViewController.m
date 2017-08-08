//
//  setProfileViewController.m
//  HeyVote
//
//  Created by Ikhram khan on 03/05/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "setProfileViewController.h"
#import "homeViewController.h"
#import "GMDCircleLoader.h"
#import "UIView+Toast.h"
#import "WebServiceUrl.h"
#import <dlfcn.h>
#import <mach/port.h>
#import <mach/kern_return.h>


@interface setProfileViewController (){
    
    CGRect screenRect;
    CGFloat screenHeight;
    NSString* rangeVal;
    UIImage *chosenImage;
    NSString*genderID;
    NSString*moodName;
    NSString*moodID;
    NSString*ageRangeID;
    
}


@end

@implementation setProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_opaqueView setHidden:YES];
    [_reenterEmailView setHidden:YES];
    
    _reenterEmailView.layer.cornerRadius=5.0;
    _reenterEmailView.clipsToBounds=YES;
    
    genderID = @"1";
    moodName = @"Fun";
    moodID = @"1";
    ageRangeID = @"1";
    
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor lightGrayColor];
   
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3;
    
    
    
  screenRect = [[UIScreen mainScreen] bounds];
   screenHeight = screenRect.size.height;
    
    
    [self.moodSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
    [self.moodSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateHighlighted];
    
    [self.genderSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
    [self.genderSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateHighlighted];
    
    [self.ageSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateNormal];
    [self.ageSlider setThumbImage:[UIImage imageNamed:@"picker.png"] forState:UIControlStateHighlighted];
  
    
    _funLabel.textColor =[UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
    _maleLabel.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
    _lessThanTwenty.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
    
   
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    
    tapGesture1.numberOfTapsRequired = 1;

    [self.imageView addGestureRecognizer:tapGesture1];

}

- (void) tapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
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

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
 //   UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
  chosenImage = image;
    
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.scrollableView setScrollEnabled:YES];
    self.scrollableView.contentSize=CGSizeMake(self.mainView.bounds.size.width,self.mainView.bounds.size.height);
    
}


- (IBAction)finishedButton:(id)sender {
    
    
    [self callWebService];
    
    
  

}


-(void)showToast:(NSString*)msg{
    
    [self.view makeToast:msg
                duration:1.0
                position:CSToastPositionCenter];
}



-(void)callWebService{
      

    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSString*emaillll = _emailText.text;
    BOOL emailVal = [emailTest evaluateWithObject:emaillll];

    NSString *yourstring = _nameText.text;
    
    NSString *Regex = @"[a-zA-Z][a-zA-Z ]*";
    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    
  
    
    if ([_nameText.text length] == 0 ) {
        NSString* errorMsg = @"Please enter valid user name !";
        [self showToast:errorMsg];
    }
    
    else if ([_emailText.text length] == 0 || emailVal == NO){
        
        NSString* errorMsg = @"Please enter valid Email address !";
        [self showToast:errorMsg];
        
        
        
    }
    
    else{
        
        
        [_opaqueView setHidden:NO];
        [_reenterEmailView setHidden:NO];
        
        
    }
 

    
 }

- (NSString *) serialNumber
{
    NSString *serialNumber = nil;
    
    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
    if (IOKit)
    {
        mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
        CFMutableDictionaryRef (*IOServiceMatching)(const char *name) = dlsym(IOKit, "IOServiceMatching");
        mach_port_t (*IOServiceGetMatchingService)(mach_port_t masterPort, CFDictionaryRef matching) = dlsym(IOKit, "IOServiceGetMatchingService");
        CFTypeRef (*IORegistryEntryCreateCFProperty)(mach_port_t entry, CFStringRef key, CFAllocatorRef allocator, uint32_t options) = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
        kern_return_t (*IOObjectRelease)(mach_port_t object) = dlsym(IOKit, "IOObjectRelease");
        
        if (kIOMasterPortDefault && IOServiceGetMatchingService && IORegistryEntryCreateCFProperty && IOObjectRelease)
        {
            mach_port_t platformExpertDevice = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
            if (platformExpertDevice)
            {
                CFTypeRef platformSerialNumber = IORegistryEntryCreateCFProperty(platformExpertDevice, CFSTR("IOPlatformSerialNumber"), kCFAllocatorDefault, 0);
                if (platformSerialNumber && CFGetTypeID(platformSerialNumber) == CFStringGetTypeID())
                {
                    serialNumber = [NSString stringWithString:(__bridge NSString *)platformSerialNumber];
                    CFRelease(platformSerialNumber);
                }
                IOObjectRelease(platformExpertDevice);
            }
        }
        dlclose(IOKit);
    }
    NSLog(@"Serial number::%@", serialNumber);
    return serialNumber;
}


- (IBAction)sliderValueChangedOne:(id)sender
{
    // Set the label text to the value of the slider as it changes
    //   self.label.text = [NSString stringWithFormat:@"%f", self.slider.value];
    
    if (self.moodSlider.value > 15 && self.moodSlider.value < 60) {
        self.moodSlider.value = 45;
        
        
      
        moodName = @"Serious";
        moodID = @"2";
       
        
        _funLabel.textColor =[UIColor lightGrayColor];
        _seriousLabel.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
        _generalLabel.textColor = [UIColor lightGrayColor];
    }
    
    else if (self.moodSlider.value > 55 && self.moodSlider.value < 100) {
        
      
        moodName = @"General";
        moodID = @"3";
       
        self.moodSlider.value = 100;
        _funLabel.textColor =[UIColor lightGrayColor];
        _seriousLabel.textColor = [UIColor lightGrayColor];
        _generalLabel.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];

    }
    
    else if (self.moodSlider.value < 35) {
        self.moodSlider.value = 0;
        
       
        moodName = @"FUN";
        moodID = @"1";
        
        
        _funLabel.textColor =[UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
        _seriousLabel.textColor = [UIColor lightGrayColor];
        _generalLabel.textColor = [UIColor lightGrayColor];
        

    }
     NSLog(@"%f",self.moodSlider.value);
    
    
 
    
}

- (IBAction)sliderValueChangedTwo:(id)sender
{
    // Set the label text to the value of the slider as it changes
    //   self.label.text = [NSString stringWithFormat:@"%f", self.slider.value];
    
    if (self.genderSlider.value > 30 ) {
        self.genderSlider.value = 100;
        genderID = @"2";
       
        
        _maleLabel.textColor = [UIColor lightGrayColor];
        _femaleLabel.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];

    }
    
    else if (self.genderSlider.value <80 ) {
        self.genderSlider.value = 0;
        genderID = @"1";
      
        
        _femaleLabel.textColor = [UIColor lightGrayColor];
        _maleLabel.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
        

    }

    
     NSLog(@"%f",self.genderSlider.value);
}


- (IBAction)sliderValueChangedThree:(id)sender
{
    // Set the label text to the value of the slider as it changes
    //   self.label.text = [NSString stringWithFormat:@"%f", self.slider.value];
    
    if (self.ageSlider.value > 10 && self.ageSlider.value < 40) {
        self.ageSlider.value = 35;
        
     
        ageRangeID = @"2";
        
        
        _lessThanTwenty.textColor = [UIColor lightGrayColor];
        _twentyOnwToThirty.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
        _thirtyToFourty.textColor = [UIColor lightGrayColor];
        _greaterThanFourty.textColor = [UIColor lightGrayColor];
    }
    
    else if (self.ageSlider.value > 40 && self.ageSlider.value < 80) {
        self.ageSlider.value = 75;
        
        ageRangeID = @"3";

        
        _lessThanTwenty.textColor = [UIColor lightGrayColor];
        _twentyOnwToThirty.textColor = [UIColor lightGrayColor];
        _thirtyToFourty.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
        _greaterThanFourty.textColor = [UIColor lightGrayColor];
    }
    
    else if (self.ageSlider.value < 20) {
        self.ageSlider.value = 1;
        
        
        ageRangeID = @"1";
        
        _lessThanTwenty.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
        _twentyOnwToThirty.textColor = [UIColor lightGrayColor];
        _thirtyToFourty.textColor = [UIColor lightGrayColor];
        _greaterThanFourty.textColor = [UIColor lightGrayColor];
    }
    
    else if (self.ageSlider.value > 80) {
        self.ageSlider.value = 100;
        ageRangeID = @"4";

        
        _lessThanTwenty.textColor = [UIColor lightGrayColor];
        _twentyOnwToThirty.textColor = [UIColor lightGrayColor];
        _thirtyToFourty.textColor = [UIColor lightGrayColor];
        _greaterThanFourty.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
    }
    
    
    NSLog(@"%f",self.ageSlider.value);
}






- (IBAction)moodButtonOne:(id)sender {
    
     self.moodSlider.value = 0;
    
  
    moodName = @"Fun";
    moodID = @"1";
    
    
    _funLabel.textColor =[UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
    _seriousLabel.textColor = [UIColor lightGrayColor];
    _generalLabel.textColor = [UIColor lightGrayColor];
    
    
}

- (IBAction)moodButtonTwo:(id)sender {
     self.moodSlider.value = 45;
    moodName = @"Serious";
    moodID = @"2";
    
    
    _funLabel.textColor =[UIColor lightGrayColor];
    _seriousLabel.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
    _generalLabel.textColor = [UIColor lightGrayColor];
}
- (IBAction)moodButtonThree:(id)sender {
     self.moodSlider.value = 100;
    
    
    moodName = @"General";
    moodID = @"3";
   
    _funLabel.textColor =[UIColor lightGrayColor];
    _seriousLabel.textColor = [UIColor lightGrayColor];
    _generalLabel.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
}

- (IBAction)maleButton:(id)sender {
    
     self.genderSlider.value = 0;
    
    genderID = @"1";
  
    
    _femaleLabel.textColor = [UIColor lightGrayColor];
    _maleLabel.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
    
    
}
- (IBAction)femaleButton:(id)sender {
    genderID = @"2";
   
     self.genderSlider.value = 100;
    
    _maleLabel.textColor = [UIColor lightGrayColor];
    _femaleLabel.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
}

- (IBAction)ageButtonOne:(id)sender {
    
    
  
    ageRangeID = @"1";
      self.ageSlider.value = 0;
    
    _lessThanTwenty.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
    _twentyOnwToThirty.textColor = [UIColor lightGrayColor];
    _thirtyToFourty.textColor = [UIColor lightGrayColor];
    _greaterThanFourty.textColor = [UIColor lightGrayColor];
}

- (IBAction)ageButtonTwo:(id)sender {
    ageRangeID = @"2";
      self.ageSlider.value = 35;
    _lessThanTwenty.textColor = [UIColor lightGrayColor];
    _twentyOnwToThirty.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
    _thirtyToFourty.textColor = [UIColor lightGrayColor];
    _greaterThanFourty.textColor = [UIColor lightGrayColor];
}

- (IBAction)ageButtonThree:(id)sender {
    ageRangeID = @"3";
     self.ageSlider.value = 75;
    
    _lessThanTwenty.textColor = [UIColor lightGrayColor];
    _twentyOnwToThirty.textColor = [UIColor lightGrayColor];
    _thirtyToFourty.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];
    _greaterThanFourty.textColor = [UIColor lightGrayColor];
}

- (IBAction)ageButtonFour:(id)sender {
    ageRangeID = @"4";
    self.ageSlider.value = 100;
    _lessThanTwenty.textColor = [UIColor lightGrayColor];
    _twentyOnwToThirty.textColor = [UIColor lightGrayColor];
    _thirtyToFourty.textColor = [UIColor lightGrayColor];
    _greaterThanFourty.textColor = [UIColor colorWithRed:(232/255.f) green:(22/255.f) blue:(42/255.f) alpha:1.0f];

    
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




- (IBAction)reenterEmailButton:(id)sender {
    
    
    NSString *base64String;
    
    
    if (chosenImage == nil || [chosenImage isEqual:nil]) {
        base64String = @""
        ;    }
    
    else{
        
        
        
        
        base64String = [UIImagePNGRepresentation([self compressForUpload:chosenImage scale:1.0f])
                        base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        
//        
//        base64String = [base64String stringByReplacingOccurrencesOfString:@"/"
//                                                                           withString:@"_"];
//        
//        base64String = [base64String stringByReplacingOccurrencesOfString:@"+"
//                                                                           withString:@"-"];
        
    }
    
    
    
    UIDevice *device = [UIDevice currentDevice];
    
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSString*emaillll = _emailText.text;
    BOOL emailVal = [emailTest evaluateWithObject:emaillll];
    
    
    if ([_emailText.text length]==0 || emailVal == NO || ![_emailText.text isEqual:_reenterEmailText.text]) {
        NSString* errorMsg = @"Please enter valid Email address !";
        [self showToast:errorMsg];

    }
    
    else{
        
        
    
        BOOL interNetCheck=[WebServiceUrl InternetCheck];
        if (interNetCheck==YES ) {
            
            
            UIView *newView = [[UIView alloc]init];
            newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:newView];
            
            [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
            
            
            
            NSDictionary *jsonDictionary =@{
                                            @"info":
                                                @{  @"UserName":_nameText.text,
                                                    @"DisplayName":_nameText.text,
                                                    @"OwnNumber":_phoneNum,
                                                    @"GenderId":[NSNumber numberWithInteger:[genderID integerValue]],
                                                    @"EmailId":_emailText.text,
                                                    @"Status":moodName,
                                                    @"AgeRangeId":[NSNumber numberWithInteger:[ageRangeID integerValue]],
                                                    @"StatusId":moodID,
                                                    @"CountryCode":_countrytCode,
                                                    @"SerialNum":currentDeviceId,
                                                    @"ComId":[[NSUserDefaults standardUserDefaults] valueForKey:@"NSUserDefault_DeviceToken"],
                                                    @"OSVersion":[NSNumber numberWithInteger:2]
                                                    },
                                            
                                            @"resourceInfo":base64String
                                                
                                            };
            
    
            NSError *error;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                
                                                               options:0
                                
                                                                 error:&error];
            
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON OUTPUT: %@",JSONString);
            
            NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/adduser"]];
            
            
            
            [requestPost setHTTPMethod:@"POST"];
            
            
            
            [requestPost setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
            
            
            
            NSData *requestData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            [requestPost setHTTPBody: requestData];
            
            //  [requestPost addValue:@"hhhffftttuuu" forHTTPHeaderField:@"Value"];
            
            
            [requestPost addValue:@"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJSYW5kb21TdHJpbmciOiJmZzQ1MzI2NTIifQ.U9pF7MOmecW56BSPwM1BttloO4gUoMnEeHU3A290NWc" forHTTPHeaderField:@"hjtyu34"];
            
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
                            
                            
                            NSLog(@"%@",dic);
                            
                            
                            [[NSUserDefaults standardUserDefaults] setObject:[dic valueForKey:@"AddUserResult"] forKey:@"tokenVal"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            
                            
                            [GMDCircleLoader hideFromView:newView animated:YES];
                            [newView removeFromSuperview];
                            
                            [[NSUserDefaults standardUserDefaults]setObject:@"Existing" forKey:@"Existing"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            homeViewController *myVC = (homeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
                            
                            [self.navigationController pushViewController:myVC animated:YES];
                            
                            
                            
                            
                            
                            
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




@end
