//
//  QGSendboxViewerCell.m
//  QGSandboxViewer
//
//  Created by Hanxiaojie on 2018/6/20.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "QGSendboxViewerCell.h"

@interface QGSendboxViewerCell ()
{
    NSIndexPath *_indexPath;
}
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *modifyDateLabel;

@end

@implementation QGSendboxViewerCell


+ (UINib*)instanceForNib{
    UINib * nibCell = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    return nibCell;
}

- (void)setupCellData:(QGSendboxViewerModel*)cellData indexPath:(NSIndexPath*)indexPath{
    _indexPath = indexPath;
    self.fileSizeLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    if (cellData) {
        self.contentLabel.text = cellData.fileName;
        self.modifyDateLabel.text = cellData.fileModificationDate;
        
        if ([cellData.fileType isEqualToString:@"NSFileTypeDirectory"]) {
            
            [self setupNumbersOfobjectForDirectory:[cellData.filePath stringByAppendingFormat:@"/%@",cellData.fileName]];
            NSLog(@"这是一个文件夹");
        } else {
            self.fileSizeLabel.text = [self transformedValue:cellData.fileSize];
            NSLog(@"这是一个文件");
        }
    } else {
        self.contentLabel.text = @"--";
    }
    
}

- (void)setupNumbersOfobjectForDirectory:(NSString*)sandboxPath{
    NSError *error;
    NSArray<NSString *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sandboxPath error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
        self.fileSizeLabel.text = @"无效或者无权限访问的文件夹";
        self.fileSizeLabel.textColor = [UIColor redColor];
    } else {
        if ([contents count] > 0) {
            self.fileSizeLabel.text = [NSString stringWithFormat:@"%ld 个对象",[contents count]];
        } else {
            self.fileSizeLabel.text = @"空文件夹";
        }
    }
}

- (NSString*)transformedValue:(id)value
{
    
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
