//
//  AnytimeYouTube1ViewController.m
//  AnytimeYouTube1
//
//  Created by Takeshi Bingo on 2013/08/19.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import "AnytimeYouTube1ViewController.h"
#import "JSON.h"

@interface AnytimeYouTube1ViewController ()

@end

@implementation AnytimeYouTube1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    aryData = [[NSMutableArray alloc]initWithCapacity:0];
    
    [[NSBundle mainBundle] loadNibNamed:@"cellYouTube" owner:self options:nil];
    [_tvYouTube setRowHeight:[_cellYouTube frame].size.height];
    _cellYouTube = nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryData count];
}
//Cusomize the appearance of table view cells
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellYouTube";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"cellYouTube" owner:self options:nil];
        cell = _cellYouTube;
        _cellYouTube = nil;
    }
  //  [[cell textLabel] setText:[NSString stringWithFormat:@"この行は%d番目",[indexPath row]]];
  //  return cell;
    if ([aryData count] > [indexPath row]) {
        UIWebView *aWebView = (UIWebView *)[cell viewWithTag:11];
        UILabel *aLabel = (UILabel *)[cell viewWithTag:12];
        UITextView *aTextView = (UITextView *)[cell viewWithTag:13];
        UIActivityIndicatorView *aIndicator = (UIActivityIndicatorView *)[cell viewWithTag:15];
        [aIndicator startAnimating];
        NSMutableDictionary *dic = [aryData objectAtIndex:[indexPath row]];
        [aLabel setText:[dic valueForKey:@"title"]];
        [aTextView setText:[dic valueForKey:@"description"]];
        NSString *videoId = [dic valueForKey:@"id"];
        if (videoId) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EmbedPlayer" ofType:@"html"];
            NSError *error = nil;
            NSString *html = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            if(error != nil){
                NSLog(@"HTMLの読み込みでエラー(%@)",[error localizedDescription]);
            
            }
            else {
                NSString *translateHTML = [html stringByReplacingOccurrencesOfString:@"_YOUTUBE_VIDEO_ID_" withString:videoId];
                [aWebView loadHTMLString:translateHTML baseURL:nil];
            }
        }
    }
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *keyword = [searchBar text];
    NSLog(@"検索語：%@",keyword);
    NSString *requestFeed = @"http://gdata.youtube.com/feeds/api/videos?q=%@&v=2&format=1,6&alt=jsonc";
    NSString *urlString = [NSString stringWithFormat:requestFeed,[keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"url=%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    //指定したURLのレスポンスを取得（JSONデータを取得）
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"json=%@",jsonString);
    NSDictionary *dicResult = [jsonString JSONValue];
    //検索結果をリセット
    [aryData removeAllObjects];
    
    NSDictionary *dicData = [dicResult valueForKey:@"data"];
    NSArray *aryItems = [dicData valueForKey:@"items"];
    
    for (NSDictionary *dic in aryItems) {
        NSString *videoTitle = [dic objectForKey:@"title"];
        NSString *videoId = [dic objectForKey:@"id"];
        NSString *videoDescription = [dic objectForKey:@"description"];
        NSString *videoContent = [dic objectForKey:@"content"];
        NSLog(@"title = %@",videoTitle);
        NSLog(@"id = %@",videoId);
        NSLog(@"description = %@",videoDescription);
        NSLog(@"content:%@",videoContent);
        
        NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
        [dicData setValue:videoTitle forKey:@"title"];
        [dicData setValue:videoId forKey:@"id"];
        [dicData setValue:videoDescription forKey:@"description"];
        [dicData setValue:videoContent forKey:@"content"];
        [aryData addObject:dicData];

    }
    [_tvYouTube reloadData];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    UITableViewCell *cell = (UITableViewCell *)[[webView superview] superview];
    UIActivityIndicatorView *aIndicator = (UIActivityIndicatorView *)[cell viewWithTag:15];
    [aIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
