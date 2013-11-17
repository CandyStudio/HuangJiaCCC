//
//  Room.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-13.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "BasicModel.h"

@interface Room : BasicModel
@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,retain)NSNumber *people;
@property(nonatomic,retain)NSNumber *second;
@property(nonatomic,retain)NSNumber *questioncount;
@property(nonatomic,retain)NSNumber *hp;
@property(nonatomic,retain)NSNumber *questiontype;
@end
