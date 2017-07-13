//
//  GridColHead4.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GridColHead4.h"

@implementation GridColHead4

+ (id)getInstance:(UITableView *)tableView
{
    GridColHead4 *item = (GridColHead4 *)[tableView dequeueReusableCellWithIdentifier:GridColHead4Indentifier];
    if (item == nil) {
        item = [[[NSBundle mainBundle]loadNibNamed:@"GridColHead4" owner:self options:nil]lastObject];
    }
    item.selectionStyle = UITableViewCellSelectionStyleNone;
    return item;
}

- (void)initColHead:(NSString *)col1 col2:(NSString *)col2 event:(int)event
{
    self.btnAdd.layer.cornerRadius = CELL_HEADER_RADIUS2;
    self.lblName.text = col1;
    self.event = event;
    self.objId = col2;
}

- (IBAction)addActivity:(id)sender
{
    [self.delegate showAddEvent:self.objId];
}

- (IBAction)editActivity:(id)sender
{
    [self.delegate showEditObjId:self.objId event:[NSString stringWithFormat:@"%d", self.event]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
