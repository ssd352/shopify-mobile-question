//
//  Product.h
//  Shopify Test Task
//
//  Created by SS D on 2017-12-17.
//  Copyright © 2017 SS D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property NSString * productId;
@property NSString * title;
@property NSString * productDescription;
@property NSData * image;
@property NSDate * createdAt;
@property NSDate * publishedAt;
-(instancetype)initWithTitle:(NSString*) title andDescription:(NSString *) description;
@end
