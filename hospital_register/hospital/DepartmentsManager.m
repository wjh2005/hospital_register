//
// Created by Zhao yang on 3/17/14.
//

#import <Reddydog/XXStringUtils.h>
#import "DepartmentsManager.h"

@implementation DepartmentsManager {
    NSMutableArray *_departments_;


    /* used for mock data */
    NSArray *mockPosts;
    NSArray *mockNames;
    NSArray *mockAvatarImageUrls;
}

+(instancetype)manager {
    static DepartmentsManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
        [manager initial];
    });
    return manager;
}

- (void)initial {
    _departments_ = [NSMutableArray array];

    /*
     * Demo app needs some data necessary .
     * This method used to generate some mock data .
     */
    [self generateMockData];
}

- (NSArray *)departments {
    return [NSArray arrayWithArray:_departments_];
}

- (NSArray *)normalOutpatientDepartments {
    NSMutableArray *departments = [NSMutableArray array];
    for(Department *department in _departments_) {
        if(department.isNormalOutpatient) {
            [departments addObject:department];
        }
    }
    return departments;
}

- (Department *)deparmentForIdentifier:(NSString *)departmentIdentifier {
    if([XXStringUtils isBlank:departmentIdentifier]) {
        return nil;
    }

    for(Department *department in _departments_) {
        if([departmentIdentifier isEqualToString:department.identifier]) {
            return department;
        }
    }

    return nil;
}

- (NSArray *)expertOutpatientDepartments {
    NSMutableArray *departments = [NSMutableArray array];
    for(Department *department in _departments_) {
        if(department.isExpertOutpatient) {
            [departments addObject:department];
        }
    }
    return departments;
}

- (NSArray *)experts {
    NSMutableArray *experts = [NSMutableArray array];
    for(Department *department in _departments_) {
        if(department.experts != nil && department.experts.count > 0) {
            [experts addObjectsFromArray:department.experts];
        }
    }
    return experts;
}

- (NSArray *)departmentsWithDepartmentType:(DepartmentType)departmentType {
    if(DepartmentTypeAll == departmentType) {
        return [self departments];
    } else if(DepartmentTypeNormalOutpatient == departmentType) {
        return [self normalOutpatientDepartments];
    } else if(DepartmentTypeExpertOutpatient == departmentType) {
        return [self expertOutpatientDepartments];
    }
    return [NSArray array];
}

- (NSArray *)expertsForDepartmentIdentifier:(NSString *)departmentIdentifier {
    if([XXStringUtils isBlank:departmentIdentifier]) return [NSArray array];
    for(Department *department in _departments_) {
       if([departmentIdentifier isEqualToString:department.identifier]) {
           return department.experts;
       }
    }
    return [NSArray array];
}

- (NSArray *)idleExpertsForExpertIdleDate:(ExpertIdleDate)expertIdleDate {
    NSArray *experts = self.experts;
    NSMutableArray *idleExperts = [NSMutableArray array];
    for(Expert *expert in experts) {
        if([expert isIdleForExpertIdleDate:expertIdleDate]) {
            [idleExperts addObject:expert];
        }
    }
    return idleExperts;
}


#pragma mark -
#pragma mark Only Used For Test

