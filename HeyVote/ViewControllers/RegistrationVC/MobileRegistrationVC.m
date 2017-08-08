//
//  MobileRegistrationVC.m
//  HeyVote
//
//  Created by Ikhram Khan on 5/1/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "MobileRegistrationVC.h"
#import "GMDCircleLoader.h"
#import "UIView+Toast.h"
#import "setProfileViewController.h"
#import "WebServiceUrl.h"

#import <QuartzCore/QuartzCore.h>
#import "homeViewController.h"

@interface MobileRegistrationVC (){
    
    
    NSString*OTPvalue;
    NSString * OTPid;
}

@end

@implementation MobileRegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    
  //  [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
  //  [GMDCircleLoader hideFromView:self.view animated:YES];
  
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
//    NSString *countryIdentifier = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
  //  NSString * diallingCode = [NSString stringWithFormat:@"+%@",[[self getCountryCodeDictionary] objectForKey:countryIdentifier]];
    
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:123456"]])
        {
            
            
    
    NSString * diallingCode = [NSString stringWithFormat:@"+%@",[self getCountryDialingCode]];
 
    
    
    _countryCodeLabel.text = diallingCode;
            
        }
        
        else{
            
            [self showToast:@"You need a working sim network"];
        }
    }
    
    [_enterOTPView setHidden:YES];
    [_opaqueView setHidden:YES];
    [_termsConditionsView setHidden:YES];
    
}


-(NSString*)getCountryDialingCode {
    
    
    NSDictionary *dialingCodes = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  @"972", @"IL",
                                  @"93", @"AF",
                                  @"355", @"AL",
                                  @"213", @"DZ",
                                  @"1", @"AS",
                                  @"376", @"AD",
                                  @"244", @"AO",
                                  @"1", @"AI",
                                  @"1", @"AG",
                                  @"54", @"AR",
                                  @"374", @"AM",
                                  @"297", @"AW",
                                  @"61", @"AU",
                                  @"43", @"AT",
                                  @"994", @"AZ",
                                  @"1", @"BS",
                                  @"973", @"BH",
                                  @"880", @"BD",
                                  @"1", @"BB",
                                  @"375", @"BY",
                                  @"32", @"BE",
                                  @"501", @"BZ",
                                  @"229", @"BJ",
                                  @"1", @"BM", @"975", @"BT",
                                  @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                                  @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                                  @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                                  @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                                  @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                                  @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                                  @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                                  @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                                  @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                                  @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                                  @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                                  @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                                  @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                                  @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                                  @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                                  @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                                  @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                                  @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                                  @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                                  @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                                  @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                                  @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                                  @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                                  @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                                  @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                                  @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                                  @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                                  @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                                  @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                                  @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                                  @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                                  @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                                  @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                                  @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                                  @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                                  @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                                  @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                                  @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                                  @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                                  @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                                  @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                                  @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                                  @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                                  @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                                  @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                                  @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                                  @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                                  @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                                  @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                                  @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                                  @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                                  @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963",
                                  @"SY",@"886",
                                  @"TW", @"255",
                                  @"TZ", @"670",
                                  @"TL",@"58",
                                  @"VE",@"84",
                                  @"VN",
                                  @"284", @"VG",
                                  @"340", @"VI",
                                  @"678",@"VU",
                                  @"681",@"WF",
                                  @"685",@"WS",
                                  @"967",@"YE",
                                  @"262",@"YT",
                                  @"27",@"ZA",
                                  @"260",@"ZM",
                                  @"263",@"ZW",
                                  nil];
    
    
    
    CTTelephonyNetworkInfo *network_Info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = network_Info.subscriberCellularProvider;
    
    NSString *icc = [dialingCodes objectForKey:[carrier.isoCountryCode uppercaseString]];
    
    return icc;
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.termsScrollView setScrollEnabled:YES];
    self.termsScrollView.contentSize=CGSizeMake(self.mainScrollableView.bounds.size.width,self.mainScrollableView.bounds.size.height);
    
}



- (NSDictionary *)getCountryCodeDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
            @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
            @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
            @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
            @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
            @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
            @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
            @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
            @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
            @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
            @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
            @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
            @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
            @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
            @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
            @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
            @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
            @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
            @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
            @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
            @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
            @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
            @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
            @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
            @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
            @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
            @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
            @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
            @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
            @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
            @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
            @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
            @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
            @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
            @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
            @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
            @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
            @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
            @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
            @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
            @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
            @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
            @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
            @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
            @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
            @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
            @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
            @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
            @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
            @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
            @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
            @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
            @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
            @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
            @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
            @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
            @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
            @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
            @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
            @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
            @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegates

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
    
   
        [self validateMobileNumber:_mobileNumberText.text];
     
  }

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
 
    return YES;
}

