//
//  GLMine_MessageCell.m
//  GroupCar
//
//  Created by 龚磊 on 2017/12/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MessageCell.h"

@interface GLMine_MessageCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation GLMine_MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];

//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Using NSAttributed String"];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30.0] range:NSMakeRange(0, 5)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0] range:NSMakeRange(6, 12)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:30.0] range:NSMakeRange(19, 6)];
//    attrLabel.attributedText = str;
    
}
- (void)setModel:(GLMine_MessageModel *)model{
    _model = model;
    
    self.contentLabel.text = model.msg;
}

- (IBAction)delete:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteTheMessage:)]) {
        [self.delegate deleteTheMessage:self.index];
    }
}

@end
