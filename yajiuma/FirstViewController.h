
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface FirstViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet ADBannerView *bannerView;
- (IBAction)naverbutton:(UIButton *)sender;
- (IBAction)togetterbutton:(UIButton *)sender;
- (IBAction)itaibutton:(UIButton *)sender;

@end
