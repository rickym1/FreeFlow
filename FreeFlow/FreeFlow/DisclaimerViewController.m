//
//  DisclaimerViewController.m
//  FreeFlow
//
//  Created by rick m on 8/21/15.
//  Copyright (c) 2015 FreeFlowAppDevelopers. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL boxUnChecked;

@end

@implementation DisclaimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        
    self.boxUnChecked = YES;
    
}

- (IBAction)checkBoxPressed:(UIButton *)sender {
    
    UIButton *btn = sender;
    if (self.boxUnChecked == YES) {
        [btn setImage:[UIImage imageNamed:@"checkeds.png"] forState:UIControlStateNormal];
        self.boxUnChecked = NO;
    } else {
        [btn setImage:[UIImage imageNamed:@"uncheckeds.png"] forState:UIControlStateNormal];
        self.boxUnChecked = YES;
    }
    
}

- (IBAction)acknowledgePressed:(UIButton *)sender {
    
    if (self.boxUnChecked == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
