//
//  ProductDetailViewController.h
//  ShopifyTestTask
//
//  Created by SS D on 2017-12-18.
//  Copyright © 2017 SS D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductFetcher.h"

@interface ProductDetailViewController : UIViewController
@property NSString * productId;
@property ProductFetcher * fetcher;
@end
