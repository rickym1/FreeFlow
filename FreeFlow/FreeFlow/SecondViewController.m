//
//  SecondViewController.m
//  FreeFlow
//
//  Created by rick m on 8/20/15.
//  Copyright (c) 2015 FreeFlowAppDevelopers. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController () <UIGestureRecognizerDelegate> {
    NSNumberFormatter * _priceFormatter;
}

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UITextField *volumeTextField;
@property (weak, nonatomic) IBOutlet UITextField *dripFactorTextField;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (nonatomic, assign) CGFloat intervalAvg;
@property (nonatomic, strong) NSMutableArray *tapTimes;
@property (nonatomic, assign) CFTimeInterval timeOfLastTouch;
@property (nonatomic, strong) SKProduct *product;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tapTimes = [NSMutableArray array];
    
    [[AnalyzerIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (products.count != 0) {
            self.product = products[0];
        }
        [_priceFormatter setLocale:self.product.priceLocale];
        //cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];
        
        
        if ([[AnalyzerIAPHelper sharedInstance] productPurchased:self.product.productIdentifier]) {
            self.calculateButton.enabled = NO;
        } else {
            self.calculateButton.enabled = YES;
        }

    }];
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    }

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"yo");
    [self resetPressed:nil];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self.volumeTextField isFirstResponder] || [self.dripFactorTextField isFirstResponder]) {
        return;
    }
    NSLog(@"hey");
    
    if (self.timeOfLastTouch == 0) {
        self.timeOfLastTouch = CACurrentMediaTime();
    } else {
        NSTimeInterval timeDifference = CACurrentMediaTime() - self.timeOfLastTouch;
        self.timeOfLastTouch = CACurrentMediaTime();
        [self.tapTimes addObject:@(timeDifference)];
    }
        
    self.view.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    [UIView animateWithDuration:0.05 animations:^{
        self.view.layer.backgroundColor = [UIColor colorWithRed:0x1B/255.0f green:0xB6/255.0f blue:0xFF/255.0f alpha:1].CGColor;
    } completion:^(BOOL finished) {
    }];
    
    if (self.tapTimes.count >= 3) {
        [self calculatePressed:nil];
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    if (CGRectContainsPoint(self.calculateButton.frame, [touch locationInView:self.view]))
    {
        return NO;
    }
    if (CGRectContainsPoint(self.resetButton.frame, [touch locationInView:self.view]))
    {
        return NO;
    }
    return YES;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)calculatePressed:(UIButton *)sender {
    
    if (self.tapTimes.count < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"At least two taps are required in order to calculate rate." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        [self resetPressed:nil];
        
        return;
    }
    
    if (self.tapTimes.count == 1) {
        [self tappedTwice];
    }
    if (self.tapTimes.count == 2) {
        [self tappedThreeTimes];
    }
    if (self.tapTimes.count >= 3) {
        [self tappedFourTimes];
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

- (IBAction)resetPressed:(UIButton *)sender {
    
    self.timeOfLastTouch = 0;
    [self.tapTimes removeAllObjects];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
