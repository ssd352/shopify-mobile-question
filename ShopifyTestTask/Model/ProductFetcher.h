//
//  ProductFetcher.h
//  ShopifyTestTask
//
//  Created by SS D on 2017-12-19.
//  Copyright © 2017 SS D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface ProductFetcher : NSObject


-(void)getProductDetailById:(NSString *)productId onCompletion:(void (^)(Product * _Nullable, NSError * _Nullable))completionHandler;


@end
