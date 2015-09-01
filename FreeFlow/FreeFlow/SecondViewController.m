//
//  SecondViewController.m
//  FreeFlow
//
//  Created by rick m on 8/20/15.
//  Copyright (c) 2015 FreeFlowAppDevelopers. All rights reserved.
//

#import "SecondViewController.h"


@interface SecondViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UITextField *volumeTextField;
@property (weak, nonatomic) IBOutlet UITextField *dripFactorTextField;

@property (nonatomic, assign) NSUInteger tapCount;
@property (nonatomic, assign) CGFloat intervalAvg;
@property (nonatomic, strong) NSMutableArray *tapTimes;
@property (nonatomic, assign) CFTimeInterval timeOfLastTouch;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tapTimes = [NSMutableArray array];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.tapCount = 0;
    [self.tapTimes removeAllObjects];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    self.tapCount = [touch tapCount];
    
    
    if (self.tapTimes.count < 1) {
        self.timeOfLastTouch = CACurrentMediaTime();
    } else {
        NSTimeInterval timeDifference = CACurrentMediaTime() - self.timeOfLastTouch;
        self.timeOfLastTouch = CACurrentMediaTime();
        [self.tapTimes addObject:@(timeDifference)];
    }
    
    
    
}
- (IBAction)dripFactorTextField:(UITextField *)sender {
    
    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    if (enteredNumber == 0) {
        sender.text = nil;
    }
    self.dripFactorTextField.text = enteredText;
}

- (IBAction)volumeTextField:(UITextField *)sender {
    
    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    if (enteredNumber == 0) {
        sender.text = nil;
    }
    self.volumeTextField.text = enteredText;
    
}

- (IBAction)calculatePressed:(UIButton *)sender {
    
    if (self.tapCount < 2) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"At least two taps are required in order to calculate rate." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        [self resetPressed:nil];
        
        return;
    }
    
    if (self.tapCount == 2) {
        [self performSelector:@selector(tappedTwice) withObject:nil];
    }
    if (self.tapCount == 3) {
        [self performSelector:@selector(tappedThreeTimes) withObject:nil];
    }
    if (self.tapCount == 4) {
        [self performSelector:@selector(tappedFourTimes) withObject:nil];
    }
    if (self.tapCount >= 5) {
        [self performSelector:@selector(tappedFiveTimes) withObject:nil];
    }
    
    
    CGFloat dripFactor = [self.dripFactorTextField.text floatValue];
    CGFloat volume = [self.volumeTextField.text floatValue];
    
    CGFloat dropPerSec = 1 / self.intervalAvg;
    CGFloat mlPerSec = dropPerSec / dripFactor;
    CGFloat finalRate = mlPerSec * 3600;
    
    NSString *rateString = [NSString stringWithFormat:@"%.2f ml/hr", finalRate];
    self.rateLabel.text = rateString;
    
    CGFloat hoursExpire = volume / finalRate;
    CGFloat minutesExpire = hoursExpire * 60;
    
    NSString *expireString = [NSString stringWithFormat:@"Volume will expire in approximately %.2f minutes", minutesExpire];
    self.expireLabel.text = expireString;
    
    
    
    [self resetPressed:nil];
    
}

- (void)tappedTwice {
    
    self.intervalAvg = [self.tapTimes[0] doubleValue];
    
}

- (void)tappedThreeTimes {
    
    self.intervalAvg = ([self.tapTimes[0] doubleValue] + [self.tapTimes[1] doubleValue]) / 2.0;
    
}

- (void)tappedFourTimes {
    
    CGFloat differenceOne = fabs([self.tapTimes[1] doubleValue] - [self.tapTimes[0] doubleValue]);
    CGFloat differenceTwo = fabs([self.tapTimes[2] doubleValue] - [self.tapTimes[1] doubleValue]);
    CGFloat differenceThree = fabs([self.tapTimes[0] doubleValue] - [self.tapTimes[2] doubleValue]);
    
    if (differenceOne <= differenceTwo && differenceOne <= differenceThree) {
        self.intervalAvg = ([self.tapTimes[0] doubleValue] + [self.tapTimes[1] doubleValue]) / 2.0;
    }
    if (differenceTwo <= differenceOne && differenceTwo <= differenceThree) {
        self.intervalAvg = ([self.tapTimes[1] doubleValue] + [self.tapTimes[2] doubleValue]) / 2.0;
    }
    if (differenceThree <= differenceOne && differenceThree <= differenceTwo) {
        self.intervalAvg = ([self.tapTimes[2] doubleValue] + [self.tapTimes[0] doubleValue]) / 2.0;

    }
    
}

- (void)tappedFiveTimes {
    
}

- (IBAction)resetPressed:(UIButton *)sender {
    
    self.tapCount = 0;
    [self.tapTimes removeAllObjects];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
