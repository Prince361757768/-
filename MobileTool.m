//
//  MobileTool.m
//  iMobileSecondaryBuy
//
//  Created by 张金海 on 14-10-22.
//  Copyright (c) 2014年 damai. All rights reserved.
//

#import "MobileTool.h"
#import "zlib.h"
#import <CommonCrypto/CommonDigest.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#include <math.h>
#import <AVFoundation/AVFoundation.h>
const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
#pragma mark - 输入框文字
NSString * const t_PhoneNULL = @"手机号不可为空";
NSString * const t_PhoneError = @"手机号码有误，请检查！";
NSString * const t_VcodeNULL = @"验证码不可为空";
NSString * const t_NickNULL = @"昵称不可为空";
NSString * const t_PasswordNULL = @"密码不可为空";
NSString * const t_PasswordError = @"请输入正确的密码";
NSString * const t_PasswordDifferent = @"两次输入密码不一致";
NSString * const t_PasswordRegex = @"密码只能是6~16位数字或字母";

@implementation MobileTool
#pragma mark -- 获取UUID
+ (NSString*)stringWithNewUUID {
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, uuidObj);
    NSString *result = (__bridge_transfer NSString *)CFStringCreateCopy(NULL, uuidString);
    CFRelease(uuidObj);
    CFRelease(uuidString);
    return result;
}
#pragma mark -- 屏幕分辨率
+(NSString *)getScreen
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    NSString *screen = [NSString stringWithFormat:@"%.f*%.f",width*scale_screen,height*scale_screen];
    return screen;
    DLog(@"%f,%f",width*scale_screen,height*scale_screen);
}
#pragma mark -- md5字符串加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
#pragma mark -- 数据存储
+(NSString*)getDocumentPath{
    //Creates a list of directory search paths.-- 创建搜索路径目录列表。
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    //常量NSDocumentDirectory表面我们正在查找的Document目录路径，
    //常量NSUserDomainmask表明我们希望将搜索限制于我们应用程序的沙盒中。
    return [paths objectAtIndex:0];
    //这样我们就可以得到该数组的第一值，也仅此一值，因为每一个应用程序只有一个Document文件夹。
    
}
#pragma mark -- 时间戳转换
+ (NSString *) getStringFromDateTime:(NSString *)date  andDataFormat:(NSString *)dateFormat
{
    if (!date)
        return nil;
    if ([date isKindOfClass:[NSString class]])
    {
        int a = 0;
        a++;
    }
    if ([date isKindOfClass:[NSNumber class]])
    {
        int a = 0;
        a++;
    }
    
    //NSString *dataStr = @"1376640784";//[date substringWithRange:NSMakeRange(0, 10)];
    //NSString *dataStr = [date substringWithRange:NSMakeRange(0, 10)];
    double timeDate = [date doubleValue]/1000;
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeDate];//
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:dateFormat];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    
    //1296035591
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //NSLog(@"confromTimespStr =  %@",confromTimespStr);
    return  confromTimespStr;
}
//计算两个日期相差几天 几小时  几分钟
+(NSString *)getTime :(NSString *)endTimeStr startTimeStr:(NSString *)startTimeStr{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *  senddate=[NSDate date];
    //结束时间
//    NSDate *endDate = [dateFormatter dateFromString:@"2015-1-24 00:00:00"];
     NSDate *endDate = [dateFormatter dateFromString:endTimeStr];
    //当前时间
//    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    NSDate *senderDate = [dateFormatter dateFromString:startTimeStr];
    //得到相差秒数
    NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
    
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)%3600/60;
    NSString *dateContent;
    if (days <= 0&&hours <= 0&&minute <= 0)
        dateContent=@"已过期";
    else
        dateContent=[[NSString alloc] initWithFormat:@"距开始:%i天%i小时%i分钟",days,hours,minute];
    
    
    return dateContent;
}
#pragma mark -- 动态算字符串的高度
+(CGFloat)calculateHeight:(CGFloat)width text:(NSString*)str font:(UIFont*)font
{
    
    CGSize size = [str sizeWithFont:font
                  constrainedToSize:CGSizeMake(width, 5000)
                      lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
    
}
#pragma mark -- 判断网络是否畅通
+(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
    
    /*
     if(![StadiumTool connectedToNetwork])
     {
     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];
     [alert release];
     return;
     
     }
     */
}

//#pragma mark -- 压缩数据
//+(NSData*) gzipData: (NSData*)pUncompressedData
//{
//    if (!pUncompressedData || [pUncompressedData length] == 0)
//    {
//        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
//        return nil;
//    }
//    
//    z_stream zlibStreamStruct;
//    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
//    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
//    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
//    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
//    zlibStreamStruct.next_in   = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes
//    zlibStreamStruct.avail_in  = [pUncompressedData length]; // Number of input bytes left to process
//    
//    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
//    if (initError != Z_OK)
//    {
//        NSString *errorMsg = nil;
//        switch (initError)
//        {
//            case Z_STREAM_ERROR:
//                errorMsg = @"Invalid parameter passed in to function.";
//                break;
//            case Z_MEM_ERROR:
//                errorMsg = @"Insufficient memory.";
//                break;
//            case Z_VERSION_ERROR:
//                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
//                break;
//            default:
//                errorMsg = @"Unknown error code.";
//                break;
//        }
//        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
//        //[errorMsg release];
//        return nil;
//    }
//    
//    // Create output memory buffer for compressed data. The zlib documentation states that
//    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
//    NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 12];
//    
//    int deflateStatus;
//    do
//    {
//        // Store location where next byte should be put in next_out
//        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
//        
//        // Calculate the amount of remaining free space in the output buffer
//        // by subtracting the number of bytes that have been written so far
//        // from the buffer's total capacity
//        zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
//        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
//        
//    } while ( deflateStatus == Z_OK );
//    
//    // Check for zlib error and convert code to usable error message if appropriate
//    if (deflateStatus != Z_STREAM_END)
//    {
//        NSString *errorMsg = nil;
//        switch (deflateStatus)
//        {
//            case Z_ERRNO:
//                errorMsg = @"Error occured while reading file.";
//                break;
//            case Z_STREAM_ERROR:
//                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
//                break;
//            case Z_DATA_ERROR:
//                errorMsg = @"The deflate data was invalid or incomplete.";
//                break;
//            case Z_MEM_ERROR:
//                errorMsg = @"Memory could not be allocated for processing.";
//                break;
//            case Z_BUF_ERROR:
//                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
//                break;
//            case Z_VERSION_ERROR:
//                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
//                break;
//            default:
//                errorMsg = @"Unknown error code.";
//                break;
//        }
//        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
//        //[errorMsg release];
//        
//        // Free data structures that were dynamically created for the stream.
//        deflateEnd(&zlibStreamStruct);
//        
//        return nil;
//    }
//    // Free data structures that were dynamically created for the stream.
//    deflateEnd(&zlibStreamStruct);
//    [compressedData setLength: zlibStreamStruct.total_out];
//    NSLog(@"%s: Compressed file from %lu KB to %lu KB", __func__, [pUncompressedData length]/1024, [compressedData length]/1024);
//    
//    return compressedData;
//}
//#pragma mark -- 解压缩数据
//+(NSData *)ungzipData:(NSData *)compressedData
//{
//    if ([compressedData length] == 0)
//        return compressedData;
//    
//    unsigned full_length = [compressedData length];
//    unsigned half_length = [compressedData length] / 2;
//    
//    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
//    BOOL done = NO;
//    int status;
//    
//    z_stream strm;
//    strm.next_in = (Bytef *)[compressedData bytes];
//    strm.avail_in =(int)[compressedData length];
//    strm.total_out = 0;
//    strm.zalloc = Z_NULL;
//    strm.zfree = Z_NULL;
//    if (inflateInit2(&strm, (15+32)) != Z_OK)
//        return nil;
//    
//    while (!done) {
//        // Make sure we have enough room and reset the lengths.
//        if (strm.total_out >= [decompressed length]) {
//            [decompressed increaseLengthBy: half_length];
//        }
//        strm.next_out = [decompressed mutableBytes] + strm.total_out;
//        strm.avail_out = [decompressed length] - strm.total_out;
//        // Inflate another chunk.
//        status = inflate (&strm, Z_SYNC_FLUSH);
//        if (status == Z_STREAM_END) {
//            done = YES;
//        } else if (status != Z_OK) {
//            break;
//        }
//    }
//    
//    if (inflateEnd (&strm) != Z_OK)
//        return nil;
//    // Set real length.
//    if (done) {
//        [decompressed setLength: strm.total_out];
//        return [NSData dataWithData: decompressed];
//    }
//    return nil;
//}
#pragma mark -- 将默认图片转成Data
+(NSData *)defaultImageData
{
    //默认图片
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"new_headImage"],0.5);
    return imageData;
}
+ (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
+ (void)showAlert:(NSString *)message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
//通过名称获取二级城市Id
+(NSString *)getCitySecondId:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area_city" ofType:@"db"];//PN
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM area where name = '%@'  and type = 2",name];
//    NSLog(@"%@--%d--%@",NSStringFromSelector(_cmd),__LINE__,sql);
    FMResultSet *rs = [db executeQuery:sql];//select * from Area where parent_code = '02'
//    NSLog(@"rs = %@",rs);
    while ([rs next]) {
        NSString *code = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"id"]];
