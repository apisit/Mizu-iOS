//
//  InternationalCallingCodeService.m
//  Macro
//
//  Created by Apisit Toompakdee on 6/27/12.
//  Copyright (c) 2012 All rights reserved.
//

#import "InternationalCallingCodeService.h"

@implementation CallingCode

@end

@implementation InternationalCallingCodeService

+(NSArray*)getAvailableCodes{
    NSMutableDictionary* callingCodeDictionary = [[NSMutableDictionary alloc]init];
    [callingCodeDictionary setValue:@"81" forKey:@"JP"];
    [callingCodeDictionary setValue:@"962" forKey:@"JO"];
    [callingCodeDictionary setValue:@"268" forKey:@"SZ"];
    [callingCodeDictionary setValue:@"690" forKey:@"TK"];
    [callingCodeDictionary setValue:@"380" forKey:@"UA"];
    [callingCodeDictionary setValue:@"507" forKey:@"PA"];
    [callingCodeDictionary setValue:@"1" forKey:@"BB"];
    [callingCodeDictionary setValue:@"63" forKey:@"PH"];
    [callingCodeDictionary setValue:@"1" forKey:@"VC"];
    [callingCodeDictionary setValue:@"245" forKey:@"GW"];
    [callingCodeDictionary setValue:@"1" forKey:@"GU"];
    [callingCodeDictionary setValue:@"385" forKey:@"HR"];
    [callingCodeDictionary setValue:@"1" forKey:@"MP"];
    [callingCodeDictionary setValue:@"56" forKey:@"CL"];
    [callingCodeDictionary setValue:@"264" forKey:@"NA"];
    [callingCodeDictionary setValue:@"1" forKey:@"KN"];
    [callingCodeDictionary setValue:@"960" forKey:@"MV"];
    [callingCodeDictionary setValue:@"682" forKey:@"CK"];
    [callingCodeDictionary setValue:@"350" forKey:@"GI"];
    [callingCodeDictionary setValue:@"220" forKey:@"GM"];
    [callingCodeDictionary setValue:@"373" forKey:@"MD"];
    [callingCodeDictionary setValue:@"291" forKey:@"ER"];
    [callingCodeDictionary setValue:@"505" forKey:@"NI"];
    [callingCodeDictionary setValue:@"237" forKey:@"CM"];
    [callingCodeDictionary setValue:@"996" forKey:@"KG"];
    [callingCodeDictionary setValue:@"597" forKey:@"SR"];
    [callingCodeDictionary setValue:@"95" forKey:@"MM"];
    [callingCodeDictionary setValue:@"265" forKey:@"MW"];
    [callingCodeDictionary setValue:@"299" forKey:@"GL"];
    [callingCodeDictionary setValue:@"212" forKey:@"EH"];
    [callingCodeDictionary setValue:@"298" forKey:@"FO"];
    [callingCodeDictionary setValue:@"249" forKey:@"SD"];
    [callingCodeDictionary setValue:@"1" forKey:@"IO"];
    [callingCodeDictionary setValue:@"260" forKey:@"ZM"];
    [callingCodeDictionary setValue:@"93" forKey:@"AF"];
    [callingCodeDictionary setValue:@"238" forKey:@"CV"];
    [callingCodeDictionary setValue:@"1" forKey:@"TC"];
    [callingCodeDictionary setValue:@"371" forKey:@"LV"];
    [callingCodeDictionary setValue:@"55" forKey:@"BR"];
    [callingCodeDictionary setValue:@"358" forKey:@"FI"];
    [callingCodeDictionary setValue:@"675" forKey:@"PG"];
    [callingCodeDictionary setValue:@"357" forKey:@"CY"];
    [callingCodeDictionary setValue:@"509" forKey:@"HT"];
    [callingCodeDictionary setValue:@"699" forKey:@"UM"];
    [callingCodeDictionary setValue:@"1" forKey:@"AS"];
    [callingCodeDictionary setValue:@"1" forKey:@"PR"];
    [callingCodeDictionary setValue:@"689" forKey:@"TF"];
    [callingCodeDictionary setValue:@"377" forKey:@"MC"];
    [callingCodeDictionary setValue:@"1" forKey:@"CA"];
    [callingCodeDictionary setValue:@"354" forKey:@"IS"];
    [callingCodeDictionary setValue:@"64" forKey:@"NZ"];
    [callingCodeDictionary setValue:@"387" forKey:@"BA"];
    [callingCodeDictionary setValue:@"679" forKey:@"FJ"];
    [callingCodeDictionary setValue:@"676" forKey:@"TO"];
    [callingCodeDictionary setValue:@"356" forKey:@"MT"];
    [callingCodeDictionary setValue:@"84" forKey:@"VN"];
    [callingCodeDictionary setValue:@"351" forKey:@"PT"];
    [callingCodeDictionary setValue:@"358" forKey:@"AX"];
    [callingCodeDictionary setValue:@"965" forKey:@"KW"];
    [callingCodeDictionary setValue:@"687" forKey:@"NC"];
    [callingCodeDictionary setValue:@"856" forKey:@"LA"];
    [callingCodeDictionary setValue:@"221" forKey:@"SN"];
    [callingCodeDictionary setValue:@"46" forKey:@"SE"];
    [callingCodeDictionary setValue:@"1" forKey:@"DO"];
    [callingCodeDictionary setValue:@"973" forKey:@"BH"];
    [callingCodeDictionary setValue:@"269" forKey:@"YT"];
    [callingCodeDictionary setValue:@"355" forKey:@"AL"];
    [callingCodeDictionary setValue:@"31" forKey:@"NL"];
    [callingCodeDictionary setValue:@"420" forKey:@"CZ"];
    [callingCodeDictionary setValue:@"974" forKey:@"QA"];
    [callingCodeDictionary setValue:@"54" forKey:@"AR"];
    [callingCodeDictionary setValue:@"235" forKey:@"TD"];
    [callingCodeDictionary setValue:@"269" forKey:@"KM"];
    [callingCodeDictionary setValue:@"41" forKey:@"CH"];
    [callingCodeDictionary setValue:@"1" forKey:@"BS"];
    [callingCodeDictionary setValue:@"677" forKey:@"SB"];
    [callingCodeDictionary setValue:@"248" forKey:@"SC"];
    [callingCodeDictionary setValue:@"853" forKey:@"MO"];
    [callingCodeDictionary setValue:@"353" forKey:@"IE"];
    [callingCodeDictionary setValue:@"672" forKey:@"AQ"];
    [callingCodeDictionary setValue:@"267" forKey:@"BW"];
    [callingCodeDictionary setValue:@"1" forKey:@"MS"];
    [callingCodeDictionary setValue:@"232" forKey:@"SL"];
    [callingCodeDictionary setValue:@"850" forKey:@"KP"];
    [callingCodeDictionary setValue:@"256" forKey:@"UG"];
    [callingCodeDictionary setValue:@"886" forKey:@"TW"];
    [callingCodeDictionary setValue:@"685" forKey:@"WS"];
    [callingCodeDictionary setValue:@"977" forKey:@"NP"];
    [callingCodeDictionary setValue:@"683" forKey:@"NU"];
    [callingCodeDictionary setValue:@"226" forKey:@"BF"];
    [callingCodeDictionary setValue:@"227" forKey:@"NE"];
    [callingCodeDictionary setValue:@"231" forKey:@"LR"];
    [callingCodeDictionary setValue:@"966" forKey:@"SA"];
    [callingCodeDictionary setValue:@"242" forKey:@"CG"];
    [callingCodeDictionary setValue:@"975" forKey:@"BT"];
    [callingCodeDictionary setValue:@"33" forKey:@"FR"];
    [callingCodeDictionary setValue:@"20" forKey:@"EG"];
    [callingCodeDictionary setValue:@"7" forKey:@"KZ"];
    [callingCodeDictionary setValue:@"225" forKey:@"CI"];
    [callingCodeDictionary setValue:@"252" forKey:@"SO"];
    [callingCodeDictionary setValue:@"222" forKey:@"MR"];
    [callingCodeDictionary setValue:@"228" forKey:@"TG"];
    [callingCodeDictionary setValue:@"382" forKey:@"ME"];
    [callingCodeDictionary setValue:@"257" forKey:@"BI"];
    [callingCodeDictionary setValue:@"599" forKey:@"AN"];
    [callingCodeDictionary setValue:@"971" forKey:@"AE"];
    [callingCodeDictionary setValue:@"90" forKey:@"TR"];
    [callingCodeDictionary setValue:@"1" forKey:@"JM"];
    [callingCodeDictionary setValue:@"82" forKey:@"KR"];
    [callingCodeDictionary setValue:@"596" forKey:@"MQ"];
    [callingCodeDictionary setValue:@"254" forKey:@"KE"];
    [callingCodeDictionary setValue:@"381" forKey:@"RS"];
    [callingCodeDictionary setValue:@"686" forKey:@"KI"];
    [callingCodeDictionary setValue:@"47" forKey:@"SJ"];
    [callingCodeDictionary setValue:@"48" forKey:@"PL"];
    [callingCodeDictionary setValue:@"852" forKey:@"HK"];
    [callingCodeDictionary setValue:@"216" forKey:@"TN"];
    [callingCodeDictionary setValue:@"670" forKey:@"TL"];
    [callingCodeDictionary setValue:@"973" forKey:@"IL"];
    [callingCodeDictionary setValue:@"692" forKey:@"MH"];
    [callingCodeDictionary setValue:@"49" forKey:@"DE"];
    [callingCodeDictionary setValue:@"236" forKey:@"CF"];
    [callingCodeDictionary setValue:@"379" forKey:@"VA"];
    [callingCodeDictionary setValue:@"92" forKey:@"PK"];
    [callingCodeDictionary setValue:@"691" forKey:@"FM"];
    [callingCodeDictionary setValue:@"508" forKey:@"PM"];
    [callingCodeDictionary setValue:@"594" forKey:@"GF"];
    [callingCodeDictionary setValue:@"250" forKey:@"RW"];
    [callingCodeDictionary setValue:@"1" forKey:@"MF"];
    [callingCodeDictionary setValue:@"595" forKey:@"PY"];
    [callingCodeDictionary setValue:@"51" forKey:@"PE"];
    [callingCodeDictionary setValue:@"375" forKey:@"BY"];
    [callingCodeDictionary setValue:@"266" forKey:@"LS"];
    [callingCodeDictionary setValue:@"591" forKey:@"BO"];
    [callingCodeDictionary setValue:@"54" forKey:@"SG"];
    [callingCodeDictionary setValue:@"3474415" forKey:@"HM"];
    [callingCodeDictionary setValue:@"359" forKey:@"BG"];
    [callingCodeDictionary setValue:@"251" forKey:@"ET"];
    [callingCodeDictionary setValue:@"968" forKey:@"OM"];
    [callingCodeDictionary setValue:@"680" forKey:@"PW"];
    [callingCodeDictionary setValue:@"229" forKey:@"BJ"];
    [callingCodeDictionary setValue:@"32" forKey:@"BE"];
    [callingCodeDictionary setValue:@"421" forKey:@"SK"];
    [callingCodeDictionary setValue:@"241" forKey:@"GA"];
    [callingCodeDictionary setValue:@"255" forKey:@"TZ"];
    [callingCodeDictionary setValue:@"" forKey:@"BV"];
    [callingCodeDictionary setValue:@"261" forKey:@"MG"];
    [callingCodeDictionary setValue:@"378" forKey:@"SM"];
    [callingCodeDictionary setValue:@"502" forKey:@"GT"];
    [callingCodeDictionary setValue:@"1" forKey:@"BM"];
    [callingCodeDictionary setValue:@"1" forKey:@"AG"];
    [callingCodeDictionary setValue:@"62" forKey:@"ID"];
    [callingCodeDictionary setValue:@"262" forKey:@"RE"];
    [callingCodeDictionary setValue:@"500" forKey:@"FK"];
    [callingCodeDictionary setValue:@"212" forKey:@"MA"];
    [callingCodeDictionary setValue:@"352" forKey:@"LU"];
    [callingCodeDictionary setValue:@"36" forKey:@"HU"];
    [callingCodeDictionary setValue:@"57" forKey:@"CO"];
    [callingCodeDictionary setValue:@"374" forKey:@"AM"];
    [callingCodeDictionary setValue:@"995" forKey:@"GE"];
    [callingCodeDictionary setValue:@"233" forKey:@"GH"];
    [callingCodeDictionary setValue:@"994" forKey:@"AZ"];
    [callingCodeDictionary setValue:@"1" forKey:@"VG"];
    [callingCodeDictionary setValue:@"66" forKey:@"TH"];
    [callingCodeDictionary setValue:@" " forKey:@"CC"];
    [callingCodeDictionary setValue:@"880" forKey:@"BD"];
    [callingCodeDictionary setValue:@"423" forKey:@"LI"];
    [callingCodeDictionary setValue:@"967" forKey:@"YE"];
    [callingCodeDictionary setValue:@"297" forKey:@"AW"];
    [callingCodeDictionary setValue:@"94" forKey:@"LK"];
    [callingCodeDictionary setValue:@"91" forKey:@"IN"];
    [callingCodeDictionary setValue:@"970" forKey:@"PS"];
    [callingCodeDictionary setValue:@"230" forKey:@"MU"];
    [callingCodeDictionary setValue:@"504" forKey:@"HN"];
    [callingCodeDictionary setValue:@"1" forKey:@"GD"];
    [callingCodeDictionary setValue:@"961" forKey:@"LB"];
    [callingCodeDictionary setValue:@"376" forKey:@"AD"];
    [callingCodeDictionary setValue:@"681" forKey:@"WF"];
    [callingCodeDictionary setValue:@"1" forKey:@"TT"];
    [callingCodeDictionary setValue:@"674" forKey:@"NR"];
    [callingCodeDictionary setValue:@"86" forKey:@"CN"];
    [callingCodeDictionary setValue:@"34" forKey:@"ES"];
    [callingCodeDictionary setValue:@"44" forKey:@"GB"];
    [callingCodeDictionary setValue:@" " forKey:@"IM"];
    [callingCodeDictionary setValue:@"263" forKey:@"ZW"];
    [callingCodeDictionary setValue:@"218" forKey:@"LY"];
    [callingCodeDictionary setValue:@"506" forKey:@"CR"];
    [callingCodeDictionary setValue:@"224" forKey:@"GN"];
    [callingCodeDictionary setValue:@"689" forKey:@"PF"];
    [callingCodeDictionary setValue:@"58" forKey:@"VE"];
    [callingCodeDictionary setValue:@"39" forKey:@"IT"];
    [callingCodeDictionary setValue:@"30" forKey:@"GR"];
    [callingCodeDictionary setValue:@"590" forKey:@"BL"];
    [callingCodeDictionary setValue:@"678" forKey:@"VU"];
    [callingCodeDictionary setValue:@"598" forKey:@"UY"];
    [callingCodeDictionary setValue:@"1" forKey:@"AI"];
    [callingCodeDictionary setValue:@"389" forKey:@"MK"];
    [callingCodeDictionary setValue:@"386" forKey:@"SI"];
    [callingCodeDictionary setValue:@"98" forKey:@"IR"];
    [callingCodeDictionary setValue:@"" forKey:@"GS"];
    [callingCodeDictionary setValue:@"1" forKey:@"LC"];
    [callingCodeDictionary setValue:@"688" forKey:@"TV"];
    [callingCodeDictionary setValue:@"43" forKey:@"AT"];
    [callingCodeDictionary setValue:@"870" forKey:@"PN"];
    [callingCodeDictionary setValue:@"992" forKey:@"TJ"];
    [callingCodeDictionary setValue:@"40" forKey:@"RO"];
    [callingCodeDictionary setValue:@"963" forKey:@"SY"];
    [callingCodeDictionary setValue:@"672" forKey:@"NF"];
    [callingCodeDictionary setValue:@"47" forKey:@"NO"];
    [callingCodeDictionary setValue:@"290" forKey:@"SH"];
    [callingCodeDictionary setValue:@"590" forKey:@"GP"];
    [callingCodeDictionary setValue:@"253" forKey:@"DJ"];
    [callingCodeDictionary setValue:@"258" forKey:@"MZ"];
    [callingCodeDictionary setValue:@"998" forKey:@"UZ"];
    [callingCodeDictionary setValue:@"52" forKey:@"MX"];
    [callingCodeDictionary setValue:@"1" forKey:@"KY"];
    [callingCodeDictionary setValue:@" " forKey:@"JE"];
    [callingCodeDictionary setValue:@"223" forKey:@"ML"];
    [callingCodeDictionary setValue:@"1" forKey:@"US"];
    [callingCodeDictionary setValue:@"372" forKey:@"EE"];
    [callingCodeDictionary setValue:@"242" forKey:@"CD"];
    [callingCodeDictionary setValue:@"501" forKey:@"BZ"];
    [callingCodeDictionary setValue:@"964" forKey:@"IQ"];
    [callingCodeDictionary setValue:@"1" forKey:@"VI"];
    [callingCodeDictionary setValue:@"855" forKey:@"KH"];
    [callingCodeDictionary setValue:@"993" forKey:@"TM"];
    [callingCodeDictionary setValue:@"7" forKey:@"RU"];
    [callingCodeDictionary setValue:@"61" forKey:@"CX"];
    [callingCodeDictionary setValue:@"1" forKey:@"DM"];
    [callingCodeDictionary setValue:@"593" forKey:@"EC"];
    [callingCodeDictionary setValue:@"244" forKey:@"AO"];
    [callingCodeDictionary setValue:@"370" forKey:@"LT"];
    [callingCodeDictionary setValue:@"239" forKey:@"ST"];
    [callingCodeDictionary setValue:@"45" forKey:@"DK"];
    [callingCodeDictionary setValue:@"213" forKey:@"DZ"];
    [callingCodeDictionary setValue:@"673" forKey:@"BN"];
    [callingCodeDictionary setValue:@"60" forKey:@"MY"];
    [callingCodeDictionary setValue:@"240" forKey:@"GQ"];
    [callingCodeDictionary setValue:@"27" forKey:@"ZA"];
    [callingCodeDictionary setValue:@"53" forKey:@"CU"];
    [callingCodeDictionary setValue:@"234" forKey:@"NG"];
    [callingCodeDictionary setValue:@"61" forKey:@"AU"];
    [callingCodeDictionary setValue:@"" forKey:@"GG"];
    [callingCodeDictionary setValue:@"592" forKey:@"GY"];
    [callingCodeDictionary setValue:@"976" forKey:@"MN"];
    [callingCodeDictionary setValue:@"503" forKey:@"SV"];
    
    NSMutableArray* callingcodes= [[NSMutableArray alloc]init ];
    for(NSString* isoCode in callingCodeDictionary.allKeys){
        CallingCode* callingCode = [[CallingCode alloc]init];
        callingCode.country = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:isoCode];
        callingCode.code = [callingCodeDictionary valueForKey:isoCode];
        callingCode.isoCode = isoCode;
        [callingcodes addObject:callingCode];
    }
    return callingcodes;
}

+(CallingCode*)getCurrentCallingCode{
    NSString* currentCountryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF.isoCode==%@",currentCountryCode];
    NSArray* filtered = [[self getAvailableCodes] filteredArrayUsingPredicate:predicate];
    return filtered.count>0?[filtered objectAtIndex:0]:nil;
}
@end
