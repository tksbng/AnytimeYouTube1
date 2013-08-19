//
//  AnytimeYouTube1ViewController.h
//  AnytimeYouTube1
//
//  Created by Takeshi Bingo on 2013/08/19.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnytimeYouTube1ViewController : UIViewController {
    NSMutableArray *aryData;
}
@property (nonatomic,retain) IBOutlet UITableView *tvYouTube;
@property (nonatomic,assign) IBOutlet UITableViewCell *cellYouTube;

@end