//        NSLog(@"code = %@",code);
        
        return code;
    }
    
    
    [db close];
    return nil;
}

//通过名称获取Id
+(NSString *)getCityId:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area_city" ofType:@"db"];//PN
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM area where name like '%@%%'  and parentid != 0",name];
//    NSLog(@"%@--%d--%@",NSStringFromSelector(_cmd),__LINE__,sql);
    FMResultSet *rs = [db executeQuery:sql];//select * from Area where parent_code = '02'
//    NSLog(@"rs = %@",rs);
    while ([rs next]) {
        NSString *code = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"id"]];
//        NSLog(@"code = %@",code);
        
        return code;
    }
    
    
    [db close];
    return nil;
}

+(void)getCity:(NSMutableArray *)arr{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area_city" ofType:@"db"];//PN
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM area where postalcode <> 0 ORDER BY firstLetter,telCode"];
//    NSLog(@"%@--%d--%@",NSStringFromSelector(_cmd),__LINE__,sql);
    FMResultSet *rs = [db executeQuery:sql];//select * from Area where parent_code = '02'
//    NSLog(@"rs = %@",rs);
    
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    NSMutableArray *arr2 = [[NSMutableArray alloc]init];
    while ([rs next]) {
        NSString *code = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"name"]];
//        NSLog(@"code = %@",code);
        [arr1 addObject:code];
    }
    
    
    for (NSString *city in arr1) {
        if ([arr indexOfObject:city] == NSNotFound) {
            [arr2 addObject:city];
        }
    }
    
    
    
    [db close];
}
//查询所有的省份
+(NSMutableArray *)getProvinceArr
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area_city" ofType:@"db"];//PN
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM area where postalcode = 0 and parentid=0 ORDER BY firstLetter,telCode"];
//    NSLog(@"%@--%d--%@",NSStringFromSelector(_cmd),__LINE__,sql);
    FMResultSet *rs = [db executeQuery:sql];//select * from Area where parent_code = '02'
