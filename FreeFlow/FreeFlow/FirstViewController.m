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

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.rateTextView setDelegate:self];
    [self.factorTextView setDelegate:self];
    
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)calculateRate {
    
    if (self.rateTextView.text && self.factorTextView.text != nil) {
        NSLog(@"It's Calculating Time!");
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
