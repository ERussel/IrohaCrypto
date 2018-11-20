//
//  Constants.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 15/10/2018.
//  Copyright © 2018 ERussel. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

static const int KEYS_COUNT = 4;

static NSString * const PRIVATE_KEYS[] = {
    @"nWGxne/9WmC6hEr0kuwsxERJxWl7MmkZcDusAxyuf2A=",
    @"TM0Imyj/ltqdtsNG7BFOD1uKMZ81q6Yk2oz27U+4pvs=",
    @"xaqN9D+fg3vtt0QvMdy3sWbThTUHbwlLhc46LgtEWPc=",
    @"DUoFsHNSpUNuGANW2grm76A0X/f7FXJXV3LoAF7ZeOk="
};

static NSString * const PUBLIC_KEYS[] = {
    @"p9QfLqYBZtLE/L4UXpfkuO+PAkcekrsxWMcFndfQ+ZA=",
    @"GUODZzUvZ4tBh65p/mjchh0VSawNJpNAtNUjh0Mrid0=",
    @"oI/UbuU05i0I5XeoSihgGQPUJL3yiL5FZE7OKTZylD4=",
    @"0dD5gL0zt1zn26r9taanQ5od4JpYBk7sD7c3bc88XSM="
};

static const int MESSAGES_COUNT = 4;

static NSString * const MESSAGES[] = {
    @"",
    @"cg==",
    @"r4I=",
    @"y8d7"
};

static NSString * const HEX_MESSAGES[] = {
    @"",
    @"72",
    @"af82",
    @"cbc77b"
};

static NSString * const SIGNATURES[] = {
    @"p8S3pDvv350rg+YFzaWZUavTedvuyJzihBQpiRE06hlbCaDvvx9R6m+D0PdWB9vOh0JJSfCoPGwcxkK/FersAg==",
    @"SGfW6NRov36LmlQ9bhpBRQ7l1jzVEIE5uV09IB+hKvAk1SEbOdE5h8TEy/BZlWq2+COkc8ymcHq0KvpxQjsSAQ==",
    @"nvwbhT+DmizftTcd0qcPjEUVNVyvGu33MzxPzSPLRDzWE9/sR89Nz9VJUd8ipoUFH5XjefePQKfjaix0XrPHBQ==",
    @"senvDTuUMmqMltNkJ+FggJyyda1r2OiwdG/pfn/kJosseTlwHx+HJ8bFNwR0Tk23ePDSmMSu+rzWkKgtl37RCg=="
};

static const int HASHES_COUNT = 4;

static NSString * const HASH_SHA_256[] = {
    @"p//G+L8e12ZRwUdWoGHWYvWA/03kO0n6gtgKS4D4Q0o=",
    @"MPyGIPl1QooL3vgymdbBfO60CdOQCTtYwIW1S10/GP8=",
    @"16SBcZ5W5t7kdYAGxj8+QH/Eg61++dyhfKe4R2bdlD0=",
    @"w6yUvcKFHd2wemyFqvQfR8gQl4/9nKG12iP4Lgr/d/Q="
};

static NSString * const HASH_SHA_512[] = {
    @"pp9zzKI6msXItWfcGFp1bpfJghZP4lhZ4NHcwUdcgKYVshI68fX5TBHj6UAsOsVY9QAZnZW20+MBdYWGKB3NJg==",
    @"3klraprylpyHxYFtAsBNrsNvYNG57qqU9pVwP4z6OmM0tS3+I1nIcVqO3MRRCbATNqGBLYMpZL5BedrYcC2L2g==",
    @"vilS5cKcw92O6d6XejPxIZPt0dOjBqwZ65vB220yJ+7fEYQzQgYVIrXy8Ca2b2XXqp2fg7MnpfhT25y1w818Fw==",
    @"T+FsBeT/GDPSYK2QQCpfPfWu3vKNMchHS/ltbb0Va1Tq4dsjc8jINNzlmvcKb6ydiuHTHyeocVzHNk+ctrFS6g=="
};

static const int MNEMONIC_COUNT = 24;

