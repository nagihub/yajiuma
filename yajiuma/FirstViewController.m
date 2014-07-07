
#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //tabBar
    /*
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - 50;
    frame.size.height = 50 + 50;
    [self.view setFrame:frame];
    [self.view setBounds:self.view.bounds];
     */
    
    UIImage *img_mae = [UIImage imageNamed:@"bg.png"];  // リサイズ前UIImage
    
    //画面取得
    UIScreen *sc = [UIScreen mainScreen];
    //ステータスバー込みのサイズ
    CGRect rect = sc.bounds;
    
    if(rect.size.width > 500){
        //self.view.backgroundColor = [UIColor colorWithPatternImage:img_mae];
        
        UIImage *img_ato;  // リサイズ後UIImage
        CGFloat width = 770;  // リサイズ後幅のサイズ
        CGFloat height = 1024;  // リサイズ後高さのサイズ
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [img_mae drawInRect:CGRectMake(0, 0, width, height)];
        img_ato = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:img_ato];

    } else {
        UIImage *img_ato;  // リサイズ後UIImage
        CGFloat width = 320;  // リサイズ後幅のサイズ
        CGFloat height;  // リサイズ後高さのサイズ
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            height = 540;  // リサイズ後高さのサイズ
        } else {
            height = 420;  // リサイズ後高さのサイズ
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [img_mae drawInRect:CGRectMake(0, 0, width, height)];
        img_ato = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:img_ato];
    
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"広告在庫あり");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    CGRect bannerFrame = banner.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         banner.frame = bannerFrame;
                     }];
    NSLog(@"広告在庫なし");
}


- (IBAction)naverbutton:(UIButton *)sender {
    self.tabBarController.selectedIndex = 1;
}

- (IBAction)togetterbutton:(UIButton *)sender {
    self.tabBarController.selectedIndex = 2;
}

- (IBAction)itaibutton:(UIButton *)sender {
    self.tabBarController.selectedIndex = 3;
}
@end
