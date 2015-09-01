//
//  FirstViewController.m
//  FreeFlow
//
//  Created by rick m on 8/20/15.
//  Copyright (c) 2015 FreeFlowAppDevelopers. All rights reserved.
//

#import "FirstViewController.h"
#import "DisclaimerViewController.h"

@interface FirstViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UITextField *rateTextView;
@property (weak, nonatomic) IBOutlet UITextField *factorTextView;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabelView;
@property (weak, nonatomic) IBOutlet UIButton *sound;

@property (nonatomic, assign) CGFloat dropsPerMinute;
@property (nonatomic, assign) BOOL normalBackground;
@property (nonatomic, assign) BOOL soundOff;
@property (nonatomic, assign) BOOL readyToFlash;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.rateTextView setDelegate:self];
    [self.factorTextView setDelegate:self];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stop)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.delegate = self;
    
    self.normalBackground = YES;
    self.soundOff = YES;
    self.readyToFlash = YES;
    
}

-(void) viewDidAppear:(BOOL)animated {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenTutorial"]) {
        [self displayDisclaimer];
    }
    
}

- (void) viewDidDisappear:(BOOL)animated {
    
    self.readyToFlash = NO;
    
}

- (void) displayDisclaimer {
    
    [self performSegueWithIdentifier:@"showDisclaimer" sender:self];
    
}

- (IBAction)rateTextFieldDidChange:(UITextField *)sender {
    
    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    if (enteredNumber == 0) {
        sender.text = nil;
    }
    self.rateTextView.text = enteredText;
    
}

- (IBAction)factorTextFieldDidChange:(UITextField *)sender {
    
    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    if (enteredNumber == 0) {
        sender.text = nil;
    }
    self.factorTextView.text = enteredText;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
    
}


- (IBAction)soundPressed:(UIButton *)sender {
    
    UIButton *btn = sender;
    
    if (self.soundOff == YES) {
        [btn setImage:[UIImage imageNamed:@"icon-sound-on.png"] forState:UIControlStateNormal];
        self.soundOff = NO;
    } else {
        [btn setImage:[UIImage imageNamed:@"icon-sound-off.png"] forState:UIControlStateNormal];
        self.soundOff = YES;
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    if (CGRectContainsPoint(self.sound.frame, [touch locationInView:self.view]))
    {
        return NO;
    }
    
    return YES;
}

-(void) stop {
    [self.view endEditing:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:0x1B/255.0f green:0xB6/255.0f blue:0xFF/255.0f alpha:1];
    self.normalBackground = YES;
    self.readyToFlash = NO;

    

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self calculateRate];
    self.readyToFlash = YES;
    
    if (self.readyToFlash == YES) {
        [self playRate];
    }
    
    
    return YES;
}

- (void)calculateRate {
    
    if (self.rateTextView.text.length > 0 && self.factorTextView.text.length > 0) {
        
        float rate = [self.rateTextView.text floatValue];
        float factor = [self.factorTextView.text floatValue];
        float dropsPerHour = rate * factor;
        float dropsPerSecond = dropsPerHour / 3600.0;
        self.dropsPerMinute = dropsPerHour / 60.0;
        float secondsPerDrop = 1 / dropsPerSecond;
        
        NSString *secondsString = [NSString stringWithFormat:@"= 1 drop every %.2f seconds", secondsPerDrop];
        self.secondsLabelView.text = secondsString;
        
    }
}


-(void)playRate {
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ping" ofType:@"caf"]];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        NSLog(@"Error in audioPlayer, %@", [error localizedDescription]);
    } else {
        _audioPlayer.delegate = self;
    }
    
    if (self.soundOff == NO) {
        [_audioPlayer play];
    }

    if (self.rateTextView.text.length > 0 && self.factorTextView.text.length > 0 && self.readyToFlash == YES) {
        
        self.view.layer.backgroundColor = [UIColor whiteColor].CGColor;
        
        if (self.dropsPerMinute < 833) {
            if (self.dropsPerMinute < 120) {
                if (self.dropsPerMinute < 61) {
                    [UIView animateWithDuration:0.9 animations:^{
                        self.view.layer.backgroundColor = [UIColor colorWithRed:0x1B/255.0f green:0xB6/255.0f blue:0xFF/255.0f alpha:1].CGColor;
                    } completion:^(BOOL finished) {
                    }];
                } else {
                    [UIView animateWithDuration:0.5 animations:^{
                        self.view.layer.backgroundColor = [UIColor colorWithRed:0x1B/255.0f green:0xB6/255.0f blue:0xFF/255.0f alpha:1].CGColor;
                    } completion:^(BOOL finished) {
                    }];
                }
            } else {
                [UIView animateWithDuration:0.05 animations:^{
                    self.view.layer.backgroundColor = [UIColor colorWithRed:0x1B/255.0f green:0xB6/255.0f blue:0xFF/255.0f alpha:1].CGColor;
                } completion:^(BOOL finished) {
                }];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSTimer scheduledTimerWithTimeInterval:(60/self.dropsPerMinute) target:self selector:@selector(playRate) userInfo:nil repeats:NO];
            });
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Such a high rate cannot be visualized accurately." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            self.view.backgroundColor = [UIColor colorWithRed:0x1B/255.0f green:0xB6/255.0f blue:0xFF/255.0f alpha:1];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
