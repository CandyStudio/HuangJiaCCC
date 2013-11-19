//
//  AnswerCellView.m
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-15.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import "AnswerCellView.h"

@implementation AnswerCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}



- (void)awakeFromNib{
    [super awakeFromNib];
    [self.btnAnswer addTarget:self action:@selector(answer) forControlEvents:UIControlEventTouchUpInside];
}
- (void)answer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(answerClick:andIndex:)]) {
        [self.delegate answerClick:[NSNumber numberWithLong:self.tag]andIndex:self.index];
    }
}
+ (AnswerCellView *)createView{
    AnswerCellView *view = [[[NSBundle mainBundle] loadNibNamed:@"AnswerCellView" owner:nil options:nil] objectAtIndex:0];
    view.hidden = YES;
    
    return view;
}
- (void)updateInfo:(NSString *)answer andTag:(NSNumber *)tag andIndex:(NSString *)a{
    self.hidden = NO;
    self.answerInfo.text =answer;
    self.tag = [tag intValue];
    self.imageTitle.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",a]];
    self.btnAnswer.imageView.image = [UIImage imageNamed:@"answercellbg.png"];
    self.index = a;
}
- (void)answerRight{
    self.btnAnswer.imageView.image = [UIImage imageNamed:@"answercellbgright.png"];
    self.imageTitle.image = [UIImage imageNamed:@"right.png"];
}
- (void)answerWrong{
    self.btnAnswer.imageView.image = [UIImage imageNamed:@"answercellbgwrong.png"];
    self.imageTitle.image = [UIImage imageNamed:@"wrong.png"];
}
@end