static NSString * const MNEMONIC_ENTROPY[] = {
    @"00000000000000000000000000000000",
    @"7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f",
    @"80808080808080808080808080808080",
    @"ffffffffffffffffffffffffffffffff",
    @"000000000000000000000000000000000000000000000000",
    @"7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f",
    @"808080808080808080808080808080808080808080808080",
    @"ffffffffffffffffffffffffffffffffffffffffffffffff",
    @"0000000000000000000000000000000000000000000000000000000000000000",
    @"7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f",
    @"8080808080808080808080808080808080808080808080808080808080808080",
    @"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
    @"9e885d952ad362caeb4efe34a8e91bd2",
    @"6610b25967cdcca9d59875f5cb50b0ea75433311869e930b",
    @"68a79eaca2324873eacc50cb9c6eca8cc68ea5d936f98787c60c7ebc74e6ce7c",
    @"c0ba5a8e914111210f2bd131f3d5e08d",
    @"6d9be1ee6ebd27a258115aad99b7317b9c8d28b6d76431c3",
    @"9f6a2878b2520799a44ef18bc7df394e7061a224d2c33cd015b157d746869863",
    @"23db8160a31d3e0dca3688ed941adbf3",
    @"8197a4a47f0425faeaa69deebc05ca29c0a5b5cc76ceacc0",
    @"066dca1a2bb7e8a1db2832148ce9933eea0f3ac9548d793112d9a95c9407efad",
    @"f30f8c1da665478f49b001d94c5fc452",
    @"c10ec20dc3cd9f652c7fac2f1230f7a3c828389a14392f05",
    @"f585c11aec520db57dd353c69554b21a89b20fb0650966fa0a9d6f74fd989d8f"
};

static NSString * const MNEMONIC_STRING[] = {
    @"abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about",
    @"legal winner thank year wave sausage worth useful legal winner thank yellow",
    @"letter advice cage absurd amount doctor acoustic avoid letter advice cage above",
    @"zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo wrong",
    @"abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon agent",
    @"legal winner thank year wave sausage worth useful legal winner thank year wave sausage worth useful legal will",
    @"letter advice cage absurd amount doctor acoustic avoid letter advice cage absurd amount doctor acoustic avoid letter always",
    @"zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo when",
    @"abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon art",
    @"legal winner thank year wave sausage worth useful legal winner thank year wave sausage worth useful legal winner thank year wave sausage worth title",
    @"letter advice cage absurd amount doctor acoustic avoid letter advice cage absurd amount doctor acoustic avoid letter advice cage absurd amount doctor acoustic bless",
    @"zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo vote",
    @"ozone drill grab fiber curtain grace pudding thank cruise elder eight picnic",
    @"gravity machine north sort system female filter attitude volume fold club stay feature office ecology stable narrow fog",
    @"hamster diagram private dutch cause delay private meat slide toddler razor book happy fancy gospel tennis maple dilemma loan word shrug inflict delay length",
    @"scheme spot photo card baby mountain device kick cradle pact join borrow",
    @"horn tenant knee talent sponsor spell gate clip pulse soap slush warm silver nephew swap uncle crack brave",
    @"panda eyebrow bullet gorilla call smoke muffin taste mesh discover soft ostrich alcohol speed nation flash devote level hobby quick inner drive ghost inside",
    @"cat swing flag economy stadium alone churn speed unique patch report train",
    @"light rule cinnamon wrap drastic word pride squirrel upgrade then income fatal apart sustain crack supply proud access",
    @"all hour make first leader extend hole alien behind guard gospel lava path output census museum junior mass reopen famous sing advance salt reform",
    @"vessel ladder alter error federal sibling chat ability sun glass valve picture",
    @"scissors invite lock maple supreme raw rapid void congress muscle digital elegant little brisk hair mango congress clump",
    @"void come effort suffer camp survey warrior heavy shoot primary clutch crush open amazing screen patrol group space point ten exist slush involve unfold"
};

static NSString * const INVALID_CHECKSUM_MNEMONIC = @"come void effort suffer camp survey warrior heavy shoot primary clutch crush open amazing screen patrol group space point ten exist slush involve unfold";

#endif /* Constants_h */
