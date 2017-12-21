//
//  ProductFetcher.m
//  ShopifyTestTask
//
//  Created by SS D on 2017-12-19.
//  Copyright © 2017 SS D. All rights reserved.
//

#import "ProductFetcher.h"
#import "Product.h"

static NSString *const PRODUCT_URL = @"https://shopicruit.myshopify.com/admin/products/%@.json?access_token=c32313df0d0ef512ca64d5b336a0d7c6";

@implementation ProductFetcher


-(void)getProductDetailById:(NSString *)productId onCompletion:(void (^)(Product * _Nullable, NSError * _Nullable))completionHandler{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PRODUCT_URL, productId]];
    Product * product = [[Product alloc] init];
    NSURLSession * sessionWithoutADelegate = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask * dataTask = [sessionWithoutADelegate dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data){
            NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil][@"product"];
            product.title = result[@"title"];
            product.vendor = result[@"vendor"];
            product.bodyHtml = result[@"body_html"];
            product.productType = result[@"product_type"];
            
            //        NSLog(@"Result is %@\nResponse is %@\nError is %@", result, response, error);
            product.productId = result[@"id"];
            NSLog(@"Title is %@ and id is %@", product.title, product.productId);
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
            
            NSDate *date = [dateFormat dateFromString:result[@"created_at"]];
            product.createdAt =  [date copy];
            
            date = [dateFormat dateFromString:result[@"published_at"]];
            product.publishedAt =  [date copy];
            completionHandler(product, error);
        }
        
    }];
    
    [dataTask resume];
}


-(Product *)getProductDetailById:(NSString *)productId withError:(NSError *)error{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PRODUCT_URL, productId]];
    Product * product = [[Product alloc] init];
    
    NSURLSession * sessionWithoutADelegate = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask * dataTask = [sessionWithoutADelegate dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        product.title = result[@"title"];
        product.productId = result[@"id"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"YYYY-MM-DDTHH:MM:SS";
        
        NSDate *date = [dateFormat dateFromString:result[@"created_at"]];
        product.createdAt =  [date copy];
        
        date = [dateFormat dateFromString:result[@"published_at"]];
        product.publishedAt =  [date copy];
        
    }];
    
    [dataTask resume];
    //    [self.sessionWithoutADelegate finishTasksAndInvalidate];
    return product;
}


@end
