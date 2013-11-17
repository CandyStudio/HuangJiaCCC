//
//  AnswerCellView.h
//  RoyalCCC
//
//  Created by xiaochuan on 13-11-15.
//  Copyright (c) 2013年 xiaochuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AnswerCellViewDlegate
- (void)answerClick:(NSNumber *)tag;
@end
@interface AnswerCellView : UIView
{
    
}
@property(nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageTitle;
@property (weak, nonatomic) IBOutlet UILabel *answerInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer;


+ (AnswerCellView *)createView;

- (void)updateInfo:(NSString *)answer andTag:(NSNumber *)tag;
- (void)answerRight;
- (void)answerWrong;
@end
