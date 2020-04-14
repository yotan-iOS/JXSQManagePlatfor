//
//  StationModel.m
//  LWIntelligenceOperations
//
//  Created by 吴坤 on 17/5/17.
//  Copyright © 2017年 ghost. All rights reserved.
//

#import "StationModel.h"

@implementation StationModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    NSLog(@"--key%@",key);
    
    
}

-(NSMutableArray *)SiteClassIDArrTwo{
    if (!_SiteClassIDArrTwo) {
        
        self.SiteClassIDArrTwo = [NSMutableArray arrayWithCapacity:1];
    }
    return _SiteClassIDArrTwo;
}
-(NSMutableArray *)RegulationsNameArr{
    if (!_RegulationsNameArr) {
        
        self.RegulationsNameArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _RegulationsNameArr;
}
-(NSMutableArray *)ReleaseTimeArr{
    if (!_ReleaseTimeArr) {
        
        self.ReleaseTimeArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ReleaseTimeArr;
}
-(NSMutableArray *)ReleaseDepartArr{
    if (!_ReleaseDepartArr) {
        
        self.ReleaseDepartArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ReleaseDepartArr;
}
-(NSMutableArray *)AttachmentArr{
    if (!_AttachmentArr) {
        
        self.AttachmentArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _AttachmentArr;
}

-(NSMutableArray *)SiteTypeIDArr{
    if (!_SiteTypeIDArr) {
        
        self.SiteTypeIDArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _SiteTypeIDArr;
}
-(NSMutableArray *)SiteTypeNameArr{
    if (!_SiteTypeNameArr) {
        
        self.SiteTypeNameArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _SiteTypeNameArr;
}
-(NSMutableArray *)SiteIDArr{
    if (!_SiteIDArr) {
        
        self.SiteIDArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _SiteIDArr;
}
-(NSMutableArray *)SiteNameArr{
    if (!_SiteNameArr) {
        
        self.SiteNameArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _SiteNameArr;
}
-(NSMutableArray *)SiteClassIDArr{
    if (!_SiteClassIDArr) {
        
        self.SiteClassIDArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _SiteClassIDArr;
}
-(NSMutableArray *)SiteTypeIDArrThree{
    if (!_SiteTypeIDArrThree) {
        
        self.SiteTypeIDArrThree = [NSMutableArray arrayWithCapacity:1];
    }
    return _SiteTypeIDArrThree;
}

- (NSMutableArray *)StreetIDArr{
    if (!_StreetIDArr) {
        self.StreetIDArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _StreetIDArr;
}
- (NSMutableArray *)StreetNameArr{
    if (!_StreetNameArr) {
        self.StreetNameArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _StreetNameArr;
}

- (NSMutableArray *)StatusArr{
    if (!_StatusArr) {
        self.StatusArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _StatusArr;
}

///
-(NSMutableArray *)HasDataFlgArr{
    if (!_HasDataFlgArr) {
        
        self.HasDataFlgArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _HasDataFlgArr;
}
-(NSMutableArray *)SiteCountArr{
    if (!_SiteCountArr) {
        
        self.SiteCountArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _SiteCountArr;
}

-(NSMutableArray *)HasVideoFlagArr{
    if (!_HasVideoFlagArr) {
        
        self.HasVideoFlagArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _HasVideoFlagArr;
}
-(NSMutableArray *)RecordIDArr{
    if (!_RecordIDArr) {
        
        self.RecordIDArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _RecordIDArr;
}

@end