//    NSLog(@"rs = %@",rs);
    
    while ([rs next]) {
        NSString *code = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"name"]];
//        NSLog(@"code = %@",code);
        [arr addObject:code];
    }
    
    [db close];

    return arr;
}
#pragma mark -- 通过省查询相应的省id
+ (NSString *) getProvinceId:(NSString *)provinceName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area_city" ofType:@"db"];//PN
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    
    
    NSString* sqlStr = [NSString stringWithFormat: @"select id from area where name = '%@'and telcode='%@'",provinceName,@"0"];
    NSString *provinceId;
    
    FMResultSet* rs = nil;
    
    @synchronized(db) {
        rs = [db executeQuery:sqlStr];
    }
    while([rs next]) {
        
        
        provinceId = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"id"]];
        
    }
    
    [rs close];
    
    return provinceId;
}

//根据省ID查询市
+(NSMutableArray *)getCityArr:(NSString *)provinceId
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area_city" ofType:@"db"];//PN
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM area where parentid = %@ ORDER BY firstLetter,telCode",provinceId];
//    NSLog(@"%@--%d--%@",NSStringFromSelector(_cmd),__LINE__,sql);
    FMResultSet *rs = [db executeQuery:sql];//select * from Area where parent_code = '02'
//    NSLog(@"rs = %@",rs);
    
    while ([rs next]) {
        NSString *code = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"name"]];
