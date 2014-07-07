
#import "ItainewsViewController.h"
#import "ItainewsDetailViewController.h"
#import "SSGentleAlertView.h"
#import "SSDialogView.h"

@interface ItainewsViewController () {
    NSMutableArray *_items;
    Item *_item;
    NSXMLParser *_parser;
    NSString *_elementName;
}
@end

@interface UIImage (CommonImplement)
- (UIImage *) makeThumbnailOfSize:(CGSize)size;
@end

@implementation UIImage (CommonImplement)
- (UIImage *) makeThumbnailOfSize:(CGSize)size;
{
    UIGraphicsBeginImageContext(size);
    // draw scaled image into thumbnail context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    // pop the context
    UIGraphicsEndImageContext();
    if(newThumbnail == nil)
        NSLog(@"could not scale image");
    return newThumbnail;
}

@end

@implementation ItainewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SSGentleAlertView* alert = [[SSGentleAlertView alloc] initWithStyle:SSGentleAlertViewStyleBlack];
    alert.delegate = self;
    alert.title = @"2ch痛いニュース";
    alert.message = @"画面を下にひっぱって下さい。\n最新のリストを取得します。";
    //[alert addButtonWithTitle:@"Cancel"];
    //alert.cancelButtonIndex = 0;
    [alert addButtonWithTitle:@"OK"];
    
    [alert show];
    
	// Do any additional setup after loading the view, typically from a nib.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(startDownload)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.navigationItem.title = @"2ch痛いニュース";
    UIImage *image = [UIImage imageNamed:@"head.png"];
    UIImage *img_ato;  // リサイズ後UIImage
    float widthPer = 0.5;  // リサイズ後幅の倍率
    float heightPer = 0.5;  // リサイズ後高さの倍率
    
    CGSize sz = CGSizeMake(image.size.width*widthPer, image.size.height*heightPer);
    UIGraphicsBeginImageContext(sz);
    [image drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
    img_ato = UIGraphicsGetImageFromCurrentImageContext();
    [self.navigationController.navigationBar setBackgroundImage:img_ato forBarMetrics:UIBarMetricsDefault];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        //TableViewの境界線（区切り線）を左端から表示させる。
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItaiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Item *item = _items[indexPath.row];
    cell.textLabel.text = [item title];
    
    
    // imageの追加
    NSURL *naverimgurl = [NSURL URLWithString:[item imgurl]];
    NSData * imgdata = [NSData dataWithContentsOfURL:naverimgurl];
    UIImage *thumbnail = [UIImage imageWithData:imgdata];
    CGSize sz = CGSizeMake(50, 50);
    UIImage *thumb = [thumbnail makeThumbnailOfSize: sz];
    
    cell.imageView.image = thumb;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showItaiDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Item *item = _items[indexPath.row];
        
        ItainewsDetailViewController *ItainewsDetailViewController = [segue destinationViewController];
        [[segue destinationViewController] setDetailItem:item];
        ItainewsDetailViewController.linkurl = item.linkurl;
        
    }
}

- (void)startDownload{
    _items = [[NSMutableArray alloc] init];
    NSString * feed = @"http://blog.livedoor.jp/dqnplus/index.rdf";
    NSURL *url = [NSURL URLWithString:feed];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error){
         _parser = [[NSXMLParser alloc] initWithData:data];
         _parser.delegate = self;
         [_parser parse];
     }];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    _elementName = elementName;
    if([_elementName isEqualToString:@"item"]){
        _item = [[Item alloc] init];
        _item.title = @"";
        _item.linkurl = @"";
        _item.description = @"";
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if([_elementName isEqualToString:@"title"]){
        _item.title = [_item.title stringByAppendingString:string];
    } else if ([_elementName isEqualToString:@"link"]){
        _item.linkurl = [_item.linkurl stringByAppendingString:string];
    } else if ([_elementName isEqualToString:@"description"]){
        _item.description = [_item.description stringByAppendingString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"item"]){
        [_items addObject:_item];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    });
}

@end
