//
//  DisclaimerViewController.m
//  FreeFlow
//
//  Created by rick m on 8/21/15.
//  Copyright (c) 2015 FreeFlowAppDevelopers. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController () <UIGestureRecognizerDelegate>

@end

@implementation DisclaimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acknowledgeTap:)];
    [self.view addGestureRecognizer:singleTap];
    
}

- (void)acknowledgeTap: (UITapGestureRecognizer *)recognizer {
    
    [self performSegueWithIdentifier:@"acknowledgeShow" sender:nil];
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
