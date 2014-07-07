
#import <Foundation/Foundation.h>

@interface ItainewsDetailViewController : UIViewController{
    NSString *linkurl;
}

@property (strong, nonatomic) id detailItem;
@property (nonatomic,retain) NSString *linkurl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


@end
