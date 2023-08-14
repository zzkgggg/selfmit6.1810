
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmt_params>:
#define MAX_STDIN_LEN  512
#define MAX_PARAMS_CNT  100
#define MAX_PARAM_LEN 50

// 将一行命令拆解为多个参数，以空格为分隔符
void fmt_params(char* line, char** params, int* cnt){
   0:	7135                	add	sp,sp,-160
   2:	ed06                	sd	ra,152(sp)
   4:	e922                	sd	s0,144(sp)
   6:	e526                	sd	s1,136(sp)
   8:	e14a                	sd	s2,128(sp)
   a:	fcce                	sd	s3,120(sp)
   c:	f8d2                	sd	s4,112(sp)
   e:	f4d6                	sd	s5,104(sp)
  10:	f0da                	sd	s6,96(sp)
  12:	ecde                	sd	s7,88(sp)
  14:	e8e2                	sd	s8,80(sp)
  16:	e4e6                	sd	s9,72(sp)
  18:	1100                	add	s0,sp,160
  1a:	89aa                	mv	s3,a0
  1c:	8b2e                	mv	s6,a1
  1e:	8a32                	mv	s4,a2
    char cur_param[MAX_PARAM_LEN];
    int cur_param_len = 0;
    for(int i=0; i<strlen(line); i++){
  20:	4481                	li	s1,0
    int cur_param_len = 0;
  22:	4901                	li	s2,0

        if((line[i] == ' ' || line[i] == '\n')&& cur_param_len!=0){
  24:	02000a93          	li	s5,32
            //printf("%s\n",cur_param);
            params[*cnt] = malloc(MAX_PARAM_LEN);
            memmove(params[*cnt],cur_param,cur_param_len);
            params[*cnt][cur_param_len] = 0;
            cur_param_len = 0;
  28:	4c01                	li	s8,0
        if((line[i] == ' ' || line[i] == '\n')&& cur_param_len!=0){
  2a:	4ba9                	li	s7,10
    for(int i=0; i<strlen(line); i++){
  2c:	a811                	j	40 <fmt_params+0x40>
        if((line[i] == ' ' || line[i] == '\n')&& cur_param_len!=0){
  2e:	02091c63          	bnez	s2,66 <fmt_params+0x66>
            (*cnt) ++;
        } 
        else {
            cur_param[cur_param_len] = line[i];
  32:	fa090713          	add	a4,s2,-96
  36:	9722                	add	a4,a4,s0
  38:	fcf70423          	sb	a5,-56(a4)
            cur_param_len ++;
  3c:	2905                	addw	s2,s2,1
    for(int i=0; i<strlen(line); i++){
  3e:	0485                	add	s1,s1,1
  40:	854e                	mv	a0,s3
  42:	00000097          	auipc	ra,0x0
  46:	192080e7          	jalr	402(ra) # 1d4 <strlen>
  4a:	2501                	sext.w	a0,a0
  4c:	0004879b          	sext.w	a5,s1
  50:	06a7f263          	bgeu	a5,a0,b4 <fmt_params+0xb4>
        if((line[i] == ' ' || line[i] == '\n')&& cur_param_len!=0){
  54:	009987b3          	add	a5,s3,s1
  58:	0007c783          	lbu	a5,0(a5)
  5c:	fd5789e3          	beq	a5,s5,2e <fmt_params+0x2e>
  60:	fd7799e3          	bne	a5,s7,32 <fmt_params+0x32>
  64:	b7e9                	j	2e <fmt_params+0x2e>
            params[*cnt] = malloc(MAX_PARAM_LEN);
  66:	000a2c83          	lw	s9,0(s4)
  6a:	0c8e                	sll	s9,s9,0x3
  6c:	9cda                	add	s9,s9,s6
  6e:	03200513          	li	a0,50
  72:	00000097          	auipc	ra,0x0
  76:	7b6080e7          	jalr	1974(ra) # 828 <malloc>
  7a:	00acb023          	sd	a0,0(s9)
            memmove(params[*cnt],cur_param,cur_param_len);
  7e:	000a2783          	lw	a5,0(s4)
  82:	078e                	sll	a5,a5,0x3
  84:	97da                	add	a5,a5,s6
  86:	864a                	mv	a2,s2
  88:	f6840593          	add	a1,s0,-152
  8c:	6388                	ld	a0,0(a5)
  8e:	00000097          	auipc	ra,0x0
  92:	2b8080e7          	jalr	696(ra) # 346 <memmove>
            params[*cnt][cur_param_len] = 0;
  96:	000a2783          	lw	a5,0(s4)
  9a:	078e                	sll	a5,a5,0x3
  9c:	97da                	add	a5,a5,s6
  9e:	639c                	ld	a5,0(a5)
  a0:	97ca                	add	a5,a5,s2
  a2:	00078023          	sb	zero,0(a5)
            (*cnt) ++;
  a6:	000a2783          	lw	a5,0(s4)
  aa:	2785                	addw	a5,a5,1
  ac:	00fa2023          	sw	a5,0(s4)
            cur_param_len = 0;
  b0:	8962                	mv	s2,s8
            (*cnt) ++;
  b2:	b771                	j	3e <fmt_params+0x3e>
        }
    }

}
  b4:	60ea                	ld	ra,152(sp)
  b6:	644a                	ld	s0,144(sp)
  b8:	64aa                	ld	s1,136(sp)
  ba:	690a                	ld	s2,128(sp)
  bc:	79e6                	ld	s3,120(sp)
  be:	7a46                	ld	s4,112(sp)
  c0:	7aa6                	ld	s5,104(sp)
  c2:	7b06                	ld	s6,96(sp)
  c4:	6be6                	ld	s7,88(sp)
  c6:	6c46                	ld	s8,80(sp)
  c8:	6ca6                	ld	s9,72(sp)
  ca:	610d                	add	sp,sp,160
  cc:	8082                	ret

00000000000000ce <main>:

int main(int argc, char *argv[]){
  ce:	ac010113          	add	sp,sp,-1344
  d2:	52113c23          	sd	ra,1336(sp)
  d6:	52813823          	sd	s0,1328(sp)
  da:	54010413          	add	s0,sp,1344

    // 读取 xargs 后的命令以及参数
    if(argc == 1) exit(0);
  de:	4785                	li	a5,1
  e0:	02f50763          	beq	a0,a5,10e <main+0x40>
    char* params[MAX_PARAMS_CNT];  // 参数
    int cnt = 0;
  e4:	cc042623          	sw	zero,-820(s0)
    for(int i=1; i<argc; i++){
  e8:	4785                	li	a5,1
  ea:	02a7dc63          	bge	a5,a0,122 <main+0x54>
  ee:	05a1                	add	a1,a1,8
  f0:	cd040713          	add	a4,s0,-816
  f4:	2501                	sext.w	a0,a0
        params[i-1] = argv[i];
  f6:	6194                	ld	a3,0(a1)
  f8:	e314                	sd	a3,0(a4)
    for(int i=1; i<argc; i++){
  fa:	0007869b          	sext.w	a3,a5
  fe:	2785                	addw	a5,a5,1
 100:	05a1                	add	a1,a1,8
 102:	0721                	add	a4,a4,8
 104:	fea799e3          	bne	a5,a0,f6 <main+0x28>
 108:	ccd42623          	sw	a3,-820(s0)
 10c:	a819                	j	122 <main+0x54>
    if(argc == 1) exit(0);
 10e:	4501                	li	a0,0
 110:	00000097          	auipc	ra,0x0
 114:	2e8080e7          	jalr	744(ra) # 3f8 <exit>
            // 注意，exec第二个参数的第一个元素指向cmd可执行文件，而不是指命令参数
            // 类似于argv
            exec(params[0],params);
        }else{
            // 父
            wait(0);
 118:	4501                	li	a0,0
 11a:	00000097          	auipc	ra,0x0
 11e:	2e6080e7          	jalr	742(ra) # 400 <wait>
    while(read(STDIN_FILENO,r_buf,MAX_STDIN_LEN) > 0){  // 逐行读取
 122:	20000613          	li	a2,512
 126:	ac840593          	add	a1,s0,-1336
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	2e4080e7          	jalr	740(ra) # 410 <read>
 134:	02a05a63          	blez	a0,168 <main+0x9a>
        if(fork()==0){
 138:	00000097          	auipc	ra,0x0
 13c:	2b8080e7          	jalr	696(ra) # 3f0 <fork>
 140:	fd61                	bnez	a0,118 <main+0x4a>
            fmt_params(r_buf,params,&cnt);
 142:	ccc40613          	add	a2,s0,-820
 146:	cd040593          	add	a1,s0,-816
 14a:	ac840513          	add	a0,s0,-1336
 14e:	00000097          	auipc	ra,0x0
 152:	eb2080e7          	jalr	-334(ra) # 0 <fmt_params>
            exec(params[0],params);
 156:	cd040593          	add	a1,s0,-816
 15a:	cd043503          	ld	a0,-816(s0)
 15e:	00000097          	auipc	ra,0x0
 162:	2d2080e7          	jalr	722(ra) # 430 <exec>
 166:	bf75                	j	122 <main+0x54>
        }
    }
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	28e080e7          	jalr	654(ra) # 3f8 <exit>

0000000000000172 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 172:	1141                	add	sp,sp,-16
 174:	e406                	sd	ra,8(sp)
 176:	e022                	sd	s0,0(sp)
 178:	0800                	add	s0,sp,16
  extern int main();
  main();
 17a:	00000097          	auipc	ra,0x0
 17e:	f54080e7          	jalr	-172(ra) # ce <main>
  exit(0);
 182:	4501                	li	a0,0
 184:	00000097          	auipc	ra,0x0
 188:	274080e7          	jalr	628(ra) # 3f8 <exit>

000000000000018c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 18c:	1141                	add	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 192:	87aa                	mv	a5,a0
 194:	0585                	add	a1,a1,1
 196:	0785                	add	a5,a5,1
 198:	fff5c703          	lbu	a4,-1(a1)
 19c:	fee78fa3          	sb	a4,-1(a5)
 1a0:	fb75                	bnez	a4,194 <strcpy+0x8>
    ;
  return os;
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	add	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	1141                	add	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cb91                	beqz	a5,1c6 <strcmp+0x1e>
 1b4:	0005c703          	lbu	a4,0(a1)
 1b8:	00f71763          	bne	a4,a5,1c6 <strcmp+0x1e>
    p++, q++;
 1bc:	0505                	add	a0,a0,1
 1be:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	fbe5                	bnez	a5,1b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c6:	0005c503          	lbu	a0,0(a1)
}
 1ca:	40a7853b          	subw	a0,a5,a0
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	add	sp,sp,16
 1d2:	8082                	ret

00000000000001d4 <strlen>:

uint
strlen(const char *s)
{
 1d4:	1141                	add	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	cf91                	beqz	a5,1fa <strlen+0x26>
 1e0:	0505                	add	a0,a0,1
 1e2:	87aa                	mv	a5,a0
 1e4:	86be                	mv	a3,a5
 1e6:	0785                	add	a5,a5,1
 1e8:	fff7c703          	lbu	a4,-1(a5)
 1ec:	ff65                	bnez	a4,1e4 <strlen+0x10>
 1ee:	40a6853b          	subw	a0,a3,a0
 1f2:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	add	sp,sp,16
 1f8:	8082                	ret
  for(n = 0; s[n]; n++)
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <strlen+0x20>

00000000000001fe <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fe:	1141                	add	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 204:	ca19                	beqz	a2,21a <memset+0x1c>
 206:	87aa                	mv	a5,a0
 208:	1602                	sll	a2,a2,0x20
 20a:	9201                	srl	a2,a2,0x20
 20c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 210:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 214:	0785                	add	a5,a5,1
 216:	fee79de3          	bne	a5,a4,210 <memset+0x12>
  }
  return dst;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	add	sp,sp,16
 21e:	8082                	ret

0000000000000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	1141                	add	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	add	s0,sp,16
  for(; *s; s++)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cb99                	beqz	a5,240 <strchr+0x20>
    if(*s == c)
 22c:	00f58763          	beq	a1,a5,23a <strchr+0x1a>
  for(; *s; s++)
 230:	0505                	add	a0,a0,1
 232:	00054783          	lbu	a5,0(a0)
 236:	fbfd                	bnez	a5,22c <strchr+0xc>
      return (char*)s;
  return 0;
 238:	4501                	li	a0,0
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	add	sp,sp,16
 23e:	8082                	ret
  return 0;
 240:	4501                	li	a0,0
 242:	bfe5                	j	23a <strchr+0x1a>

0000000000000244 <gets>:

char*
gets(char *buf, int max)
{
 244:	711d                	add	sp,sp,-96
 246:	ec86                	sd	ra,88(sp)
 248:	e8a2                	sd	s0,80(sp)
 24a:	e4a6                	sd	s1,72(sp)
 24c:	e0ca                	sd	s2,64(sp)
 24e:	fc4e                	sd	s3,56(sp)
 250:	f852                	sd	s4,48(sp)
 252:	f456                	sd	s5,40(sp)
 254:	f05a                	sd	s6,32(sp)
 256:	ec5e                	sd	s7,24(sp)
 258:	1080                	add	s0,sp,96
 25a:	8baa                	mv	s7,a0
 25c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25e:	892a                	mv	s2,a0
 260:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 262:	4aa9                	li	s5,10
 264:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 266:	89a6                	mv	s3,s1
 268:	2485                	addw	s1,s1,1
 26a:	0344d863          	bge	s1,s4,29a <gets+0x56>
    cc = read(0, &c, 1);
 26e:	4605                	li	a2,1
 270:	faf40593          	add	a1,s0,-81
 274:	4501                	li	a0,0
 276:	00000097          	auipc	ra,0x0
 27a:	19a080e7          	jalr	410(ra) # 410 <read>
    if(cc < 1)
 27e:	00a05e63          	blez	a0,29a <gets+0x56>
    buf[i++] = c;
 282:	faf44783          	lbu	a5,-81(s0)
 286:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 28a:	01578763          	beq	a5,s5,298 <gets+0x54>
 28e:	0905                	add	s2,s2,1
 290:	fd679be3          	bne	a5,s6,266 <gets+0x22>
  for(i=0; i+1 < max; ){
 294:	89a6                	mv	s3,s1
 296:	a011                	j	29a <gets+0x56>
 298:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 29a:	99de                	add	s3,s3,s7
 29c:	00098023          	sb	zero,0(s3)
  return buf;
}
 2a0:	855e                	mv	a0,s7
 2a2:	60e6                	ld	ra,88(sp)
 2a4:	6446                	ld	s0,80(sp)
 2a6:	64a6                	ld	s1,72(sp)
 2a8:	6906                	ld	s2,64(sp)
 2aa:	79e2                	ld	s3,56(sp)
 2ac:	7a42                	ld	s4,48(sp)
 2ae:	7aa2                	ld	s5,40(sp)
 2b0:	7b02                	ld	s6,32(sp)
 2b2:	6be2                	ld	s7,24(sp)
 2b4:	6125                	add	sp,sp,96
 2b6:	8082                	ret

00000000000002b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b8:	1101                	add	sp,sp,-32
 2ba:	ec06                	sd	ra,24(sp)
 2bc:	e822                	sd	s0,16(sp)
 2be:	e426                	sd	s1,8(sp)
 2c0:	e04a                	sd	s2,0(sp)
 2c2:	1000                	add	s0,sp,32
 2c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c6:	4581                	li	a1,0
 2c8:	00000097          	auipc	ra,0x0
 2cc:	170080e7          	jalr	368(ra) # 438 <open>
  if(fd < 0)
 2d0:	02054563          	bltz	a0,2fa <stat+0x42>
 2d4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d6:	85ca                	mv	a1,s2
 2d8:	00000097          	auipc	ra,0x0
 2dc:	178080e7          	jalr	376(ra) # 450 <fstat>
 2e0:	892a                	mv	s2,a0
  close(fd);
 2e2:	8526                	mv	a0,s1
 2e4:	00000097          	auipc	ra,0x0
 2e8:	13c080e7          	jalr	316(ra) # 420 <close>
  return r;
}
 2ec:	854a                	mv	a0,s2
 2ee:	60e2                	ld	ra,24(sp)
 2f0:	6442                	ld	s0,16(sp)
 2f2:	64a2                	ld	s1,8(sp)
 2f4:	6902                	ld	s2,0(sp)
 2f6:	6105                	add	sp,sp,32
 2f8:	8082                	ret
    return -1;
 2fa:	597d                	li	s2,-1
 2fc:	bfc5                	j	2ec <stat+0x34>

00000000000002fe <atoi>:

int
atoi(const char *s)
{
 2fe:	1141                	add	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 304:	00054683          	lbu	a3,0(a0)
 308:	fd06879b          	addw	a5,a3,-48
 30c:	0ff7f793          	zext.b	a5,a5
 310:	4625                	li	a2,9
 312:	02f66863          	bltu	a2,a5,342 <atoi+0x44>
 316:	872a                	mv	a4,a0
  n = 0;
 318:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 31a:	0705                	add	a4,a4,1
 31c:	0025179b          	sllw	a5,a0,0x2
 320:	9fa9                	addw	a5,a5,a0
 322:	0017979b          	sllw	a5,a5,0x1
 326:	9fb5                	addw	a5,a5,a3
 328:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 32c:	00074683          	lbu	a3,0(a4)
 330:	fd06879b          	addw	a5,a3,-48
 334:	0ff7f793          	zext.b	a5,a5
 338:	fef671e3          	bgeu	a2,a5,31a <atoi+0x1c>
  return n;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	add	sp,sp,16
 340:	8082                	ret
  n = 0;
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <atoi+0x3e>

0000000000000346 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 346:	1141                	add	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34c:	02b57463          	bgeu	a0,a1,374 <memmove+0x2e>
    while(n-- > 0)
 350:	00c05f63          	blez	a2,36e <memmove+0x28>
 354:	1602                	sll	a2,a2,0x20
 356:	9201                	srl	a2,a2,0x20
 358:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35c:	872a                	mv	a4,a0
      *dst++ = *src++;
 35e:	0585                	add	a1,a1,1
 360:	0705                	add	a4,a4,1
 362:	fff5c683          	lbu	a3,-1(a1)
 366:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 36a:	fee79ae3          	bne	a5,a4,35e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36e:	6422                	ld	s0,8(sp)
 370:	0141                	add	sp,sp,16
 372:	8082                	ret
    dst += n;
 374:	00c50733          	add	a4,a0,a2
    src += n;
 378:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 37a:	fec05ae3          	blez	a2,36e <memmove+0x28>
 37e:	fff6079b          	addw	a5,a2,-1
 382:	1782                	sll	a5,a5,0x20
 384:	9381                	srl	a5,a5,0x20
 386:	fff7c793          	not	a5,a5
 38a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38c:	15fd                	add	a1,a1,-1
 38e:	177d                	add	a4,a4,-1
 390:	0005c683          	lbu	a3,0(a1)
 394:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 398:	fee79ae3          	bne	a5,a4,38c <memmove+0x46>
 39c:	bfc9                	j	36e <memmove+0x28>

000000000000039e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39e:	1141                	add	sp,sp,-16
 3a0:	e422                	sd	s0,8(sp)
 3a2:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a4:	ca05                	beqz	a2,3d4 <memcmp+0x36>
 3a6:	fff6069b          	addw	a3,a2,-1
 3aa:	1682                	sll	a3,a3,0x20
 3ac:	9281                	srl	a3,a3,0x20
 3ae:	0685                	add	a3,a3,1
 3b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b2:	00054783          	lbu	a5,0(a0)
 3b6:	0005c703          	lbu	a4,0(a1)
 3ba:	00e79863          	bne	a5,a4,3ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3be:	0505                	add	a0,a0,1
    p2++;
 3c0:	0585                	add	a1,a1,1
  while (n-- > 0) {
 3c2:	fed518e3          	bne	a0,a3,3b2 <memcmp+0x14>
  }
  return 0;
 3c6:	4501                	li	a0,0
 3c8:	a019                	j	3ce <memcmp+0x30>
      return *p1 - *p2;
 3ca:	40e7853b          	subw	a0,a5,a4
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	add	sp,sp,16
 3d2:	8082                	ret
  return 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <memcmp+0x30>

00000000000003d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d8:	1141                	add	sp,sp,-16
 3da:	e406                	sd	ra,8(sp)
 3dc:	e022                	sd	s0,0(sp)
 3de:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 3e0:	00000097          	auipc	ra,0x0
 3e4:	f66080e7          	jalr	-154(ra) # 346 <memmove>
}
 3e8:	60a2                	ld	ra,8(sp)
 3ea:	6402                	ld	s0,0(sp)
 3ec:	0141                	add	sp,sp,16
 3ee:	8082                	ret

00000000000003f0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f0:	4885                	li	a7,1
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f8:	4889                	li	a7,2
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <wait>:
.global wait
wait:
 li a7, SYS_wait
 400:	488d                	li	a7,3
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 408:	4891                	li	a7,4
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <read>:
.global read
read:
 li a7, SYS_read
 410:	4895                	li	a7,5
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <write>:
.global write
write:
 li a7, SYS_write
 418:	48c1                	li	a7,16
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <close>:
.global close
close:
 li a7, SYS_close
 420:	48d5                	li	a7,21
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <kill>:
.global kill
kill:
 li a7, SYS_kill
 428:	4899                	li	a7,6
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <exec>:
.global exec
exec:
 li a7, SYS_exec
 430:	489d                	li	a7,7
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <open>:
.global open
open:
 li a7, SYS_open
 438:	48bd                	li	a7,15
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 440:	48c5                	li	a7,17
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 448:	48c9                	li	a7,18
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 450:	48a1                	li	a7,8
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <link>:
.global link
link:
 li a7, SYS_link
 458:	48cd                	li	a7,19
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 460:	48d1                	li	a7,20
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 468:	48a5                	li	a7,9
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <dup>:
.global dup
dup:
 li a7, SYS_dup
 470:	48a9                	li	a7,10
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 478:	48ad                	li	a7,11
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 480:	48b1                	li	a7,12
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 488:	48b5                	li	a7,13
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 490:	48b9                	li	a7,14
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <trace>:
.global trace
trace:
 li a7, SYS_trace
 498:	48d9                	li	a7,22
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 4a0:	48dd                	li	a7,23
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a8:	1101                	add	sp,sp,-32
 4aa:	ec06                	sd	ra,24(sp)
 4ac:	e822                	sd	s0,16(sp)
 4ae:	1000                	add	s0,sp,32
 4b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b4:	4605                	li	a2,1
 4b6:	fef40593          	add	a1,s0,-17
 4ba:	00000097          	auipc	ra,0x0
 4be:	f5e080e7          	jalr	-162(ra) # 418 <write>
}
 4c2:	60e2                	ld	ra,24(sp)
 4c4:	6442                	ld	s0,16(sp)
 4c6:	6105                	add	sp,sp,32
 4c8:	8082                	ret

00000000000004ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ca:	7139                	add	sp,sp,-64
 4cc:	fc06                	sd	ra,56(sp)
 4ce:	f822                	sd	s0,48(sp)
 4d0:	f426                	sd	s1,40(sp)
 4d2:	f04a                	sd	s2,32(sp)
 4d4:	ec4e                	sd	s3,24(sp)
 4d6:	0080                	add	s0,sp,64
 4d8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4da:	c299                	beqz	a3,4e0 <printint+0x16>
 4dc:	0805c963          	bltz	a1,56e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4e0:	2581                	sext.w	a1,a1
  neg = 0;
 4e2:	4881                	li	a7,0
 4e4:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 4e8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ea:	2601                	sext.w	a2,a2
 4ec:	00000517          	auipc	a0,0x0
 4f0:	48450513          	add	a0,a0,1156 # 970 <digits>
 4f4:	883a                	mv	a6,a4
 4f6:	2705                	addw	a4,a4,1
 4f8:	02c5f7bb          	remuw	a5,a1,a2
 4fc:	1782                	sll	a5,a5,0x20
 4fe:	9381                	srl	a5,a5,0x20
 500:	97aa                	add	a5,a5,a0
 502:	0007c783          	lbu	a5,0(a5)
 506:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 50a:	0005879b          	sext.w	a5,a1
 50e:	02c5d5bb          	divuw	a1,a1,a2
 512:	0685                	add	a3,a3,1
 514:	fec7f0e3          	bgeu	a5,a2,4f4 <printint+0x2a>
  if(neg)
 518:	00088c63          	beqz	a7,530 <printint+0x66>
    buf[i++] = '-';
 51c:	fd070793          	add	a5,a4,-48
 520:	00878733          	add	a4,a5,s0
 524:	02d00793          	li	a5,45
 528:	fef70823          	sb	a5,-16(a4)
 52c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 530:	02e05863          	blez	a4,560 <printint+0x96>
 534:	fc040793          	add	a5,s0,-64
 538:	00e78933          	add	s2,a5,a4
 53c:	fff78993          	add	s3,a5,-1
 540:	99ba                	add	s3,s3,a4
 542:	377d                	addw	a4,a4,-1
 544:	1702                	sll	a4,a4,0x20
 546:	9301                	srl	a4,a4,0x20
 548:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 54c:	fff94583          	lbu	a1,-1(s2)
 550:	8526                	mv	a0,s1
 552:	00000097          	auipc	ra,0x0
 556:	f56080e7          	jalr	-170(ra) # 4a8 <putc>
  while(--i >= 0)
 55a:	197d                	add	s2,s2,-1
 55c:	ff3918e3          	bne	s2,s3,54c <printint+0x82>
}
 560:	70e2                	ld	ra,56(sp)
 562:	7442                	ld	s0,48(sp)
 564:	74a2                	ld	s1,40(sp)
 566:	7902                	ld	s2,32(sp)
 568:	69e2                	ld	s3,24(sp)
 56a:	6121                	add	sp,sp,64
 56c:	8082                	ret
    x = -xx;
 56e:	40b005bb          	negw	a1,a1
    neg = 1;
 572:	4885                	li	a7,1
    x = -xx;
 574:	bf85                	j	4e4 <printint+0x1a>

0000000000000576 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 576:	715d                	add	sp,sp,-80
 578:	e486                	sd	ra,72(sp)
 57a:	e0a2                	sd	s0,64(sp)
 57c:	fc26                	sd	s1,56(sp)
 57e:	f84a                	sd	s2,48(sp)
 580:	f44e                	sd	s3,40(sp)
 582:	f052                	sd	s4,32(sp)
 584:	ec56                	sd	s5,24(sp)
 586:	e85a                	sd	s6,16(sp)
 588:	e45e                	sd	s7,8(sp)
 58a:	e062                	sd	s8,0(sp)
 58c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 58e:	0005c903          	lbu	s2,0(a1)
 592:	18090c63          	beqz	s2,72a <vprintf+0x1b4>
 596:	8aaa                	mv	s5,a0
 598:	8bb2                	mv	s7,a2
 59a:	00158493          	add	s1,a1,1
  state = 0;
 59e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5a0:	02500a13          	li	s4,37
 5a4:	4b55                	li	s6,21
 5a6:	a839                	j	5c4 <vprintf+0x4e>
        putc(fd, c);
 5a8:	85ca                	mv	a1,s2
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	efc080e7          	jalr	-260(ra) # 4a8 <putc>
 5b4:	a019                	j	5ba <vprintf+0x44>
    } else if(state == '%'){
 5b6:	01498d63          	beq	s3,s4,5d0 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 5ba:	0485                	add	s1,s1,1
 5bc:	fff4c903          	lbu	s2,-1(s1)
 5c0:	16090563          	beqz	s2,72a <vprintf+0x1b4>
    if(state == 0){
 5c4:	fe0999e3          	bnez	s3,5b6 <vprintf+0x40>
      if(c == '%'){
 5c8:	ff4910e3          	bne	s2,s4,5a8 <vprintf+0x32>
        state = '%';
 5cc:	89d2                	mv	s3,s4
 5ce:	b7f5                	j	5ba <vprintf+0x44>
      if(c == 'd'){
 5d0:	13490263          	beq	s2,s4,6f4 <vprintf+0x17e>
 5d4:	f9d9079b          	addw	a5,s2,-99
 5d8:	0ff7f793          	zext.b	a5,a5
 5dc:	12fb6563          	bltu	s6,a5,706 <vprintf+0x190>
 5e0:	f9d9079b          	addw	a5,s2,-99
 5e4:	0ff7f713          	zext.b	a4,a5
 5e8:	10eb6f63          	bltu	s6,a4,706 <vprintf+0x190>
 5ec:	00271793          	sll	a5,a4,0x2
 5f0:	00000717          	auipc	a4,0x0
 5f4:	32870713          	add	a4,a4,808 # 918 <malloc+0xf0>
 5f8:	97ba                	add	a5,a5,a4
 5fa:	439c                	lw	a5,0(a5)
 5fc:	97ba                	add	a5,a5,a4
 5fe:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 600:	008b8913          	add	s2,s7,8
 604:	4685                	li	a3,1
 606:	4629                	li	a2,10
 608:	000ba583          	lw	a1,0(s7)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	ebc080e7          	jalr	-324(ra) # 4ca <printint>
 616:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 618:	4981                	li	s3,0
 61a:	b745                	j	5ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	008b8913          	add	s2,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000ba583          	lw	a1,0(s7)
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	ea0080e7          	jalr	-352(ra) # 4ca <printint>
 632:	8bca                	mv	s7,s2
      state = 0;
 634:	4981                	li	s3,0
 636:	b751                	j	5ba <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 638:	008b8913          	add	s2,s7,8
 63c:	4681                	li	a3,0
 63e:	4641                	li	a2,16
 640:	000ba583          	lw	a1,0(s7)
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e84080e7          	jalr	-380(ra) # 4ca <printint>
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
 652:	b7a5                	j	5ba <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 654:	008b8c13          	add	s8,s7,8
 658:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 65c:	03000593          	li	a1,48
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	e46080e7          	jalr	-442(ra) # 4a8 <putc>
  putc(fd, 'x');
 66a:	07800593          	li	a1,120
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	e38080e7          	jalr	-456(ra) # 4a8 <putc>
 678:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67a:	00000b97          	auipc	s7,0x0
 67e:	2f6b8b93          	add	s7,s7,758 # 970 <digits>
 682:	03c9d793          	srl	a5,s3,0x3c
 686:	97de                	add	a5,a5,s7
 688:	0007c583          	lbu	a1,0(a5)
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	e1a080e7          	jalr	-486(ra) # 4a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 696:	0992                	sll	s3,s3,0x4
 698:	397d                	addw	s2,s2,-1
 69a:	fe0914e3          	bnez	s2,682 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 69e:	8be2                	mv	s7,s8
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bf21                	j	5ba <vprintf+0x44>
        s = va_arg(ap, char*);
 6a4:	008b8993          	add	s3,s7,8
 6a8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6ac:	02090163          	beqz	s2,6ce <vprintf+0x158>
        while(*s != 0){
 6b0:	00094583          	lbu	a1,0(s2)
 6b4:	c9a5                	beqz	a1,724 <vprintf+0x1ae>
          putc(fd, *s);
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	df0080e7          	jalr	-528(ra) # 4a8 <putc>
          s++;
 6c0:	0905                	add	s2,s2,1
        while(*s != 0){
 6c2:	00094583          	lbu	a1,0(s2)
 6c6:	f9e5                	bnez	a1,6b6 <vprintf+0x140>
        s = va_arg(ap, char*);
 6c8:	8bce                	mv	s7,s3
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b5fd                	j	5ba <vprintf+0x44>
          s = "(null)";
 6ce:	00000917          	auipc	s2,0x0
 6d2:	24290913          	add	s2,s2,578 # 910 <malloc+0xe8>
        while(*s != 0){
 6d6:	02800593          	li	a1,40
 6da:	bff1                	j	6b6 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 6dc:	008b8913          	add	s2,s7,8
 6e0:	000bc583          	lbu	a1,0(s7)
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	dc2080e7          	jalr	-574(ra) # 4a8 <putc>
 6ee:	8bca                	mv	s7,s2
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b5e1                	j	5ba <vprintf+0x44>
        putc(fd, c);
 6f4:	02500593          	li	a1,37
 6f8:	8556                	mv	a0,s5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	dae080e7          	jalr	-594(ra) # 4a8 <putc>
      state = 0;
 702:	4981                	li	s3,0
 704:	bd5d                	j	5ba <vprintf+0x44>
        putc(fd, '%');
 706:	02500593          	li	a1,37
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	d9c080e7          	jalr	-612(ra) # 4a8 <putc>
        putc(fd, c);
 714:	85ca                	mv	a1,s2
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	d90080e7          	jalr	-624(ra) # 4a8 <putc>
      state = 0;
 720:	4981                	li	s3,0
 722:	bd61                	j	5ba <vprintf+0x44>
        s = va_arg(ap, char*);
 724:	8bce                	mv	s7,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	bd49                	j	5ba <vprintf+0x44>
    }
  }
}
 72a:	60a6                	ld	ra,72(sp)
 72c:	6406                	ld	s0,64(sp)
 72e:	74e2                	ld	s1,56(sp)
 730:	7942                	ld	s2,48(sp)
 732:	79a2                	ld	s3,40(sp)
 734:	7a02                	ld	s4,32(sp)
 736:	6ae2                	ld	s5,24(sp)
 738:	6b42                	ld	s6,16(sp)
 73a:	6ba2                	ld	s7,8(sp)
 73c:	6c02                	ld	s8,0(sp)
 73e:	6161                	add	sp,sp,80
 740:	8082                	ret

0000000000000742 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 742:	715d                	add	sp,sp,-80
 744:	ec06                	sd	ra,24(sp)
 746:	e822                	sd	s0,16(sp)
 748:	1000                	add	s0,sp,32
 74a:	e010                	sd	a2,0(s0)
 74c:	e414                	sd	a3,8(s0)
 74e:	e818                	sd	a4,16(s0)
 750:	ec1c                	sd	a5,24(s0)
 752:	03043023          	sd	a6,32(s0)
 756:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 75e:	8622                	mv	a2,s0
 760:	00000097          	auipc	ra,0x0
 764:	e16080e7          	jalr	-490(ra) # 576 <vprintf>
}
 768:	60e2                	ld	ra,24(sp)
 76a:	6442                	ld	s0,16(sp)
 76c:	6161                	add	sp,sp,80
 76e:	8082                	ret

0000000000000770 <printf>:

void
printf(const char *fmt, ...)
{
 770:	711d                	add	sp,sp,-96
 772:	ec06                	sd	ra,24(sp)
 774:	e822                	sd	s0,16(sp)
 776:	1000                	add	s0,sp,32
 778:	e40c                	sd	a1,8(s0)
 77a:	e810                	sd	a2,16(s0)
 77c:	ec14                	sd	a3,24(s0)
 77e:	f018                	sd	a4,32(s0)
 780:	f41c                	sd	a5,40(s0)
 782:	03043823          	sd	a6,48(s0)
 786:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78a:	00840613          	add	a2,s0,8
 78e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 792:	85aa                	mv	a1,a0
 794:	4505                	li	a0,1
 796:	00000097          	auipc	ra,0x0
 79a:	de0080e7          	jalr	-544(ra) # 576 <vprintf>
}
 79e:	60e2                	ld	ra,24(sp)
 7a0:	6442                	ld	s0,16(sp)
 7a2:	6125                	add	sp,sp,96
 7a4:	8082                	ret

00000000000007a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a6:	1141                	add	sp,sp,-16
 7a8:	e422                	sd	s0,8(sp)
 7aa:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ac:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b0:	00001797          	auipc	a5,0x1
 7b4:	8507b783          	ld	a5,-1968(a5) # 1000 <freep>
 7b8:	a02d                	j	7e2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ba:	4618                	lw	a4,8(a2)
 7bc:	9f2d                	addw	a4,a4,a1
 7be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c2:	6398                	ld	a4,0(a5)
 7c4:	6310                	ld	a2,0(a4)
 7c6:	a83d                	j	804 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c8:	ff852703          	lw	a4,-8(a0)
 7cc:	9f31                	addw	a4,a4,a2
 7ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d0:	ff053683          	ld	a3,-16(a0)
 7d4:	a091                	j	818 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d6:	6398                	ld	a4,0(a5)
 7d8:	00e7e463          	bltu	a5,a4,7e0 <free+0x3a>
 7dc:	00e6ea63          	bltu	a3,a4,7f0 <free+0x4a>
{
 7e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e2:	fed7fae3          	bgeu	a5,a3,7d6 <free+0x30>
 7e6:	6398                	ld	a4,0(a5)
 7e8:	00e6e463          	bltu	a3,a4,7f0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ec:	fee7eae3          	bltu	a5,a4,7e0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7f0:	ff852583          	lw	a1,-8(a0)
 7f4:	6390                	ld	a2,0(a5)
 7f6:	02059813          	sll	a6,a1,0x20
 7fa:	01c85713          	srl	a4,a6,0x1c
 7fe:	9736                	add	a4,a4,a3
 800:	fae60de3          	beq	a2,a4,7ba <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 804:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 808:	4790                	lw	a2,8(a5)
 80a:	02061593          	sll	a1,a2,0x20
 80e:	01c5d713          	srl	a4,a1,0x1c
 812:	973e                	add	a4,a4,a5
 814:	fae68ae3          	beq	a3,a4,7c8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 818:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 81a:	00000717          	auipc	a4,0x0
 81e:	7ef73323          	sd	a5,2022(a4) # 1000 <freep>
}
 822:	6422                	ld	s0,8(sp)
 824:	0141                	add	sp,sp,16
 826:	8082                	ret

0000000000000828 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 828:	7139                	add	sp,sp,-64
 82a:	fc06                	sd	ra,56(sp)
 82c:	f822                	sd	s0,48(sp)
 82e:	f426                	sd	s1,40(sp)
 830:	f04a                	sd	s2,32(sp)
 832:	ec4e                	sd	s3,24(sp)
 834:	e852                	sd	s4,16(sp)
 836:	e456                	sd	s5,8(sp)
 838:	e05a                	sd	s6,0(sp)
 83a:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83c:	02051493          	sll	s1,a0,0x20
 840:	9081                	srl	s1,s1,0x20
 842:	04bd                	add	s1,s1,15
 844:	8091                	srl	s1,s1,0x4
 846:	0014899b          	addw	s3,s1,1
 84a:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 84c:	00000517          	auipc	a0,0x0
 850:	7b453503          	ld	a0,1972(a0) # 1000 <freep>
 854:	c515                	beqz	a0,880 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 856:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 858:	4798                	lw	a4,8(a5)
 85a:	02977f63          	bgeu	a4,s1,898 <malloc+0x70>
  if(nu < 4096)
 85e:	8a4e                	mv	s4,s3
 860:	0009871b          	sext.w	a4,s3
 864:	6685                	lui	a3,0x1
 866:	00d77363          	bgeu	a4,a3,86c <malloc+0x44>
 86a:	6a05                	lui	s4,0x1
 86c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 870:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 874:	00000917          	auipc	s2,0x0
 878:	78c90913          	add	s2,s2,1932 # 1000 <freep>
  if(p == (char*)-1)
 87c:	5afd                	li	s5,-1
 87e:	a895                	j	8f2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 880:	00000797          	auipc	a5,0x0
 884:	79078793          	add	a5,a5,1936 # 1010 <base>
 888:	00000717          	auipc	a4,0x0
 88c:	76f73c23          	sd	a5,1912(a4) # 1000 <freep>
 890:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 892:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 896:	b7e1                	j	85e <malloc+0x36>
      if(p->s.size == nunits)
 898:	02e48c63          	beq	s1,a4,8d0 <malloc+0xa8>
        p->s.size -= nunits;
 89c:	4137073b          	subw	a4,a4,s3
 8a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a2:	02071693          	sll	a3,a4,0x20
 8a6:	01c6d713          	srl	a4,a3,0x1c
 8aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b0:	00000717          	auipc	a4,0x0
 8b4:	74a73823          	sd	a0,1872(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b8:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8bc:	70e2                	ld	ra,56(sp)
 8be:	7442                	ld	s0,48(sp)
 8c0:	74a2                	ld	s1,40(sp)
 8c2:	7902                	ld	s2,32(sp)
 8c4:	69e2                	ld	s3,24(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
 8cc:	6121                	add	sp,sp,64
 8ce:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	e118                	sd	a4,0(a0)
 8d4:	bff1                	j	8b0 <malloc+0x88>
  hp->s.size = nu;
 8d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8da:	0541                	add	a0,a0,16
 8dc:	00000097          	auipc	ra,0x0
 8e0:	eca080e7          	jalr	-310(ra) # 7a6 <free>
  return freep;
 8e4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e8:	d971                	beqz	a0,8bc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ec:	4798                	lw	a4,8(a5)
 8ee:	fa9775e3          	bgeu	a4,s1,898 <malloc+0x70>
    if(p == freep)
 8f2:	00093703          	ld	a4,0(s2)
 8f6:	853e                	mv	a0,a5
 8f8:	fef719e3          	bne	a4,a5,8ea <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8fc:	8552                	mv	a0,s4
 8fe:	00000097          	auipc	ra,0x0
 902:	b82080e7          	jalr	-1150(ra) # 480 <sbrk>
  if(p == (char*)-1)
 906:	fd5518e3          	bne	a0,s5,8d6 <malloc+0xae>
        return 0;
 90a:	4501                	li	a0,0
 90c:	bf45                	j	8bc <malloc+0x94>
