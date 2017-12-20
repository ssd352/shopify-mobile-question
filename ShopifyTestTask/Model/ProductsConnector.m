//
//  Connector.m
//  Shopify Test Task
//
//  Created by SS D on 2017-12-17.
//  Copyright © 2017 SS D. All rights reserved.
//

#import "ProductsConnector.h"

static NSString *const PRODUCTS_URL = @"https://shopicruit.myshopify.com/admin/products.json?page=%@&title=%@&access_token=c32313df0d0ef512ca64d5b336a0d7c6";
static NSString *const RESPONSE_RECEIVED = @"rr";


@interface ProductsConnector ()

//@property NSURLSession * urlSession;
@property NSDictionary * result;
@property NSArray <Product *> * products;
@property NSURLSession *sessionWithoutADelegate;
//@property Product * product;
-(void) fillProducts;

@end


@implementation ProductsConnector


+(NSString *)responseReceived{
    return RESPONSE_RECEIVED;
}


-(void) fillProducts{
    NSMutableArray * tmp = [[NSMutableArray alloc]init];
//    NSLog(@"Result is %@", self.result[@"products"][0][@"title"]);
    NSArray * arr = (NSArray *)self.result[@"products"];
//    if (arr.count == 0){
//        self.products = [tmp copy];
//        return;
//    }
    for (id item in arr) {
        Product * product = [[Product alloc]init];
        product.productId = item[@"id"];
        product.title = item[@"title"];
        product.vendor = item[@"vendor"];
        product.bodyHtml = item[@"body_html"];
        product.productType = item[@"product_type"];
        
        product.productDescription = [NSString stringWithFormat:@"%@\n%@", item[@"product_type"], item[@"vendor"] ];
        // [[Product alloc] initWithTitle:item[@"title"] andDescription:[NSString stringWithFormat:@"%@\n%@", item[@"product_type"], item[@"vendor"] ] ];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        
        NSDate *date = [dateFormat dateFromString:item[@"created_at"]];
        product.createdAt =  [date copy];
        
        date = [dateFormat dateFromString:item[@"published_at"]];
        product.publishedAt =  [date copy];
//        completionHandler(product, error);
        
        if (item[@"images"]){
            if (((NSArray *)item[@"images"]).count > 0){
                
                NSURLSessionDownloadTask* downloadTask = [self.sessionWithoutADelegate downloadTaskWithURL:[NSURL URLWithString: item[@"images"][0][@"src"]] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    product.image = [NSData dataWithContentsOfURL:location];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:RESPONSE_RECEIVED object:nil userInfo:nil];
                }];
                [downloadTask resume];
//                [self.sessionWithoutADelegate finishTasksAndInvalidate];
            }
        }
        [tmp addObject:product];
    }
    self.products = [tmp copy];
}


-(void) requestProductsWithFilter:(NSString *)filter andError: ( NSError * _Nullable ) error{
//    [self sendRequestForPage:@(1) error:nil];
    [self sendRequestForPage:@(1) withFilter:filter andError:nil];
}


-(void)sendRequestForPage: (NSNumber *) page withFilter:(NSString *) filter andError:( NSError * _Nullable ) error{
    self.sessionWithoutADelegate = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
//    self.sessionWithoutADelegate.delegate
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PRODUCTS_URL, page, filter]];

    NSURLSessionDataTask * sessionDataTask = [self.sessionWithoutADelegate dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        self.result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [self fillProducts];
//        [[NSNotificationCenter defaultCenter] postNotificationName:RESPONSE_RECEIVED object:nil userInfo:nil];
        
    }];
    
    [sessionDataTask resume];
    [self.sessionWithoutADelegate finishTasksAndInvalidate];
    
}

-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:RESPONSE_RECEIVED object:nil userInfo:nil];
}
@end