//        NSLog(@"code = %@",code);
        [arr addObject:code];
    }
    
    [db close];
    
    return arr;
}
//根据ID查询名称
+(NSString *)getNameById:(NSString *)ID
{
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area_city" ofType:@"db"];//PN
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM area where id = %@",ID];
//    NSLog(@"%@--%d--%@",NSStringFromSelector(_cmd),__LINE__,sql);
    FMResultSet *rs = [db executeQuery:sql];//select * from Area where parent_code = '02'
//    NSLog(@"rs = %@",rs);
    
    while ([rs next]) {
        NSString *code = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"name"]];
//        NSLog(@"code = %@",code);
        return code;

    }
    
    [db close];
    
    return nil;

}

+(BOOL)isMoney:(NSString *)string {
    
    NSCharacterSet *cs;
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basicTest = [string isEqualToString:filtered];
    
    return basicTest;
    
}
+(BOOL)isPhone:(NSString *)str
{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    BOOL res1 = [regextestmobile evaluateWithObject:str];
//    BOOL res2 = [regextestcm evaluateWithObject:str];
//    BOOL res3 = [regextestcu evaluateWithObject:str];
//    BOOL res4 = [regextestct evaluateWithObject:str];
//    
//    if (res1 || res2 || res3 || res4 )
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    
  
    
//    手机号以1开头11位

    NSString *phoneRegex = @"^((1[0-9]))\\d{9}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isPhone = [phoneTest evaluateWithObject:str];
    return isPhone;
  
    
}
+(BOOL)isStringAndNumber:(NSString *)str
{
    NSString *regex = @"^[A-Za-z0-9]{6,16}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
   

}
//身份证校验
+(BOOL)isIdentityCard:(NSString *)str
{
    NSString *regex = @"^[A-Za-z0-9]{15,18}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
    
    
}
//银行卡校验
+(BOOL)isBankCard:(NSString *)str
{
    NSString *regex = @"^[A-Za-z0-9]{16,19}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
    
    
}
+(BOOL)isChineseAndStringAndNumber:(NSString *)str
{
    //匹配字符串是否由汉字，字母，数字组成，如果是返回YES
    NSString *regex = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,8}$";
