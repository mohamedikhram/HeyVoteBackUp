//
//  MobileRegistrationVC.h
//  HeyVote
//
//  Created by Ikhram Khan on 5/1/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@interface MobileRegistrationVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberText;
- (IBAction)continueButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *enterOTPView;
@property (weak, nonatomic) IBOutlet UITextField *enterOTPtext;
- (IBAction)continueOTPbutton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *opaqueView;
@property (weak, nonatomic) IBOutlet UIView *termsConditionsView;
@property (weak, nonatomic) IBOutlet UIScrollView *termsScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainScrollableView;
- (IBAction)declineButton:(id)sender;
- (IBAction)agreeButton:(id)sender;

@end
