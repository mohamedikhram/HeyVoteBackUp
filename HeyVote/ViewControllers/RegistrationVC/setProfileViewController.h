//
//  setProfileViewController.h
//  HeyVote
//
//  Created by Ikhram khan on 03/05/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface setProfileViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *moodView;
@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) IBOutlet UIView *ageRangeView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollableView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *opaqueView;
@property (weak, nonatomic) IBOutlet UIView *reenterEmailView;
@property (weak, nonatomic) IBOutlet UITextField *reenterEmailText;
- (IBAction)reenterEmailButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *funLabel;
@property (weak, nonatomic) IBOutlet UILabel *seriousLabel;
@property (weak, nonatomic) IBOutlet UILabel *generalLabel;
@property (weak, nonatomic) IBOutlet UILabel *maleLabel;
@property (weak, nonatomic) IBOutlet UILabel *femaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lessThanTwenty;
@property (weak, nonatomic) IBOutlet UILabel *twentyOnwToThirty;
@property (weak, nonatomic) IBOutlet UILabel *thirtyToFourty;
@property (weak, nonatomic) IBOutlet UILabel *greaterThanFourty;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
- (IBAction)finishedButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *moodSlider;
@property (weak, nonatomic) IBOutlet UISlider *genderSlider;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
- (IBAction)moodButtonOne:(id)sender;
- (IBAction)moodButtonTwo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *moodButtonThree;
@property (strong, nonatomic) IBOutlet NSString *phoneNum;
@property (strong, nonatomic) IBOutlet NSString *countrytCode;
- (IBAction)moodButtonThree:(id)sender;
- (IBAction)maleButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
- (IBAction)femaleButton:(id)sender;
- (IBAction)ageButtonOne:(id)sender;
- (IBAction)ageButtonTwo:(id)sender;
- (IBAction)ageButtonThree:(id)sender;
- (IBAction)ageButtonFour:(id)sender;

@end
