//
//  FirstViewController.m
//  FreeFlow
//
//  Created by rick m on 8/20/15.
//  Copyright (c) 2015 FreeFlowAppDevelopers. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UITextField *rateTextView;
@property (weak, nonatomic) IBOutlet UITextField *factorTextView;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabelView;

@property (nonatomic, assign) CGFloat dropsPerMinute;
@property (nonatomic, assign) BOOL normalBackground;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.rateTextView setDelegate:self];
    [self.factorTextView setDelegate:self];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.normalBackground = YES;
    
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

-(void) hideKeyboard {
    [self.view endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self calculateRate];
    [self playRate];
    
    
    return YES;
}

- (void)calculateRate {
    
    if (self.rateTextView.text.length > 0 && self.factorTextView.text.length > 0) {
        
        float rate = [self.rateTextView.text floatValue];
        float factor = [self.factorTextView.text floatValue];
        float dropsPerHour = rate * factor;
        float dropsPerSecond = dropsPerHour / 3600;
        self.dropsPerMinute = dropsPerHour / 60;
        float secondsPerDrop = 1 / dropsPerSecond;
        
        NSString *secondsString = [NSString stringWithFormat:@"= 1 drop every %.00f seconds", secondsPerDrop];
        self.secondsLabelView.text = secondsString;
        
    }
}


-(void)playRate {
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ting" ofType:@"caf"]];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        NSLog(@"Error in audioPlayer, %@", [error localizedDescription]);
    } else {
        _audioPlayer.delegate = self;
        [_audioPlayer play];
    }
    
    if (self.rateTextView.text.length > 0 && self.factorTextView.text.length > 0) {
        
        if (self.normalBackground) {
            self.view.backgroundColor = [UIColor whiteColor];
            self.normalBackground = NO;
        } else {
            self.view.backgroundColor = [UIColor colorWithRed:0x1B/255.0f green:0xB6/255.0f blue:0xFF/255.0f alpha:1];
            self.normalBackground = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSTimer scheduledTimerWithTimeInterval:(60/self.dropsPerMinute) target:self selector:@selector(playRate) userInfo:nil repeats:NO];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