//    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
//    NSString *regex = @"[`~!@#$%^&#$%^&amp;*()+=|{}':;',\\[\\].&#$%^&amp;*()+=|{}':;',\\[\\].&lt;&#$%^&amp;*()+=|{}':;',\\[\\].&lt;&gt;/?~！@#￥%……&#￥%……&amp;*（）——+|{}【】‘；：”“’。，、？]";

    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:str])
        return YES;
    else
        return NO;
    
    
}
+(BOOL)isUserName:(NSString *)str{
    //匹配字符串是否由汉字，字母，数字组成，如果是返回YES
    NSString *regex = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,20}$";
    //    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    //    NSString *regex = @"[`~!@#$%^&#$%^&amp;*()+=|{}':;',\\[\\].&#$%^&amp;*()+=|{}':;',\\[\\].&lt;&#$%^&amp;*()+=|{}':;',\\[\\].&lt;&gt;/?~！@#￥%……&#￥%……&amp;*（）——+|{}【】‘；：”“’。，、？]";
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:str])
        return YES;
    else
        return NO;

}
+(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2
{
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //km  返回
    //     return  distance*1000;
    
    //返回 m
    return   distance;
    
}
+(NSString *)distanceStrWithDistance:(double)distance
{
    NSString *distanceStr = nil;
    double k = distance/1000;
    if (k >1.0) {
        //千米
        distanceStr = [NSString stringWithFormat:@"%.fkm",k];
        return distanceStr;
    }else
    {
        distanceStr = [NSString stringWithFormat:@"%.fm",distance];
        return distanceStr;
    }
    
    
    return distanceStr;
}
+(NSString *)getTitle:(NSString *)second_category
{
    NSString *title = nil;
    switch (second_category.intValue) {
        case 0:
            title = @"推送消息";
            break;
        case 101:
            title = @"版本升级";
            break;
        case 102:
            title = @"退款通知";
            break;
        case 103:
            title = @"退款通知";
            break;
        case 104:
            title = @"投诉通知";
            break;
        case 105:
            title = @"提现通知";
            break;
        case 106:
            title = @"提现通知";
            break;
        case 108:
            title = @"退款通知";
            break;
        case 109:
            title = @"投诉通知";
            break;
        case 110:
            title = @"投诉通知";
            break;
        case 111:
            title = @"商品通知";
            break;
        case 112:
            title = @"支付通知";
            break;
        case 113:
            title = @"订单通知";
            break;
        case 114:
            title = @"提现通知";
            break;
        case 119:
            title = @"竞拍通知";
            break;
        case 121:
            title = @"意见处理通知";
            break;
        default:
            break;
    }
    return title;
}
+ (NSString *)changeNSNull:(NSString *)str
{
//    NSString *s = nil;
//    if ([str isKindOfClass:[NSNull class]])
//    {
//        return s;
//    }
//    else
//        return str;
    NSString *s = @"";
    if ([str isEqualToString:@"<null>"]|| [str isEqualToString:@"(null)"])
    {
        return s;
    }
    else
        return str;
}
+ (NSString *)stringWithOrderStatus:(NSString *)order_status
{
    switch (order_status.intValue) {
        case 1:
            return @"  待付款";
            break;
        case 20:
            return @"  已收货";
            break;
        case 6:
            return @"超时取消";
            break;
        case 5:
            return @"订单取消";
            break;
        case 25:
            return @"  退款中";
            break;
        case 30:
            return @"退款完成";
            break;
        case 31:
            return @"部分退款";
            break;
        case 10:
            return @"  已支付";
            break;
        case 15:
            return @"  已发货";
            break;
            
        case 35:
            return @"交易完成";
            break;
            
        default:
            return @"";
            break;
    }
}
+(NSInteger)getPayType:(NSInteger)payType
{
    //1:买票 2:充值
    NSInteger iPayType = payType;
    return iPayType;
}
////转换成百度坐标算法
//+(CLLocationCoordinate2D)getbaiduWithlat:(double)lat withLog:(double)log
//{
//    double bd_lat;
//    double bd_lon;
////    double x = 39.940746307372997, y = 116.327285766602;
//     double x = lat, y = log;
//    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
//    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
//    bd_lon = z * cos(theta) + 0.0065;
//    bd_lat = z * sin(theta) + 0.006;
//    
//    CLLocationCoordinate2D bdLocation = CLLocationCoordinate2DMake(bd_lon, bd_lat);
//    return bdLocation;
//}
//+(CLLocationCoordinate2D)bd_encrypt:(double)gg_lat lon:(double)gg_lon bdLat:(double)bd_lat bdLon:(double)bd_lon
//{
//    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
//    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
//    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
//    gg_lon = z * cos(theta);
//    gg_lat = z * sin(theta);
//    CLLocationCoordinate2D bdLocation = CLLocationCoordinate2DMake(gg_lon, gg_lat);
//    return bdLocation;
//
//}


+ (NSString *)getMessageInfoStatus:(int)status
{
    int messageStatus = status;
    
    
    
    
    
    //    1：等待支付
    //    5：订单取消
    //    6：支付超时 订单取消
    //    10：已支付 待发货
    //    15：已发货
    //    20：已收货
    //    21：待收款
    //    25：退款中
    //    30：已退款
    //    31：已部分退款
    //    35：已收款
    
    NSString *value = nil;
    
    switch (messageStatus) {
            
            
        case 1:
            value = @"待付款";
            break;
        case 5:
            value = @"订单取消";
            break;
        case 6:
            value = @"超时取消";
            break;
        case 10:
            value = @"已支付";
            break;
        case 15:
            value = @"已发货";
            break;
        case 20:
            value = @"已收货";
            break;
        case 21:
            value = @"待收款";
            break;
        case 25:
            value = @"退款中";
            break;
        case 30:
            value = @"退款完成";
            break;
        case 31:
            value = @"部分退款完成";
            break;
        case 35:
            value = @"交易完成";
            break;
        default:
            break;
    }
    return value;
}

//保存所有系统变量的方法
+(void)SaveSysConfig{
    NSString *err = nil;
    NSString *file = [[self getDocumentPath ] stringByAppendingPathComponent:CONFIG_FILE_PATH];
    //
    NSMutableDictionary *saveConfig = [[NSMutableDictionary alloc] init];
    //
    id key;
    NSEnumerator *enumerator = [sysConfig keyEnumerator];
    while (key = [enumerator nextObject]) {
        
        if([[key substringToIndex:1] isEqualToString:@"_"] )
        {
            [saveConfig setObject:[sysConfig valueForKey:key] forKey:key];
            //	NSLog(@"saveconfigkey=%@,%@",key,[saveConfig valueForKey:key]);
        }
        
    }
    //NSLog(saveConfig);
    
    //
    NSData *pd = [NSPropertyListSerialization dataFromPropertyList:saveConfig format:NSPropertyListXMLFormat_v1_0 errorDescription:&err];
    if(nil == err)
        [pd writeToFile:file atomically:YES];
    
    
}

//分享时随机返回一段文字用于显示
+ (NSString *)getRandomShareText
{
    NSString *string1 = @"我在票乎发现了这个，你快看看";
    NSString *string2 = @"这个票，票乎竟然有，快看";
    NSString *string3 = @"票乎发现了这个，一般人我不告诉他";
    int rand = arc4random()%3+1;
    if(rand==1)
    {
        return string1;
    }
    if(rand==2)
    {
        return string2;
    }
    if(rand==3)
    {
        return string3;
    }
    return nil;
}

// 初始化富文本类
+ (void)initEMStringWithdefaultFont:(CGFloat)defaultFont strongFont:(CGFloat)strongFont defaultTextColor:(NSString *)defaultTextColor strongTextColor:(NSString *)strongTextColor
{
    [EMStringStylingConfiguration sharedInstance].defaultFont  = [UIFont systemFontOfSize:defaultFont];
    [EMStringStylingConfiguration sharedInstance].strongFont   = [UIFont systemFontOfSize:strongFont];
    // The code tag a little bit like in Github (custom font, custom color, a background color)
    EMStylingClass *aStylingClass = [[EMStylingClass alloc] initWithMarkup:@"<red>"];
    aStylingClass.color           = [ColorUtility colorWithHexString:strongTextColor];
    aStylingClass.font            = [UIFont boldSystemFontOfSize:strongFont];
    aStylingClass.attributes      = @{NSBackgroundColorAttributeName : [UIColor clearColor]};//背景色
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    aStylingClass       = [[EMStylingClass alloc] initWithMarkup:@"<black>"];
    aStylingClass.color = [ColorUtility colorWithHexString:defaultTextColor];
    aStylingClass.font  = [UIFont systemFontOfSize:defaultFont];
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
}
//字符串为空判断
+(BOOL)stringisNULL:(NSString *)str
{
    if ([str isEqualToString:@""] || [str isEqualToString:@"<null>"]|| str == nil || [str isKindOfClass:[NSNull class]]||[str isEqualToString:@" "]) {
        return YES;
    }else{
        return NO;
    }
}
//字典转字符串
+(NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
    
    
}
//字符串转字典
+(NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        //        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark -- 获取相机的权限
+(BOOL)getTheCameraPermissions
{
    __block BOOL  flag = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        PHAlertView *alert = [[PHAlertView alloc]initWithLeftTitle:@"取消" rightTitle:@"设置" contentTitle:@"系统无法开启摄像头，请先开启权限" contentView:nil alertImage:@"turnTicket_prompt" alertImageWidth:80 alertTitle:@"提示"];
        [alert show];
        alert.rightBlock= ^() {
            //跳转iPhone摄像头权限开关界面
            if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=INTERNET_TETHERING"]];
            }
        };
        alert.leftBlock = ^(){
            //回到入口页面
        };
    }
    else
    {
        flag = YES;
    }
    return flag;
}
#pragma mark -- 根据时间戳获取星期几
+(NSString *)getWeekDayFordateString:(NSString *)dataString
{
    double timeDate = [dataString doubleValue]/1000;
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:timeDate];//
    
