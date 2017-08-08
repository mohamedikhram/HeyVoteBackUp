//
//  profileDetailsViewController.h
//  HeyVote
//
//  Created by Ikhram Khan on 6/3/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextFieldLimit.h"

@interface profileDetailsViewController : UIViewController<UITextFieldDelegate,UITextFieldLimitDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *moodView;
@property (weak, nonatomic) IBOutlet UIView *moodUpdateView;
@property (weak, nonatomic) IBOutlet UILabel *funLabel;
@property (weak, nonatomic) IBOutlet UILabel *seriousLabel;
@property (weak, nonatomic) IBOutlet UILabel *generalLabel;
- (IBAction)updateButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *moodSlider;
@property (weak, nonatomic) IBOutlet UILabel *yourrank;
@property (weak, nonatomic) IBOutlet UILabel *yourViewLocal;
@property (weak, nonatomic) IBOutlet UILabel *yourViewGlobal;
@property (weak, nonatomic) IBOutlet UILabel *heyvotesTotal;
@property (weak, nonatomic) IBOutlet UILabel *followersTotal;
@property (weak, nonatomic) IBOutlet UILabel *followingTotal;
@property (weak, nonatomic) IBOutlet UITextFieldLimit *nameText;
@property (weak, nonatomic) IBOutlet UIButton *moodEditButton;
- (IBAction)moodEditButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *moodLabelText;
- (IBAction)sliderValue:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
- (IBAction)profileImageChabgeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *textFieldView;
- (IBAction)closeButton:(id)sender;
- (IBAction)followFollowersButton:(id)sender;

@end
