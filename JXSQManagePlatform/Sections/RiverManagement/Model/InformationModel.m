//
//  InformationModel.m
//  BGRuralDomesticWaste
//
//  Created by ghost on 2017/8/29.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import "InformationModel.h"

@implementation InformationModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (NSMutableArray *)IDArr{
    if (!_IDArr) {
        self.IDArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _IDArr;
}
- (NSMutableArray *)ComplaintNumArr{
    if (!_ComplaintNumArr) {
        self.ComplaintNumArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ComplaintNumArr;
}
- (NSMutableArray *)ComplaintNameArr{
    if (!_ComplaintNameArr) {
        self.ComplaintNameArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ComplaintNameArr;
}
- (NSMutableArray *)ComplaintTittleArr{
    if (!_ComplaintTittleArr) {
        self.ComplaintTittleArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ComplaintTittleArr;
}
- (NSMutableArray *)ComplaintTimeArr{
    if (!_ComplaintTimeArr) {
        self.ComplaintTimeArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ComplaintTimeArr;
}
//- (NSMutableArray *)ComplaintSiteIDArr{
//    if (!_ComplaintSiteIDArr) {
//        self.ComplaintSiteIDArr = [NSMutableArray arrayWithCapacity:1];
//    }
//    return _ComplaintSiteIDArr;
//}
//- (NSMutableArray *)SiteNameArr{
//    if (!_SiteNameArr) {
//        self.SiteNameArr = [NSMutableArray arrayWithCapacity:1];
//    }
//    return _SiteNameArr;
//}
- (NSMutableArray *)ComplaintContentArr{
    if (!_ComplaintContentArr) {
        self.ComplaintContentArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ComplaintContentArr;
}
- (NSMutableArray *)PictureArr{
    if (!_PictureArr) {
        self.PictureArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _PictureArr;
}
- (NSMutableArray *)StatusArr{
    if (!_StatusArr) {
        self.StatusArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _StatusArr;
}

- (NSMutableArray *)ImgUrlArr{
    if (!_ImgUrlArr) {
        self.ImgUrlArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ImgUrlArr;
}
@end