//    long long data = [dataString longLongValue];
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
//    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
    
//    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
//    NSDate *date = [NSDate date];
//    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
//    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
//    NSInteger unitFlags = NSYearCalendarUnit |
//    NSMonthCalendarUnit |
//    NSDayCalendarUnit |
//    NSWeekdayCalendarUnit |
//    NSHourCalendarUnit |
//    NSMinuteCalendarUnit |
//    NSSecondCalendarUnit;
//    comps = [calendar components:unitFlags fromDate:date];
//    int week = [comps weekday];
}
#pragma mark -- 根据时间戳获取2016.06.25 星期六19:30的格式
+(NSString *)getDateAndWeekAndTimeForDateString:(NSString *)dataString
{
    NSString *date = [self getStringFromDateTime:dataString andDataFormat:@"yyyy.MM.dd"];
    NSString *weekString = [self getWeekDayFordateString:dataString];
    NSString *timeString = [self getStringFromDateTime:dataString andDataFormat:@"HH:mm"];
    
    NSString *togetherString = [NSString stringWithFormat:@"%@ %@%@",date,weekString,timeString];
    return togetherString;
}

#pragma mark -- 与现在对比相隔时间
+ (int)intervalSinceNow:(NSString *)theDate
{
    double timeDate = [theDate doubleValue]/1000;
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:timeDate];
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSString *timeString = @"";
    NSTimeInterval cha = [d timeIntervalSinceDate:dat];
    
    //返回距现在相距多少分钟
    if (cha/60>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
    return -1;
}
#pragma mark -- 把手机号换4位*显示
+(NSString *)changeEncryptionMobile:(NSString *)mobile
{
    NSString *thePrefix = [mobile substringToIndex:3];
    NSString *theSuffix = [mobile substringFromIndex:7];
    NSString *result = [NSString stringWithFormat:@"%@****%@",thePrefix,theSuffix];
    return result;
}
#pragma mark - 获取字符串size
+(CGSize)sizeOfTextContent:(NSString *)textContent text_w:(CGFloat)text_w text_h:(CGFloat)text_h text_font:(NSInteger)text_font
{
    
    CGSize titleSize = [textContent boundingRectWithSize:CGSizeMake(text_w, text_h) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:text_font]} context:nil].size;
    return titleSize;
}
@end
