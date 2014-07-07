
#import "NaverDetailViewController.h"

@implementation NaverDetailViewController
@synthesize linkurl;
@synthesize imgurl;

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.title = [self.detailItem title];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    linkurl = [linkurl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    linkurl = [linkurl stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSURL *url = [NSURL URLWithString: linkurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    float w = self.indicator.frame.size.width;
    float h = self.indicator.frame.size.height;
    float x = self.view.frame.size.width/2 - w/2;
    float y = self.view.frame.size.height/2 - h/2;
    self.indicator.frame = CGRectMake(x, y, w, h);
    
    UIBarButtonItem *buttonItem;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"bt_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;

}

- (void)backButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.indicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indicator stopAnimating];
    self.indicator.hidesWhenStopped = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    CGRect bannerFrame = self.bannerView.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    self.bannerView.frame = bannerFrame;    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    CGRect bannerFrame = banner.frame;
    bannerFrame.origin.y = self.view.frame.size.height - banner.frame.size.height;
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         banner.frame = bannerFrame;
                     }];
    NSLog(@"naver広告在庫あり");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    CGRect bannerFrame = banner.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         banner.frame = bannerFrame;
                     }];
    NSLog(@"naver広告在庫なし");
}

@end