//---------------------------- mobile number validation ---------------------------------------------//
-(NSString*)validateMobileNumber:(NSString*)mobileNumber
{
    NSString *errorMsg=@"";
    
 
//    NSString *phoneRegex = @"[123456789][0-9]{9}";
//    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    
    

    NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],.<>?\\/\"\'";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                           characterSetWithCharactersInString:specialCharacterString];
    
    if ([mobileNumber.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length) {
        errorMsg = @"Enter a Valid Mobile Number";
        [self showToast:errorMsg];
    }
    

    return errorMsg;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
    {
        
        if (textField == _enterOTPtext) {
            if (self.enterOTPtext.text.length > 4 && range.length == 0)
            {
                return NO; // return NO to not change text
            }
            else
            {return YES;}
        }
        
       
        
       if ([_countryCodeLabel.text isEqualToString:@"+974"]) {
            if (_mobileNumberText.text.length > 7 && range.length == 0)
            {
                
                
                return NO; // return NO to not change text
            }
            else
            {
                
                return YES;
                
            }

        }
        
        
        
        else{
            
            if (_mobileNumberText.text.length > 9 && range.length == 0)
            {
                return NO; // return NO to not change text
            }
            else
            {
                
                return YES;
                
            }

        }
        
  
        
     }




-(void)showToast:(NSString*)msg{
    
    [self.view makeToast:msg
                duration:1.0
                position:CSToastPositionCenter];
}

- (IBAction)continueButton:(id)sender {
    [_mobileNumberText resignFirstResponder];
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:123456"]])
        {
            NSLog(@"Device can make call or send message");
            
            if ([_mobileNumberText.text length]==0) {
                
                NSString* errorMsg = @"Enter your Mobile Number";
                [self showToast:errorMsg];
                
                
            }
            
            else  if([[self validateMobileNumber:_mobileNumberText.text] isEqualToString:@""]){
                
                
                [self callWebService];
                
                
             
                
                
            }
        

 
            
        }
        else
        {
            NSLog(@"Device can not make call or send message");
            NSString* errorMsg = @"Invalid Sim";
            [self showToast:errorMsg];
            
            
        }
    }

    
    
    

    
    
}



-(void)callWebService{
 
 
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
       if (interNetCheck==YES ) {
    
    UIView *newView = [[UIView alloc]init];
            newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:newView];
    
            [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
    
    
    NSDictionary *jsonDictionary =@{ @"countryCode":_countryCodeLabel.text,
                                                                                  @"number":_mobileNumberText.text,
                                                                                 @"isVerified":@"false"
                                     
                                                                                 };

    
    
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                        
                                                       options:0
                        
                                                         error:&error];
    
    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON OUTPUT: %@",JSONString);
    
    NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/CheckIfUserExists"]];
    
    
    
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
                    
                    
                    
                    
                    
                                               [GMDCircleLoader hideFromView:newView animated:YES];
                                                [newView removeFromSuperview];
                    
                    
                    
                    if ([[[[dic valueForKey:@"CheckIfUserExistsResult"] valueForKey:@"isExisting"] stringValue] isEqualToString:@"0"]) {
                        [_opaqueView setHidden:NO];
                        [_termsConditionsView setHidden:NO];
                        
                    }
                    
                    else{
                        
                        [_enterOTPView setHidden:NO];
                        
                      
                        OTPid = [[dic valueForKey:@"CheckIfUserExistsResult"] valueForKey:@"otpId"];
                        
                        NSString* errorMsg = @"Check your registered EmailID for OTP";
                        [self showToast:errorMsg];
                    }
                    
                    
                    
                    
                    
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






-(void)callWebServiceForDeviceId{
    
    
    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        
        NSDictionary *jsonDictionary =@{ @"osVersionId":[NSNumber numberWithInteger:2],
                                         @"comId":[[NSUserDefaults standardUserDefaults] valueForKey:@"NSUserDefault_DeviceToken"],
                                         @"isWeb":[NSNumber numberWithBool:0]
                                         
                                         
                                         };
        
        
        
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/UpdateComId"]];
        
        
        
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
           
                        NSLog(@"%@",dic);
                        
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



- (IBAction)continueOTPbutton:(id)sender {
    
    
    if ([_enterOTPtext.text length]==0) {
        
        NSString* errorMsg = @"Please enter your OTP";
        [self showToast:errorMsg];
        
    }
    
    else{
    

    BOOL interNetCheck=[WebServiceUrl InternetCheck];
    if (interNetCheck==YES ) {
        
        UIView *newView = [[UIView alloc]init];
        newView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:newView];
        
        [GMDCircleLoader setOnView:newView withTitle:@"Loading..." animated:YES];
        
        
        NSDictionary *jsonDictionary =@{ @"id":OTPid,
                                         @"isRegistered":@"true",
                                         @"otp":_enterOTPtext.text,
                                         @"isWeb":@"false"
                                         
                                         
                                         };
        
       
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            
                                                           options:0
                            
                                                             error:&error];
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        NSMutableURLRequest *requestPost =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.heyvote.com/WebServices/HeyVoteService.svc/user/ValidateOTP"]];
        
        
        
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
                        
                        NSString* errorMsg = @"Enter a valid OTP";
                        [self showToast:errorMsg];
                        
                        
                    }
                    else{
                        
                        
                        NSLog(@"%@",dic);
                        
                       
                        
                        
                        
                        
                        [[NSUserDefaults standardUserDefaults]setObject:@"Existing" forKey:@"Existing"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[dic valueForKey:@"ValidateOTPResult"] forKey:@"tokenVal"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                         [self callWebServiceForDeviceId];

               
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
- (IBAction)declineButton:(id)sender {
    [_opaqueView setHidden:YES];
     [_termsConditionsView setHidden:YES];
    
}

- (IBAction)agreeButton:(id)sender {
    
    [_opaqueView setHidden:YES];
    [_termsConditionsView setHidden:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    setProfileViewController *myVC = (setProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"setProfileViewController"];
    myVC.phoneNum = _mobileNumberText.text;
    myVC.countrytCode = _countryCodeLabel.text;
    
    [self.navigationController pushViewController:myVC animated:YES];

}



@end
