//
//  contactsViewCell.h
//  HeyVote
//
//  Created by Ikhram khan on 28/04/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contactsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;

@end
