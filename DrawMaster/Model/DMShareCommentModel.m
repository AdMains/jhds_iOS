//
//  DMShareCommentModel.m
//  DrawMaster
//
//  Created by git on 16/10/13.
//  Copyright © 2016年 QuanGe. All rights reserved.
//

#import "DMShareCommentModel.h"
#import "WeiboUser.h"
@implementation DMShareCommentModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"created_at":@"created_at",
             @"text":@"text",
             @"user":@"user"
             };
}

- (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"EEE MMM d HH:mm:ss Z yyyy"];
    //必须设置，否则无法解析
    dateFormatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    [[NSUserDefaults standardUserDefaults] setObject:destDate forKey:@"now"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDate *now = [[NSUserDefaults standardUserDefaults] valueForKey:@"now"];
    return now;
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    WeiboUser * tmpUser = [WeiboUser userWithDictionary:self.user];
    self.nickName = tmpUser.screenName;
    self.userIcon = tmpUser.profileImageUrl;
    self.created_at = [[self dateFromString:self.created_at] qgocc_timestampForDate];
    self.text = [NSString stringWithFormat:@"<meta charset=\"UTF-8\"> <p style=\"line-height: 1.5;font-size:13px;\">%@</p>",self.text];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"splash0" ofType:@"jpg"];
    path = [path substringToIndex:path.length - @"splash0.jpg".length];
    
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[爱你]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_aini.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[奥特曼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_aoteman.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[拜拜]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_baibai.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[悲伤]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_beishang.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[鄙视]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_bishi.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[闭嘴]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_bizui.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[馋嘴]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_chanzui.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[吃惊]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_chijing.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[哈欠]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_dahaqi.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[打脸]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_dalian.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[顶]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_ding.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[doge]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_doge.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[肥皂]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_feizao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[感冒]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_ganmao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[鼓掌]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_guzhang.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[哈哈]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_haha.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[害羞]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_haixiu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[汗]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_han.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[呵呵]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_hehe.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[微笑]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_hehe.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[黑线]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_heixian.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[哼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_heng.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[花心]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_huaxin.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[挤眼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_jiyan.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[可爱]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_keai.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[可怜]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_kelian.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[酷]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_ku.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[困]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_kun.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[懒得理你]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_landelini.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[浪]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_lang.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[泪]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_lei.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[喵喵]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_miao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[男孩儿]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_nanhaier.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[怒]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_nu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[愤怒]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_nu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[怒骂]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_numa.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[女孩儿]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_nvhaier.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[钱]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_qian.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[亲亲]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_qinqin.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[傻眼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_shayan.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[生病]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_shengbing.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[神兽]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_shenshou.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[草泥马]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_shenshou.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[失望]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_shiwang.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[衰]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_shuai.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[睡觉]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_shuijiao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[睡]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_shuijiao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[思考]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_sikao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[太开心]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_taikaixin.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[抱抱]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_taikaixin.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[偷笑]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_touxiao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[吐]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_tu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[兔子]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_tuzi.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[挖鼻]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_wabishi.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[委屈]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_weiqu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[笑cry]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_xiaoku.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[熊猫]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_xiongmao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[嘻嘻]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_xixi.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[嘘]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_xu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[阴险]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_yinxian.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[疑问]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_yiwen.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[右哼哼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_youhengheng.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[晕]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_yun.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[抓狂]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_zhuakuang.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[猪头]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_zhutou.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[最右]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_zuiyou.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[左哼哼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_zuohengheng.png\"/>",path]];
    
    //浪小花表情
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[悲催]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_beicui.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[被电]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_beidian.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[崩溃]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_bengkui.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[别烦我]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_biefanwo.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[不好意思]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_buhaoyisi.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[不想上班]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_buxiangshangban.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[得意地笑]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_deyidexiao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[给劲]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_feijin.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[好爱哦]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_haoaio.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[好棒]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_haobang.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[好囧]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_haojiong.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[好喜欢]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_haoxihuan.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[hold住]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_holdzhu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[杰克逊]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_jiekexun.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[纠结]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_jiujie.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[巨汗]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_juhan.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[抠鼻屎]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_koubishi.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[困死了]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_kunsile.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[雷锋]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_leifeng.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[泪流满面]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_leiliumanmian.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[玫瑰]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_meigui.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[噢耶]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_oye.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[霹雳]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_pili.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[瞧瞧]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_qiaoqiao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[丘比特]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_qiubite.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[求关注]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_qiuguanzhu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[群体围观]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_quntiweiguan.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[甩甩手]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_shuaishuaishou.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[偷乐]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_toule.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[推荐]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_tuijian.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[互相膜拜]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_xianghumobai.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[想一想]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_xiangyixiang.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[笑哈哈]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_xiaohaha.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[羞嗒嗒]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_xiudada.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[许愿]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_xuyuan.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[有鸭梨]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_youyali.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[赞啊]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_zana.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[震惊]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_zhenjing.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[转发]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_zhuanfa.png\"/>",path]];
    
    //其他
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[蛋糕]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_dangao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[飞机]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_feiji.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[干杯]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_ganbei.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[话筒]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_huatong.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[蜡烛]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_lazhu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[礼物]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_liwu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[围观]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_weiguan.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[咖啡]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_kafei.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[足球]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_zuqiu.png\"/>",path]];
    
    
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[ok]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/h_ok.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[躁狂症]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxh_zaokuangzheng.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[威武]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/weiwu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[赞]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/h_zan.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[心]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/l_xin.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[伤心]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/l_shangxin.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[月亮]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/w_yueliang.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[鲜花]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/w_xianhua.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[太阳]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/w_taiyang.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[威武]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/weiwu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[浮云]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/w_fuyun.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[神马]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/shenma.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[微风]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/w_weifeng.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[下雨]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/w_xiayu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[色]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/huaxin.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[沙尘暴]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/w_shachenbao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[落叶]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/w_luoye.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[雪人]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/w_xueren.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[good]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/h_good.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[哆啦A梦吃惊]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/dorahaose_mobile.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[哆啦A梦微笑]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/jqmweixiao_mobile.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[哆啦A梦花心]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/dorahaose_mobile.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[弱]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/ruo.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[炸鸡啤酒]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/d_zhajipijiu.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[囧]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/jiong.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[NO]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/buyao.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[来]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/guolai.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[互粉]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/f_hufen.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[握手]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/h_woshou.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[haha]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/h_haha.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[织]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/zhi.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[萌]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/meng.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[钟]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_zhong.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[给力]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/geili.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[喜]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/xi.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[绿丝带]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_lvsidai.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[围脖]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/weibo.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[音乐]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_yinyue.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[照相机]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_zhaoxiangji.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[耶]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/h_ye.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[拍照]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lxhpz_paizhao.gif\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[白眼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/landeln_baiyan.gif\"/>",path]];
    
    
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[作揖]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/o_zuoyi.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[拳头]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/quantou_org.gif\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[X教授]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/xman_jiaoshou.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[天启]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/xman_tianqi.gif\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[抢到啦]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/hb_qiangdao_org.gif\"/>",path]];
    
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[大笑]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/smiley.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[花痴]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/heart_eyes.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[斜眼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/unamused.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[脸红]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/flushed.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[傻笑]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/grin.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[飞吻]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/kissing_heart.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[眨眼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/wink.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[生气]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/angry.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[难过]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/disappointed.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[紧张]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/disappointed_relieved.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[大哭]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/sob.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[吐舌头]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/stuck_out_tongue_closed_eyes.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[愤怒]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/rage.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[崩溃]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/persevere.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[闭眼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/pensive.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[开心]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/smile.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[口罩]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/mask.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[亲亲]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/kissing_closed_eyes.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[汗]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/sweat.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[眼泪]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/joy.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[微笑]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/blush.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[鼻涕]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/cry.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[鬼脸二]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/stuck_out_tongue_winking_eye.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[惊讶]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/fearful.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[害怕]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/cold_sweat.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[星星眼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/astonished.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[坏笑]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/smirk.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[惊恐]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/scream.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[瞌睡]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/sleepy.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[抓狂]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/confounded.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[闭眼]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/relieved.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[妖怪]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/smiling_imp.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[幽灵]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/ghost.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[圣诞老人]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/santa.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[女孩]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/girl.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[男孩]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/boy.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[阿姨]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/woman.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[大叔]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/man.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[狗]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/dog.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[猫咪]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/cat.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[强]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/thumbsup.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[贬低]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/thumbsdown.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[拳头]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/facepunch.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[拳头二]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/fist.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[胜利]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/v.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[强壮]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/muscle.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[鼓掌]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/clap.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[向左]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/point_left.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[上]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/point_up_2.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[向右]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/point_right.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[下]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/point_down.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[好]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/ok_hand.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[爱心]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/heart.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[心碎]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/broken_heart.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[祈祷]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/pray.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[太阳]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/sunny.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[月亮]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/crescent_moon.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[星星]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/star.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[闪电]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/zap.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[白云]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/cloud.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[下雨]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/umbrella.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[枫叶]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/maple_leaf.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[向日葵]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/sunflower.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[绿叶]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/leaves.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[裙子]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/dress.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[蝴蝶结]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/ribbon.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[张嘴]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/lips.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[玫瑰]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/rose.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[咖啡]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/coffee.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[蛋糕]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/birthday.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[十点钟]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/clock10.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[啤酒]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/beer.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[放大镜]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/mag.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[iphone]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/iphone.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[家]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/house.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[小汽车]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/car.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[礼物]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/gift.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[足球]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/soccer.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[炸弹]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/bomb.png\"/>",path]];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"[钻石]" withString:[NSString stringWithFormat:@"<img style=\"max-width:20;vertical-align:-5px;\" src=\"file://%@/emoji/gem.png\"/>",path]];
    self.attributedText = [[NSAttributedString alloc]
                           initWithData: [self.text dataUsingEncoding:NSUTF8StringEncoding]
                           options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                           documentAttributes:nil error:nil];
    
    self.textHeight = [self.attributedText boundingRectWithSize:CGSizeMake(mScreenWidth-8*3-40-10, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size.height+10;

    return self;
}
@end
