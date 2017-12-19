//
//  Connector.m
//  Shopify Test Task
//
//  Created by SS D on 2017-12-17.
//  Copyright © 2017 SS D. All rights reserved.
//

#import "ProductsConnector.h"

static NSString *const PRODUCTS_URL = @"https://shopicruit.myshopify.com/admin/products.json?page=%@&access_token=c32313df0d0ef512ca64d5b336a0d7c6";
static NSString *const PRODUCT_URL = @"https://shopicruit.myshopify.com/admin/products/%@.json?access_token=c32313df0d0ef512ca64d5b336a0d7c6";
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionWithoutADelegate = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}


+(NSString *)responseReceived{
    return RESPONSE_RECEIVED;
}


-(void)getProductDetailById:(NSString *)productId onCompletion:(void (^)(Product * _Nullable, NSError * _Nullable))completionHandler{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PRODUCT_URL, productId]];
    Product * product = [[Product alloc] init];
    
    NSURLSessionDataTask * dataTask = [self.sessionWithoutADelegate dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil][@"product"];
        product.title = result[@"title"];
//        NSLog(@"Result is %@\nResponse is %@\nError is %@", result, response, error);
        product.productId = result[@"id"];
        NSLog(@"Title is %@ and id is %@", product.title, product.productId);
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"YYYY-MM-DDTHH:MM:SS";
        
        NSDate *date = [dateFormat dateFromString:result[@"created_at"]];
        product.createdAt =  [date copy];
        
        date = [dateFormat dateFromString:result[@"published_at"]];
        product.publishedAt =  [date copy];
        completionHandler(product, error);
        
    }];
    
    [dataTask resume];
}


-(Product *)getProductDetailById:(NSString *)productId withError:(NSError *)error{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PRODUCT_URL, productId]];
    Product * product = [[Product alloc] init];
    
    NSURLSessionDataTask * dataTask = [self.sessionWithoutADelegate dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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


-(void) fillProducts{
    NSMutableArray * tmp = [[NSMutableArray alloc]init];
    NSLog(@"Result is %@", self.result[@"products"][0][@"title"]);
    for (id item in self.result[@"products"]) {
        Product * product = [[Product alloc]init];
        product.productId = item[@"id"];
        product.title = item[@"title"];
        product.productDescription = [NSString stringWithFormat:@"%@\n%@", item[@"product_type"], item[@"vendor"] ];
        // [[Product alloc] initWithTitle:item[@"title"] andDescription:[NSString stringWithFormat:@"%@\n%@", item[@"product_type"], item[@"vendor"] ] ];
        
        if (item[@"images"]){
            if (((NSArray *)item[@"images"]).count > 0){
                
                NSURLSessionDownloadTask* downloadTask = [self.sessionWithoutADelegate downloadTaskWithURL:[NSURL URLWithString: item[@"images"][0][@"src"]] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    product.image = [NSData dataWithContentsOfURL:location];
                }];
                [downloadTask resume];
//                [self.sessionWithoutADelegate finishTasksAndInvalidate];
            }
        }
        [tmp addObject:product];
    }
    self.products = [tmp copy];
}

-(void) requestProductsWithError: ( NSError * _Nullable ) error{
    [self sendRequestForPage:@(1) error:nil];
}


-(void)sendRequestForPage: (NSNumber *) page error:( NSError * _Nullable ) error{
//    self.sessionWithoutADelegate = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PRODUCTS_URL, page]];

    NSURLSessionDataTask * sessionDataTask = [self.sessionWithoutADelegate dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        self.result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [self fillProducts];
        [[NSNotificationCenter defaultCenter] postNotificationName:RESPONSE_RECEIVED object:nil userInfo:nil];
    }];
    
    [sessionDataTask resume];
//    [self.sessionWithoutADelegate finishTasksAndInvalidate];
}


@end
