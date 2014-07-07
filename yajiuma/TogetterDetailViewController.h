
#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface TogetterDetailViewController : UIViewController{
    NSString *linkurl;
}

@property (strong, nonatomic) id detailItem;
@property (nonatomic,retain) NSString *linkurl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;

@end
