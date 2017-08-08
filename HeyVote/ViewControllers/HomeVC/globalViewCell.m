//
//  globalViewCell.m
//  HeyVote
//
//  Created by Ikhram Khan on 5/31/16.
//  Copyright © 2016 AppCandles. All rights reserved.
//

#import "globalViewCell.h"

@implementation globalViewCell{
    
    CGRect screenRectios;
    CGFloat screenWidthios;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    screenRectios = [[UIScreen mainScreen] bounds];
    screenWidthios = screenRectios.size.width;
    
    
   // _videoplayer = [[AVPlayer alloc]init];
   // _playerLayer =[[AVPlayerLayer alloc]init];
    
    //_item = [[AVPlayerItem alloc]init];
   // _playerViewController =[[AVPlayerViewController alloc]init];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
//     [self.videoPreview setFrame:CGRectMake(self.videoPreview.frame.origin.x, self.videoPreview.frame.origin.y, self.videoPreview.frame.size.width,  self.videoPreview.frame.size.height)];
    
    
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





-(void)stopVideo{
    [self.videoplayer pause];
    
}

-(void)playVideo{
    [self.videoplayer play];
    
}

- (void) createPlayerWithURL:(NSURL*)url {
    //    AVAsset *asset = [AVAsset assetWithURL:url];
    //    self.item = [AVPlayerItem playerItemWithAsset:asset];
    //    self.videoplayer = [[AVPlayer alloc] initWithPlayerItem:self.item];
    //    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoplayer];
    //    [self.playerLayer setFrame:self.videoPreview.layer.bounds];
    //    [self.videoPreview.layer addSublayer:self.playerLayer];
    //    [self.videoplayer play];
    
    
    
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        
//        AVAsset *asset = [AVAsset assetWithURL:url];
//        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
//        CMTime time = CMTimeMake(1, 1);
//        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
//        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
//        //  CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
//        
//        [self.videoPreview setBackgroundColor:[UIColor colorWithPatternImage:thumbnail]];
//        

        
        self.item = [AVPlayerItem playerItemWithURL:url];
        
        
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            //                 if (cell.playerLayer.superlayer) {
            //                     [cell.playerLayer removeFromSuperlayer];
            //                     cell.videoplayer = nil ;
            //                     cell.item = nil;
            //                 }
            //
            self.videoplayer = [AVPlayer playerWithPlayerItem:self.item];
            
            
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoplayer];
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            // cell.videoplayer = [AVPlayer playerWithPlayerItem:cell.item];
            
            self.videoplayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            

            self.playerLayer.frame = self.videoPreview.bounds;
            [self.videoPreview.layer addSublayer:self.playerLayer];
            // [cell.videoPreview addSubview:cell.playerViewController.view];
            
     
                [self.videoplayer play];
          
           
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(playerItemDidReachEnd:)
                                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                                   object:[self.videoplayer currentItem]];
            
            
            
            
      
        });
    });
    
    
    
    
    
    
    
    
}





-(void)stopAudio{
    [self.audioplayer pause];
    
}

-(void)playAudio{
    [self.audioplayer play];
    
}

- (void) createPlayerWithURLForAudio:(NSURL*)url {

    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        self.itemAudio = [AVPlayerItem playerItemWithURL:url];
        
        
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            //                 if (cell.playerLayer.superlayer) {
            //                     [cell.playerLayer removeFromSuperlayer];
            //                     cell.videoplayer = nil ;
            //                     cell.item = nil;
            //                 }
            //
            self.audioplayer = [AVPlayer playerWithPlayerItem:self.itemAudio];
            
            
           self.playerLayerAudio = [AVPlayerLayer playerLayerWithPlayer:self.audioplayer];
            self.playerLayerAudio.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
            
            self.audioplayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            
         //   self.playerLayerAudio.frame = self.singleAudioPlayButton.bounds;
          //  [self.singleAudioPlayButton.layer addSublayer:self.playerLayer];
          
            [self.audioplayer play];
            
            
            
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(playerItemDidReachEnd:)
                                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                                   object:[self.audioplayer currentItem]];

            
        });
    });
    
    
    

    
    
    
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}




@end
