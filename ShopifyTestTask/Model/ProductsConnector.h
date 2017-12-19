//
//  Connector.h
//  Shopify Test Task
//
//  Created by SS D on 2017-12-17.
//  Copyright © 2017 SS D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface ProductsConnector : NSObject
@property (readonly) NSArray <Product *> * _Nullable products;

-(void) requestProductsWithError: ( NSError * _Nullable ) error;
+(NSString *_Nonnull)responseReceived;

@end