- (void)generateMockData {

    // Generate mock departments
    _departments_ = [NSMutableArray arrayWithObjects:
            [[Department alloc] initWithIdentifier:@"1"  name:@"产科" departmentType:DepartmentTypeNormalOutpatient],
            [[Department alloc] initWithIdentifier:@"2"  name:@"耳鼻喉科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"3"  name:@"儿科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"4"  name:@"妇科" departmentType:DepartmentTypeNormalOutpatient],
            [[Department alloc] initWithIdentifier:@"5"  name:@"骨科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"6"  name:@"呼吸内科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"7"  name:@"泌尿科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"8"  name:@"内分泌科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"9"  name:@"皮肤科" departmentType:DepartmentTypeNormalOutpatient],
            [[Department alloc] initWithIdentifier:@"10" name:@"普外科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"11" name:@"肾内科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"12" name:@"性病科" departmentType:DepartmentTypeNormalOutpatient],
            [[Department alloc] initWithIdentifier:@"13" name:@"消化内科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"14" name:@"消化外科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"15" name:@"心血管内科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"16" name:@"血液风湿肿瘤科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"17" name:@"眼科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"18" name:@"中医科" departmentType:DepartmentTypeAll],
            [[Department alloc] initWithIdentifier:@"19" name:@"妇产科" departmentType:DepartmentTypeExpertOutpatient],
            [[Department alloc] initWithIdentifier:@"20" name:@"感染科" departmentType:DepartmentTypeExpertOutpatient],
            [[Department alloc] initWithIdentifier:@"21" name:@"神经内科" departmentType:DepartmentTypeExpertOutpatient],
            [[Department alloc] initWithIdentifier:@"22" name:@"胸外科" departmentType:DepartmentTypeExpertOutpatient],
            [[Department alloc] initWithIdentifier:@"23" name:@"外院专家儿科" departmentType:DepartmentTypeExpertOutpatient],
            [[Department alloc] initWithIdentifier:@"24" name:@"外院专家妇产科" departmentType:DepartmentTypeExpertOutpatient],
            [[Department alloc] initWithIdentifier:@"25" name:@"外院专家内科" departmentType:DepartmentTypeExpertOutpatient],
            [[Department alloc] initWithIdentifier:@"26" name:@"外院专家皮肤科" departmentType:DepartmentTypeExpertOutpatient],
            [[Department alloc] initWithIdentifier:@"27" name:@"外院专家外科" departmentType:DepartmentTypeExpertOutpatient],
            [[Department alloc] initWithIdentifier:@"28" name:@"外院专家肿瘤放疗" departmentType:DepartmentTypeExpertOutpatient],
            [[Department alloc] initWithIdentifier:@"29" name:@"外院专家中医科" departmentType:DepartmentTypeExpertOutpatient],
            nil];


    // Generate mock experts
    NSArray *expertOutpatientDepartments = _departments_;
    for(int i=0; i<expertOutpatientDepartments.count; i++) {
        Department *dpt = [expertOutpatientDepartments objectAtIndex:i];
        dpt.registerPrice = arc4random() % 30 + 10;

        // outpatient department doesn't need to generate experts
        if(DepartmentTypeNormalOutpatient == dpt.departmentType) continue;

        int expertsCount = 8 + rand() % 3;
        for(int j=0; j<expertsCount; j++) {
            Expert *mockExpert = self.mockExpert;
            mockExpert.department = dpt;
            [dpt.experts addObject:mockExpert];
        }
    }

    mockPosts = nil;
    mockNames = nil;
    mockAvatarImageUrls = nil;
}

- (Expert *)mockExpert {
    if(mockPosts == nil) {
        mockPosts = [NSArray arrayWithObjects:@"主任医师", @"副主任医师", nil];
    }

    if(mockNames == nil) {
        mockNames = [NSArray arrayWithObjects:
                @"史昕雁", @"谢令惠", @"钦玉二", @"勤韩一", @"堂彩仓", @"严晴", @"问玲沁", @"瓮果", @"不紫瞳", @"扬敏",
                @"晋豪雨", @"昂宝", @"汉蕊", @"漆桢国", @"蔡孟只", @"楼动力", @"伊宏一", @"俟翰", @"示苗苗", @"富辛平",
                @"建宇峰", @"羊玟", @"贵韩瑶", @"蹉荣胜", @"南正光", @"赫连鑫", @"鄂苗苗", @"张正顺", @"空佳乐", @"守妍依",
                @"来韩霖", @"丘志红", @"裔曼青", @"仉雯", @"伯科捷", @"箕瑶韩", @"慎明强", @"蔺鸿", @"冯福", @"宏若晗", @"鲁媛",
                @"秀云", @"姜彪", @"乾令惠", @"郑棂镳", @"鱼宏一", @"仆瑶瑶", @"但广斌", @"满玲翡", @"竹梓潼", @"有润国",
                @"纪桓", @"逄一", @"宰昕燕", @"昌莹莹", @"母嘉龙", @"冀浩宇", @"营红艳", @"国澎楠", @"溥成日", @"上官洋", @"强颖颖",
                @"印冰染", @"刑悦", @"盖欣桐", @"揭儒岚", @"於涛华", @"柏苑", @"蔡辰琳", @"迮欣颜", @"邴宏图", @"漆佳一", @"雍纪",
                @"葛国良", @"陆馨平", @"瓮峰", @"箕宏霖", @"焉佁", @"脱冰巧", @"花恒靳", @"百玲沁", @"水尔", @"钱科捷", @"巧争然",
                @"谭镇国", @"寻星嘉", @"颜兰芳", @"南营泽", @"终韩博", @"柳瑶霖", @"荆紫童", @"拱源", @"郁亘", @"枚嘉欣", @"庹艳楠",
                @"钮霖", @"行悦", @"庄雅婷", @"伦加隆", @"环鑫萍", @"将缌羽", @"战梅", @"麻浩宇", @"白博文", @"芒羚盈", @"撒和堂",
                @"蚁牡丹", @"赧忠", @"所羚漪", @"典玄庚", @"以韩韩", @"生振", @"位唐古", @"有顺达", @"松文娟", @"季孜晗", @"隆素同",
                @"厚博玉", @"畅涛", @"戎羚漪", @"绪科捷", @"纳海龙", @"熊晔", @"平易梦", @"步晓卉", @"桓之尧", @"零大贵", @"汗书文",
                @"谷修勇", @"麦明强", @"漆千亦", @"连震", @"戢玉一", @"丙新锁", @"菅馨平", @"字力", @"建照捷", @"牢佁", @"叶韬", @"宰政国",
                @"纵瑶恒", @"首根", @"素扬", @"眭彦飞", @"睦俊博", @"英艺", @"战嘉强", @"宫晓东", @"翟振国", @"貊中仕", @"崔念梦", @"尉迟鑫",
                @"介仙婷", @"隗小青", @"镇贤洋", @"赫连涵", @"说瑶霖", @"单丰", @"荣东升", @"蒲子淳", @"改巾帼", @"纪茹霞", @"浑敏", @"摩智卓",
                @"户赢", @"狂灵", @"夕衡", @"谷智卓", @"何恒", @"糜星霖", @"益苑", @"果继富", @"谭蕊蕊", @"忻敏", @"仇子桐", @"商十用",
                @"卷易梦", @"才程程", @"颜梓穹", @"零乐意", @"顿冬", @"九洁", @"合千亦", @"富家俊", @"哀淼", @"宾茹霞", @"德涛鸣", @"跋慧玲",
                @"陶之平", @"柯苗", @"卷浩恒", @"常涛", @"素寒", @"戈舒", @"图门世", @"扈恒靳", @"延闽", @"毕任安", @"五小梅", @"闻红梅",
                @"同宏丹", @"实巾帼", @"穆乐意", @"旷棂", @"佘星韩", @"撒友卉", @"仙簇新", @"謇博丹", @"褒豪宇", @"彭圣熙", @"刘海龙", @"骑瑛",
                @"拜颜", @"戏书文", @"练含巧", @"次彦旭", @"缑子昂", @"冼星", @"掌紫瞳", @"伟玲漪", @"南宫肜", @"隽靖雄", @"多兰芳", @"顾军霞",
                @"寒鑫琳", @"锁彪", @"似子昂", @"戏翎惠", @"蒯福", @"滑宇峰", @"钦新蕊", @"幸智卓", @"闾灿婷", @"咎涛华", @"卯学而", @"纵莉",
                @"茹黎", @"廖子健", @"明佳一", @"邓一佳", @"肇晓梅", @"黄琴", @"喜亚宁", @"蔺航", @"僧鑫", @"多秋", @"阚博丹", @"休景秀", @"成颖颖",
                @"符冬儿", @"休智成", @"潘鑫琳", @"姜鑫平", @"任忠义", @"莘金淳", @"针涛荣", @"陶恒三", @"连功成", @"门东升", @"经伟成", @"桓佳一",
                @"畅贞国", @"杞妮", @"计媛", @"市佁", @"段建华", @"亢靖", @"买浩", @"羿嘉隆", @"梅兀", @"慈紫涵", @"刁非吟", @"旗中方", @"全宝",
                @"同黎", @"侯材治", @"侯星博", @"圭翻嘉", @"金瑞祥", @"祭之平", @"旷灵泉", @"骑素同", @"覃朝玮", @"阮子", @"军佳", @"蓬雯",
                @"羊海贤", @"佼娟平", @"迟如意", @"竭韩恒", @"定缌羽", @"禚羚盈", @"天含玉", @"汗晓梅", @"母好雨", @"年涛荣", @"笃缌羽", @"漆雨桐",
                @"戊昊", @"树思真", nil];
    }

    if(mockAvatarImageUrls == nil) {
        mockAvatarImageUrls = [NSArray arrayWithObjects:
                @"http://imgsrc.baidu.com/forum/pic/item/54fbb2fb43166d227615dfd4462309f79052d214.jpg",
                @"http://wenwen.soso.com/p/20110419/20110419103128-1276983782.jpg",
                @"http://wenwen.soso.com/p/20100709/20100709135107-2048089823.jpg",
                @"http://wenwen.soso.com/p/20100503/20100503160425-1957397185.jpg",
                @"http://www.ygjj.com/bookpic/2009-03-01/new237150-20090301112518919061.gif",
                nil];
    }

    Expert *mockExpert = [[Expert alloc] init];

    mockExpert.name = [[SearchableString alloc] initWithString:[mockNames objectAtIndex:(arc4random() % mockNames.count)]];

    int idleDays = arc4random() % 4 + 1;
    for(int i=0; i<idleDays; i++) {
        [mockExpert addExpertIdleDate:1 << (arc4random() % 7) expertIdleTime:(arc4random() % 3 + 1)];
    }

    mockExpert.post = [mockPosts objectAtIndex:arc4random() % 2];
    mockExpert.imageUrl = [mockAvatarImageUrls objectAtIndex:arc4random() % mockAvatarImageUrls.count];
    mockExpert.registerNumbersRemain = arc4random() % 40;
    mockExpert.introduce = @"";
    mockExpert.registerPrice = arc4random() % 30 + 10;
    mockExpert.shortIntroduce = @"常见病诊断和治疗,耳鼻喉科疑难杂症诊断和治疗;耳鼻喉科肿瘤早期诊断.";

    return mockExpert;
}

@end