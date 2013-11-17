//
//  RoomListViewController.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-12.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UILabel *lblCoin;
@property (weak, nonatomic) IBOutlet UIButton *btn2people;
@property (weak, nonatomic) IBOutlet UIButton *btn3people;

@property (weak, nonatomic) IBOutlet UIButton *btn5people;
@property(nonatomic,strong)NSMutableArray *rooms;

@end
