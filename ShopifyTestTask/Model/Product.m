//
//  Product.m
//  Shopify Test Task
//
//  Created by SS D on 2017-12-17.
//  Copyright © 2017 SS D. All rights reserved.
//

#import "Product.h"


@implementation Product


- (instancetype)init
{
    self = [super init];
    return self;
}


- (instancetype)initWithTitle:(NSString*) title andDescription:(NSString *) description
{
    self = [super init];
    if (self) {
        self.title = title;
        self.productDescription = description;
    }
    return self;
}


@end
