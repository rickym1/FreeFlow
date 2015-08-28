//
//  FirstViewController.h
//  FreeFlow
//
//  Created by rick m on 8/20/15.
//  Copyright (c) 2015 FreeFlowAppDevelopers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface FirstViewController : UIViewController <UITextFieldDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL readyToFlash;



@end

