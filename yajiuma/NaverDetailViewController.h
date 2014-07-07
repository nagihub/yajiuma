
#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface NaverDetailViewController : UIViewController{
    NSString *linkurl;
    NSString *imgurl;
}

@property (strong, nonatomic) id detailItem;
@property (nonatomic,retain) NSString *linkurl;
@property (nonatomic,retain) NSString *imgurl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;



@end
