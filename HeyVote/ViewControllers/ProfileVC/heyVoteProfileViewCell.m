//
//  globalViewCell.m
//  HeyVote
//
//  Created by Ikhram Khan on 5/31/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "heyVoteProfileViewCell.h"

@implementation heyVoteProfileViewCell{
    
    CGRect screenRectios;
    CGFloat screenWidthios;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    screenRectios = [[UIScreen mainScreen] bounds];
    screenWidthios = screenRectios.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
    
    if (screenWidthios  == 320) {
        
        //
        //        [cell setLabelFrame:self.labelFloor.frame
        //                       unit:self.labelUnit.frame
        //                       type:self.labelType.frame
        //                       sqft:self.labelsqft.frame
        //                      price:self.labelPrice.frame
        //                     facing:self.labelFacing.frame
        //                       view:self.labelView.frame
        //                     status:self.labelStatus.frame
        //                labelHeight:labelHeight];
        //
        //        [cell layoutIfNeeded];
        
        _yesNoMainView.frame = CGRectMake(_yesNoMainView.frame.origin.x, _yesNoMainView.frame.origin.y, 320, 40);
        _yesNoNotDoneButtonView.frame = CGRectMake(0, 0, 320, 38);
        
        
        _yesNoButtonView.frame = CGRectMake(0, 0, 320, 38);
        
        _commentViewIcon.frame = CGRectMake(2, 1, 310, 31);
        _sendButton.frame = CGRectMake(273, -4, 37, 37);
        
        _leftButton.frame = CGRectMake(8, 3, 150, 33);
        _rightButton.frame = CGRectMake(162, 3, 150, 33);
        
        _leftResultButton.frame = CGRectMake(8, 3, 150, 33);
        _rightResultButton.frame = CGRectMake(162, 3, 150, 33);
        
        _voteLabelLeft.frame = CGRectMake(40, 19, 86, 12);
        _votesLabelRight.frame = CGRectMake(196, 19, 83, 12);
        
        
        
        
        
    }
    
    else{
        
        _yesNoMainView.frame = CGRectMake(_yesNoMainView.frame.origin.x, _yesNoMainView.frame.origin.y, _yesNoMainView.frame.size.width, _yesNoMainView.frame.size.height);
        _commentViewIcon.frame = CGRectMake(_commentViewIcon.frame.origin.x, _commentViewIcon.frame.origin.y, _commentViewIcon.frame.size.width, _commentViewIcon.frame.size.height);
        
    }
    
}



@end
