//
//  ProductDetailViewController.m
//  ShopifyTestTask
//
//  Created by SS D on 2017-12-18.
//  Copyright © 2017 SS D. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItemBar;
@property Product * product;
@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    [self.fetcher getProductDetailById:self.productId onCompletion:^(Product * _Nullable product, NSError * _Nullable error) {
        self.product = product;
        self.navigationItemBar.title = product.title;
        NSLog(@"Product Title is %@", product.title);
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
        
        
    }];
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
