//
//  IAPHelper.h
//  dripcalculator
//
//  Created by rick m on 9/3/15.
//  Copyright (c) 2015 FreeFlowAppDevelopers. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

@end
