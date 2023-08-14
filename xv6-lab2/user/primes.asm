
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include <stddef.h>

// 算法思路：https://swtch.com/~rsc/thread/

int main(int argc, char *argv[]){
   0:	7149                	add	sp,sp,-368
   2:	f686                	sd	ra,360(sp)
   4:	f2a2                	sd	s0,352(sp)
   6:	eea6                	sd	s1,344(sp)
   8:	eaca                	sd	s2,336(sp)
   a:	e6ce                	sd	s3,328(sp)
   c:	e2d2                	sd	s4,320(sp)
   e:	fe56                	sd	s5,312(sp)
  10:	fa5a                	sd	s6,304(sp)
  12:	f65e                	sd	s7,296(sp)
  14:	1a80                	add	s0,sp,368
    if(argc != 1){
  16:	4785                	li	a5,1
  18:	02f51963          	bne	a0,a5,4a <main+0x4a>
int main(int argc, char *argv[]){
  1c:	f2840713          	add	a4,s0,-216
  20:	4789                	li	a5,2
        printf("primes: need no parameter\n");
    }

    int w_buf[34];
    int cnt = 0;
    for(int i=2;i<36;i++){
  22:	02400693          	li	a3,36
        w_buf[cnt] = i;
  26:	c31c                	sw	a5,0(a4)
    for(int i=2;i<36;i++){
  28:	2785                	addw	a5,a5,1
  2a:	0711                	add	a4,a4,4
  2c:	fed79de3          	bne	a5,a3,26 <main+0x26>
        cnt ++;
    }
    while(cnt != 0){
        int fd[2];
        pipe(fd);
        write(fd[1],w_buf,sizeof(w_buf));
  30:	f2840913          	add	s2,s0,-216
            // 记得关描述符
            close(fd[0]);
            close(fd[1]);

            int prime = r_buf[0];
            printf("prime %d\n",prime);
  34:	00001a97          	auipc	s5,0x1
  38:	8aca8a93          	add	s5,s5,-1876 # 8e0 <malloc+0x108>
                    w_buf[cnt] = r_buf[i];
                    cnt ++;
                }
            }
            //printf("cnt = %d\n",cnt);
            for(int i=cnt;i<36;i++){
  3c:	02300a13          	li	s4,35
  40:	02300b13          	li	s6,35
  44:	00490993          	add	s3,s2,4
  48:	a825                	j	80 <main+0x80>
        printf("primes: need no parameter\n");
  4a:	00001517          	auipc	a0,0x1
  4e:	87650513          	add	a0,a0,-1930 # 8c0 <malloc+0xe8>
  52:	00000097          	auipc	ra,0x0
  56:	6ce080e7          	jalr	1742(ra) # 720 <printf>
  5a:	b7c9                	j	1c <main+0x1c>
            for(int i=cnt;i<36;i++){
  5c:	029a4163          	blt	s4,s1,7e <main+0x7e>
  60:	00249793          	sll	a5,s1,0x2
  64:	97ca                	add	a5,a5,s2
  66:	409b073b          	subw	a4,s6,s1
  6a:	1702                	sll	a4,a4,0x20
  6c:	9301                	srl	a4,a4,0x20
  6e:	9726                	add	a4,a4,s1
  70:	070a                	sll	a4,a4,0x2
  72:	974e                	add	a4,a4,s3
                w_buf[i] = 0;
  74:	0007a023          	sw	zero,0(a5)
            for(int i=cnt;i<36;i++){
  78:	0791                	add	a5,a5,4
  7a:	fef71de3          	bne	a4,a5,74 <main+0x74>
    while(cnt != 0){
  7e:	ccc9                	beqz	s1,118 <main+0x118>
        pipe(fd);
  80:	e9840513          	add	a0,s0,-360
  84:	00000097          	auipc	ra,0x0
  88:	334080e7          	jalr	820(ra) # 3b8 <pipe>
        write(fd[1],w_buf,sizeof(w_buf));
  8c:	08800613          	li	a2,136
  90:	85ca                	mv	a1,s2
  92:	e9c42503          	lw	a0,-356(s0)
  96:	00000097          	auipc	ra,0x0
  9a:	332080e7          	jalr	818(ra) # 3c8 <write>
        int pid = fork();
  9e:	00000097          	auipc	ra,0x0
  a2:	302080e7          	jalr	770(ra) # 3a0 <fork>
  a6:	84aa                	mv	s1,a0
        if(pid == 0){
  a8:	e13d                	bnez	a0,10e <main+0x10e>
            read(fd[0],r_buf,sizeof(r_buf));
  aa:	08800613          	li	a2,136
  ae:	ea040593          	add	a1,s0,-352
  b2:	e9842503          	lw	a0,-360(s0)
  b6:	00000097          	auipc	ra,0x0
  ba:	30a080e7          	jalr	778(ra) # 3c0 <read>
            close(fd[0]);
  be:	e9842503          	lw	a0,-360(s0)
  c2:	00000097          	auipc	ra,0x0
  c6:	30e080e7          	jalr	782(ra) # 3d0 <close>
            close(fd[1]);
  ca:	e9c42503          	lw	a0,-356(s0)
  ce:	00000097          	auipc	ra,0x0
  d2:	302080e7          	jalr	770(ra) # 3d0 <close>
            int prime = r_buf[0];
  d6:	ea042b83          	lw	s7,-352(s0)
            printf("prime %d\n",prime);
  da:	85de                	mv	a1,s7
  dc:	8556                	mv	a0,s5
  de:	00000097          	auipc	ra,0x0
  e2:	642080e7          	jalr	1602(ra) # 720 <printf>
            for(int i=1;i<34;i++){
  e6:	ea440793          	add	a5,s0,-348
  ea:	a021                	j	f2 <main+0xf2>
  ec:	0791                	add	a5,a5,4
  ee:	f72787e3          	beq	a5,s2,5c <main+0x5c>
                if(r_buf[i] == 0) break;
  f2:	4398                	lw	a4,0(a5)
  f4:	d725                	beqz	a4,5c <main+0x5c>
                if(r_buf[i] % prime != 0){
  f6:	037766bb          	remw	a3,a4,s7
  fa:	daed                	beqz	a3,ec <main+0xec>
                    w_buf[cnt] = r_buf[i];
  fc:	00249693          	sll	a3,s1,0x2
 100:	fb068693          	add	a3,a3,-80
 104:	96a2                	add	a3,a3,s0
 106:	f6e6ac23          	sw	a4,-136(a3)
                    cnt ++;
 10a:	2485                	addw	s1,s1,1
 10c:	b7c5                	j	ec <main+0xec>
            }
        } else {
            wait(NULL); // 父进程要等待子进程结束
 10e:	4501                	li	a0,0
 110:	00000097          	auipc	ra,0x0
 114:	2a0080e7          	jalr	672(ra) # 3b0 <wait>
            break;
        }

    }
    exit(0);
 118:	4501                	li	a0,0
 11a:	00000097          	auipc	ra,0x0
 11e:	28e080e7          	jalr	654(ra) # 3a8 <exit>

0000000000000122 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 122:	1141                	add	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	add	s0,sp,16
  extern int main();
  main();
 12a:	00000097          	auipc	ra,0x0
 12e:	ed6080e7          	jalr	-298(ra) # 0 <main>
  exit(0);
 132:	4501                	li	a0,0
 134:	00000097          	auipc	ra,0x0
 138:	274080e7          	jalr	628(ra) # 3a8 <exit>

000000000000013c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13c:	1141                	add	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 142:	87aa                	mv	a5,a0
 144:	0585                	add	a1,a1,1
 146:	0785                	add	a5,a5,1
 148:	fff5c703          	lbu	a4,-1(a1)
 14c:	fee78fa3          	sb	a4,-1(a5)
 150:	fb75                	bnez	a4,144 <strcpy+0x8>
    ;
  return os;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	add	sp,sp,16
 156:	8082                	ret

0000000000000158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 158:	1141                	add	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb91                	beqz	a5,176 <strcmp+0x1e>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71763          	bne	a4,a5,176 <strcmp+0x1e>
    p++, q++;
 16c:	0505                	add	a0,a0,1
 16e:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	fbe5                	bnez	a5,164 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 176:	0005c503          	lbu	a0,0(a1)
}
 17a:	40a7853b          	subw	a0,a5,a0
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	add	sp,sp,16
 182:	8082                	ret

0000000000000184 <strlen>:

uint
strlen(const char *s)
{
 184:	1141                	add	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cf91                	beqz	a5,1aa <strlen+0x26>
 190:	0505                	add	a0,a0,1
 192:	87aa                	mv	a5,a0
 194:	86be                	mv	a3,a5
 196:	0785                	add	a5,a5,1
 198:	fff7c703          	lbu	a4,-1(a5)
 19c:	ff65                	bnez	a4,194 <strlen+0x10>
 19e:	40a6853b          	subw	a0,a3,a0
 1a2:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	add	sp,sp,16
 1a8:	8082                	ret
  for(n = 0; s[n]; n++)
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strlen+0x20>

00000000000001ae <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ae:	1141                	add	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b4:	ca19                	beqz	a2,1ca <memset+0x1c>
 1b6:	87aa                	mv	a5,a0
 1b8:	1602                	sll	a2,a2,0x20
 1ba:	9201                	srl	a2,a2,0x20
 1bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c4:	0785                	add	a5,a5,1
 1c6:	fee79de3          	bne	a5,a4,1c0 <memset+0x12>
  }
  return dst;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	add	sp,sp,16
 1ce:	8082                	ret

00000000000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	1141                	add	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	add	s0,sp,16
  for(; *s; s++)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	cb99                	beqz	a5,1f0 <strchr+0x20>
    if(*s == c)
 1dc:	00f58763          	beq	a1,a5,1ea <strchr+0x1a>
  for(; *s; s++)
 1e0:	0505                	add	a0,a0,1
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	fbfd                	bnez	a5,1dc <strchr+0xc>
      return (char*)s;
  return 0;
 1e8:	4501                	li	a0,0
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	add	sp,sp,16
 1ee:	8082                	ret
  return 0;
 1f0:	4501                	li	a0,0
 1f2:	bfe5                	j	1ea <strchr+0x1a>

00000000000001f4 <gets>:

char*
gets(char *buf, int max)
{
 1f4:	711d                	add	sp,sp,-96
 1f6:	ec86                	sd	ra,88(sp)
 1f8:	e8a2                	sd	s0,80(sp)
 1fa:	e4a6                	sd	s1,72(sp)
 1fc:	e0ca                	sd	s2,64(sp)
 1fe:	fc4e                	sd	s3,56(sp)
 200:	f852                	sd	s4,48(sp)
 202:	f456                	sd	s5,40(sp)
 204:	f05a                	sd	s6,32(sp)
 206:	ec5e                	sd	s7,24(sp)
 208:	1080                	add	s0,sp,96
 20a:	8baa                	mv	s7,a0
 20c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	892a                	mv	s2,a0
 210:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 212:	4aa9                	li	s5,10
 214:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 216:	89a6                	mv	s3,s1
 218:	2485                	addw	s1,s1,1
 21a:	0344d863          	bge	s1,s4,24a <gets+0x56>
    cc = read(0, &c, 1);
 21e:	4605                	li	a2,1
 220:	faf40593          	add	a1,s0,-81
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	19a080e7          	jalr	410(ra) # 3c0 <read>
    if(cc < 1)
 22e:	00a05e63          	blez	a0,24a <gets+0x56>
    buf[i++] = c;
 232:	faf44783          	lbu	a5,-81(s0)
 236:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23a:	01578763          	beq	a5,s5,248 <gets+0x54>
 23e:	0905                	add	s2,s2,1
 240:	fd679be3          	bne	a5,s6,216 <gets+0x22>
  for(i=0; i+1 < max; ){
 244:	89a6                	mv	s3,s1
 246:	a011                	j	24a <gets+0x56>
 248:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 24a:	99de                	add	s3,s3,s7
 24c:	00098023          	sb	zero,0(s3)
  return buf;
}
 250:	855e                	mv	a0,s7
 252:	60e6                	ld	ra,88(sp)
 254:	6446                	ld	s0,80(sp)
 256:	64a6                	ld	s1,72(sp)
 258:	6906                	ld	s2,64(sp)
 25a:	79e2                	ld	s3,56(sp)
 25c:	7a42                	ld	s4,48(sp)
 25e:	7aa2                	ld	s5,40(sp)
 260:	7b02                	ld	s6,32(sp)
 262:	6be2                	ld	s7,24(sp)
 264:	6125                	add	sp,sp,96
 266:	8082                	ret

0000000000000268 <stat>:

int
stat(const char *n, struct stat *st)
{
 268:	1101                	add	sp,sp,-32
 26a:	ec06                	sd	ra,24(sp)
 26c:	e822                	sd	s0,16(sp)
 26e:	e426                	sd	s1,8(sp)
 270:	e04a                	sd	s2,0(sp)
 272:	1000                	add	s0,sp,32
 274:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 276:	4581                	li	a1,0
 278:	00000097          	auipc	ra,0x0
 27c:	170080e7          	jalr	368(ra) # 3e8 <open>
  if(fd < 0)
 280:	02054563          	bltz	a0,2aa <stat+0x42>
 284:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 286:	85ca                	mv	a1,s2
 288:	00000097          	auipc	ra,0x0
 28c:	178080e7          	jalr	376(ra) # 400 <fstat>
 290:	892a                	mv	s2,a0
  close(fd);
 292:	8526                	mv	a0,s1
 294:	00000097          	auipc	ra,0x0
 298:	13c080e7          	jalr	316(ra) # 3d0 <close>
  return r;
}
 29c:	854a                	mv	a0,s2
 29e:	60e2                	ld	ra,24(sp)
 2a0:	6442                	ld	s0,16(sp)
 2a2:	64a2                	ld	s1,8(sp)
 2a4:	6902                	ld	s2,0(sp)
 2a6:	6105                	add	sp,sp,32
 2a8:	8082                	ret
    return -1;
 2aa:	597d                	li	s2,-1
 2ac:	bfc5                	j	29c <stat+0x34>

00000000000002ae <atoi>:

int
atoi(const char *s)
{
 2ae:	1141                	add	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b4:	00054683          	lbu	a3,0(a0)
 2b8:	fd06879b          	addw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	4625                	li	a2,9
 2c2:	02f66863          	bltu	a2,a5,2f2 <atoi+0x44>
 2c6:	872a                	mv	a4,a0
  n = 0;
 2c8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ca:	0705                	add	a4,a4,1
 2cc:	0025179b          	sllw	a5,a0,0x2
 2d0:	9fa9                	addw	a5,a5,a0
 2d2:	0017979b          	sllw	a5,a5,0x1
 2d6:	9fb5                	addw	a5,a5,a3
 2d8:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2dc:	00074683          	lbu	a3,0(a4)
 2e0:	fd06879b          	addw	a5,a3,-48
 2e4:	0ff7f793          	zext.b	a5,a5
 2e8:	fef671e3          	bgeu	a2,a5,2ca <atoi+0x1c>
  return n;
}
 2ec:	6422                	ld	s0,8(sp)
 2ee:	0141                	add	sp,sp,16
 2f0:	8082                	ret
  n = 0;
 2f2:	4501                	li	a0,0
 2f4:	bfe5                	j	2ec <atoi+0x3e>

00000000000002f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f6:	1141                	add	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fc:	02b57463          	bgeu	a0,a1,324 <memmove+0x2e>
    while(n-- > 0)
 300:	00c05f63          	blez	a2,31e <memmove+0x28>
 304:	1602                	sll	a2,a2,0x20
 306:	9201                	srl	a2,a2,0x20
 308:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 30c:	872a                	mv	a4,a0
      *dst++ = *src++;
 30e:	0585                	add	a1,a1,1
 310:	0705                	add	a4,a4,1
 312:	fff5c683          	lbu	a3,-1(a1)
 316:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31a:	fee79ae3          	bne	a5,a4,30e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	add	sp,sp,16
 322:	8082                	ret
    dst += n;
 324:	00c50733          	add	a4,a0,a2
    src += n;
 328:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 32a:	fec05ae3          	blez	a2,31e <memmove+0x28>
 32e:	fff6079b          	addw	a5,a2,-1
 332:	1782                	sll	a5,a5,0x20
 334:	9381                	srl	a5,a5,0x20
 336:	fff7c793          	not	a5,a5
 33a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33c:	15fd                	add	a1,a1,-1
 33e:	177d                	add	a4,a4,-1
 340:	0005c683          	lbu	a3,0(a1)
 344:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 348:	fee79ae3          	bne	a5,a4,33c <memmove+0x46>
 34c:	bfc9                	j	31e <memmove+0x28>

000000000000034e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34e:	1141                	add	sp,sp,-16
 350:	e422                	sd	s0,8(sp)
 352:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 354:	ca05                	beqz	a2,384 <memcmp+0x36>
 356:	fff6069b          	addw	a3,a2,-1
 35a:	1682                	sll	a3,a3,0x20
 35c:	9281                	srl	a3,a3,0x20
 35e:	0685                	add	a3,a3,1
 360:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 362:	00054783          	lbu	a5,0(a0)
 366:	0005c703          	lbu	a4,0(a1)
 36a:	00e79863          	bne	a5,a4,37a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36e:	0505                	add	a0,a0,1
    p2++;
 370:	0585                	add	a1,a1,1
  while (n-- > 0) {
 372:	fed518e3          	bne	a0,a3,362 <memcmp+0x14>
  }
  return 0;
 376:	4501                	li	a0,0
 378:	a019                	j	37e <memcmp+0x30>
      return *p1 - *p2;
 37a:	40e7853b          	subw	a0,a5,a4
}
 37e:	6422                	ld	s0,8(sp)
 380:	0141                	add	sp,sp,16
 382:	8082                	ret
  return 0;
 384:	4501                	li	a0,0
 386:	bfe5                	j	37e <memcmp+0x30>

0000000000000388 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 388:	1141                	add	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 390:	00000097          	auipc	ra,0x0
 394:	f66080e7          	jalr	-154(ra) # 2f6 <memmove>
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	add	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a0:	4885                	li	a7,1
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a8:	4889                	li	a7,2
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b0:	488d                	li	a7,3
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b8:	4891                	li	a7,4
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <read>:
.global read
read:
 li a7, SYS_read
 3c0:	4895                	li	a7,5
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <write>:
.global write
write:
 li a7, SYS_write
 3c8:	48c1                	li	a7,16
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <close>:
.global close
close:
 li a7, SYS_close
 3d0:	48d5                	li	a7,21
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d8:	4899                	li	a7,6
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e0:	489d                	li	a7,7
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <open>:
.global open
open:
 li a7, SYS_open
 3e8:	48bd                	li	a7,15
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f0:	48c5                	li	a7,17
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f8:	48c9                	li	a7,18
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 400:	48a1                	li	a7,8
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <link>:
.global link
link:
 li a7, SYS_link
 408:	48cd                	li	a7,19
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 410:	48d1                	li	a7,20
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 418:	48a5                	li	a7,9
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <dup>:
.global dup
dup:
 li a7, SYS_dup
 420:	48a9                	li	a7,10
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 428:	48ad                	li	a7,11
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 430:	48b1                	li	a7,12
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 438:	48b5                	li	a7,13
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 440:	48b9                	li	a7,14
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <trace>:
.global trace
trace:
 li a7, SYS_trace
 448:	48d9                	li	a7,22
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 450:	48dd                	li	a7,23
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 458:	1101                	add	sp,sp,-32
 45a:	ec06                	sd	ra,24(sp)
 45c:	e822                	sd	s0,16(sp)
 45e:	1000                	add	s0,sp,32
 460:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 464:	4605                	li	a2,1
 466:	fef40593          	add	a1,s0,-17
 46a:	00000097          	auipc	ra,0x0
 46e:	f5e080e7          	jalr	-162(ra) # 3c8 <write>
}
 472:	60e2                	ld	ra,24(sp)
 474:	6442                	ld	s0,16(sp)
 476:	6105                	add	sp,sp,32
 478:	8082                	ret

000000000000047a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47a:	7139                	add	sp,sp,-64
 47c:	fc06                	sd	ra,56(sp)
 47e:	f822                	sd	s0,48(sp)
 480:	f426                	sd	s1,40(sp)
 482:	f04a                	sd	s2,32(sp)
 484:	ec4e                	sd	s3,24(sp)
 486:	0080                	add	s0,sp,64
 488:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48a:	c299                	beqz	a3,490 <printint+0x16>
 48c:	0805c963          	bltz	a1,51e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 490:	2581                	sext.w	a1,a1
  neg = 0;
 492:	4881                	li	a7,0
 494:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 498:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49a:	2601                	sext.w	a2,a2
 49c:	00000517          	auipc	a0,0x0
 4a0:	4b450513          	add	a0,a0,1204 # 950 <digits>
 4a4:	883a                	mv	a6,a4
 4a6:	2705                	addw	a4,a4,1
 4a8:	02c5f7bb          	remuw	a5,a1,a2
 4ac:	1782                	sll	a5,a5,0x20
 4ae:	9381                	srl	a5,a5,0x20
 4b0:	97aa                	add	a5,a5,a0
 4b2:	0007c783          	lbu	a5,0(a5)
 4b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ba:	0005879b          	sext.w	a5,a1
 4be:	02c5d5bb          	divuw	a1,a1,a2
 4c2:	0685                	add	a3,a3,1
 4c4:	fec7f0e3          	bgeu	a5,a2,4a4 <printint+0x2a>
  if(neg)
 4c8:	00088c63          	beqz	a7,4e0 <printint+0x66>
    buf[i++] = '-';
 4cc:	fd070793          	add	a5,a4,-48
 4d0:	00878733          	add	a4,a5,s0
 4d4:	02d00793          	li	a5,45
 4d8:	fef70823          	sb	a5,-16(a4)
 4dc:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4e0:	02e05863          	blez	a4,510 <printint+0x96>
 4e4:	fc040793          	add	a5,s0,-64
 4e8:	00e78933          	add	s2,a5,a4
 4ec:	fff78993          	add	s3,a5,-1
 4f0:	99ba                	add	s3,s3,a4
 4f2:	377d                	addw	a4,a4,-1
 4f4:	1702                	sll	a4,a4,0x20
 4f6:	9301                	srl	a4,a4,0x20
 4f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fc:	fff94583          	lbu	a1,-1(s2)
 500:	8526                	mv	a0,s1
 502:	00000097          	auipc	ra,0x0
 506:	f56080e7          	jalr	-170(ra) # 458 <putc>
  while(--i >= 0)
 50a:	197d                	add	s2,s2,-1
 50c:	ff3918e3          	bne	s2,s3,4fc <printint+0x82>
}
 510:	70e2                	ld	ra,56(sp)
 512:	7442                	ld	s0,48(sp)
 514:	74a2                	ld	s1,40(sp)
 516:	7902                	ld	s2,32(sp)
 518:	69e2                	ld	s3,24(sp)
 51a:	6121                	add	sp,sp,64
 51c:	8082                	ret
    x = -xx;
 51e:	40b005bb          	negw	a1,a1
    neg = 1;
 522:	4885                	li	a7,1
    x = -xx;
 524:	bf85                	j	494 <printint+0x1a>

0000000000000526 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 526:	715d                	add	sp,sp,-80
 528:	e486                	sd	ra,72(sp)
 52a:	e0a2                	sd	s0,64(sp)
 52c:	fc26                	sd	s1,56(sp)
 52e:	f84a                	sd	s2,48(sp)
 530:	f44e                	sd	s3,40(sp)
 532:	f052                	sd	s4,32(sp)
 534:	ec56                	sd	s5,24(sp)
 536:	e85a                	sd	s6,16(sp)
 538:	e45e                	sd	s7,8(sp)
 53a:	e062                	sd	s8,0(sp)
 53c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 53e:	0005c903          	lbu	s2,0(a1)
 542:	18090c63          	beqz	s2,6da <vprintf+0x1b4>
 546:	8aaa                	mv	s5,a0
 548:	8bb2                	mv	s7,a2
 54a:	00158493          	add	s1,a1,1
  state = 0;
 54e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 550:	02500a13          	li	s4,37
 554:	4b55                	li	s6,21
 556:	a839                	j	574 <vprintf+0x4e>
        putc(fd, c);
 558:	85ca                	mv	a1,s2
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	efc080e7          	jalr	-260(ra) # 458 <putc>
 564:	a019                	j	56a <vprintf+0x44>
    } else if(state == '%'){
 566:	01498d63          	beq	s3,s4,580 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 56a:	0485                	add	s1,s1,1
 56c:	fff4c903          	lbu	s2,-1(s1)
 570:	16090563          	beqz	s2,6da <vprintf+0x1b4>
    if(state == 0){
 574:	fe0999e3          	bnez	s3,566 <vprintf+0x40>
      if(c == '%'){
 578:	ff4910e3          	bne	s2,s4,558 <vprintf+0x32>
        state = '%';
 57c:	89d2                	mv	s3,s4
 57e:	b7f5                	j	56a <vprintf+0x44>
      if(c == 'd'){
 580:	13490263          	beq	s2,s4,6a4 <vprintf+0x17e>
 584:	f9d9079b          	addw	a5,s2,-99
 588:	0ff7f793          	zext.b	a5,a5
 58c:	12fb6563          	bltu	s6,a5,6b6 <vprintf+0x190>
 590:	f9d9079b          	addw	a5,s2,-99
 594:	0ff7f713          	zext.b	a4,a5
 598:	10eb6f63          	bltu	s6,a4,6b6 <vprintf+0x190>
 59c:	00271793          	sll	a5,a4,0x2
 5a0:	00000717          	auipc	a4,0x0
 5a4:	35870713          	add	a4,a4,856 # 8f8 <malloc+0x120>
 5a8:	97ba                	add	a5,a5,a4
 5aa:	439c                	lw	a5,0(a5)
 5ac:	97ba                	add	a5,a5,a4
 5ae:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5b0:	008b8913          	add	s2,s7,8
 5b4:	4685                	li	a3,1
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	ebc080e7          	jalr	-324(ra) # 47a <printint>
 5c6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b745                	j	56a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5cc:	008b8913          	add	s2,s7,8
 5d0:	4681                	li	a3,0
 5d2:	4629                	li	a2,10
 5d4:	000ba583          	lw	a1,0(s7)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	ea0080e7          	jalr	-352(ra) # 47a <printint>
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b751                	j	56a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5e8:	008b8913          	add	s2,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4641                	li	a2,16
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e84080e7          	jalr	-380(ra) # 47a <printint>
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	b7a5                	j	56a <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 604:	008b8c13          	add	s8,s7,8
 608:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 60c:	03000593          	li	a1,48
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	e46080e7          	jalr	-442(ra) # 458 <putc>
  putc(fd, 'x');
 61a:	07800593          	li	a1,120
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e38080e7          	jalr	-456(ra) # 458 <putc>
 628:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62a:	00000b97          	auipc	s7,0x0
 62e:	326b8b93          	add	s7,s7,806 # 950 <digits>
 632:	03c9d793          	srl	a5,s3,0x3c
 636:	97de                	add	a5,a5,s7
 638:	0007c583          	lbu	a1,0(a5)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e1a080e7          	jalr	-486(ra) # 458 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 646:	0992                	sll	s3,s3,0x4
 648:	397d                	addw	s2,s2,-1
 64a:	fe0914e3          	bnez	s2,632 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 64e:	8be2                	mv	s7,s8
      state = 0;
 650:	4981                	li	s3,0
 652:	bf21                	j	56a <vprintf+0x44>
        s = va_arg(ap, char*);
 654:	008b8993          	add	s3,s7,8
 658:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 65c:	02090163          	beqz	s2,67e <vprintf+0x158>
        while(*s != 0){
 660:	00094583          	lbu	a1,0(s2)
 664:	c9a5                	beqz	a1,6d4 <vprintf+0x1ae>
          putc(fd, *s);
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	df0080e7          	jalr	-528(ra) # 458 <putc>
          s++;
 670:	0905                	add	s2,s2,1
        while(*s != 0){
 672:	00094583          	lbu	a1,0(s2)
 676:	f9e5                	bnez	a1,666 <vprintf+0x140>
        s = va_arg(ap, char*);
 678:	8bce                	mv	s7,s3
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b5fd                	j	56a <vprintf+0x44>
          s = "(null)";
 67e:	00000917          	auipc	s2,0x0
 682:	27290913          	add	s2,s2,626 # 8f0 <malloc+0x118>
        while(*s != 0){
 686:	02800593          	li	a1,40
 68a:	bff1                	j	666 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 68c:	008b8913          	add	s2,s7,8
 690:	000bc583          	lbu	a1,0(s7)
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	dc2080e7          	jalr	-574(ra) # 458 <putc>
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b5e1                	j	56a <vprintf+0x44>
        putc(fd, c);
 6a4:	02500593          	li	a1,37
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	dae080e7          	jalr	-594(ra) # 458 <putc>
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bd5d                	j	56a <vprintf+0x44>
        putc(fd, '%');
 6b6:	02500593          	li	a1,37
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	d9c080e7          	jalr	-612(ra) # 458 <putc>
        putc(fd, c);
 6c4:	85ca                	mv	a1,s2
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	d90080e7          	jalr	-624(ra) # 458 <putc>
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bd61                	j	56a <vprintf+0x44>
        s = va_arg(ap, char*);
 6d4:	8bce                	mv	s7,s3
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	bd49                	j	56a <vprintf+0x44>
    }
  }
}
 6da:	60a6                	ld	ra,72(sp)
 6dc:	6406                	ld	s0,64(sp)
 6de:	74e2                	ld	s1,56(sp)
 6e0:	7942                	ld	s2,48(sp)
 6e2:	79a2                	ld	s3,40(sp)
 6e4:	7a02                	ld	s4,32(sp)
 6e6:	6ae2                	ld	s5,24(sp)
 6e8:	6b42                	ld	s6,16(sp)
 6ea:	6ba2                	ld	s7,8(sp)
 6ec:	6c02                	ld	s8,0(sp)
 6ee:	6161                	add	sp,sp,80
 6f0:	8082                	ret

00000000000006f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f2:	715d                	add	sp,sp,-80
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	add	s0,sp,32
 6fa:	e010                	sd	a2,0(s0)
 6fc:	e414                	sd	a3,8(s0)
 6fe:	e818                	sd	a4,16(s0)
 700:	ec1c                	sd	a5,24(s0)
 702:	03043023          	sd	a6,32(s0)
 706:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 70a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70e:	8622                	mv	a2,s0
 710:	00000097          	auipc	ra,0x0
 714:	e16080e7          	jalr	-490(ra) # 526 <vprintf>
}
 718:	60e2                	ld	ra,24(sp)
 71a:	6442                	ld	s0,16(sp)
 71c:	6161                	add	sp,sp,80
 71e:	8082                	ret

0000000000000720 <printf>:

void
printf(const char *fmt, ...)
{
 720:	711d                	add	sp,sp,-96
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	add	s0,sp,32
 728:	e40c                	sd	a1,8(s0)
 72a:	e810                	sd	a2,16(s0)
 72c:	ec14                	sd	a3,24(s0)
 72e:	f018                	sd	a4,32(s0)
 730:	f41c                	sd	a5,40(s0)
 732:	03043823          	sd	a6,48(s0)
 736:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 73a:	00840613          	add	a2,s0,8
 73e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 742:	85aa                	mv	a1,a0
 744:	4505                	li	a0,1
 746:	00000097          	auipc	ra,0x0
 74a:	de0080e7          	jalr	-544(ra) # 526 <vprintf>
}
 74e:	60e2                	ld	ra,24(sp)
 750:	6442                	ld	s0,16(sp)
 752:	6125                	add	sp,sp,96
 754:	8082                	ret

0000000000000756 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 756:	1141                	add	sp,sp,-16
 758:	e422                	sd	s0,8(sp)
 75a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 760:	00001797          	auipc	a5,0x1
 764:	8a07b783          	ld	a5,-1888(a5) # 1000 <freep>
 768:	a02d                	j	792 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 76a:	4618                	lw	a4,8(a2)
 76c:	9f2d                	addw	a4,a4,a1
 76e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 772:	6398                	ld	a4,0(a5)
 774:	6310                	ld	a2,0(a4)
 776:	a83d                	j	7b4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 778:	ff852703          	lw	a4,-8(a0)
 77c:	9f31                	addw	a4,a4,a2
 77e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 780:	ff053683          	ld	a3,-16(a0)
 784:	a091                	j	7c8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 786:	6398                	ld	a4,0(a5)
 788:	00e7e463          	bltu	a5,a4,790 <free+0x3a>
 78c:	00e6ea63          	bltu	a3,a4,7a0 <free+0x4a>
{
 790:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 792:	fed7fae3          	bgeu	a5,a3,786 <free+0x30>
 796:	6398                	ld	a4,0(a5)
 798:	00e6e463          	bltu	a3,a4,7a0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	fee7eae3          	bltu	a5,a4,790 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7a0:	ff852583          	lw	a1,-8(a0)
 7a4:	6390                	ld	a2,0(a5)
 7a6:	02059813          	sll	a6,a1,0x20
 7aa:	01c85713          	srl	a4,a6,0x1c
 7ae:	9736                	add	a4,a4,a3
 7b0:	fae60de3          	beq	a2,a4,76a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7b4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b8:	4790                	lw	a2,8(a5)
 7ba:	02061593          	sll	a1,a2,0x20
 7be:	01c5d713          	srl	a4,a1,0x1c
 7c2:	973e                	add	a4,a4,a5
 7c4:	fae68ae3          	beq	a3,a4,778 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7c8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ca:	00001717          	auipc	a4,0x1
 7ce:	82f73b23          	sd	a5,-1994(a4) # 1000 <freep>
}
 7d2:	6422                	ld	s0,8(sp)
 7d4:	0141                	add	sp,sp,16
 7d6:	8082                	ret

00000000000007d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d8:	7139                	add	sp,sp,-64
 7da:	fc06                	sd	ra,56(sp)
 7dc:	f822                	sd	s0,48(sp)
 7de:	f426                	sd	s1,40(sp)
 7e0:	f04a                	sd	s2,32(sp)
 7e2:	ec4e                	sd	s3,24(sp)
 7e4:	e852                	sd	s4,16(sp)
 7e6:	e456                	sd	s5,8(sp)
 7e8:	e05a                	sd	s6,0(sp)
 7ea:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ec:	02051493          	sll	s1,a0,0x20
 7f0:	9081                	srl	s1,s1,0x20
 7f2:	04bd                	add	s1,s1,15
 7f4:	8091                	srl	s1,s1,0x4
 7f6:	0014899b          	addw	s3,s1,1
 7fa:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7fc:	00001517          	auipc	a0,0x1
 800:	80453503          	ld	a0,-2044(a0) # 1000 <freep>
 804:	c515                	beqz	a0,830 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 806:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 808:	4798                	lw	a4,8(a5)
 80a:	02977f63          	bgeu	a4,s1,848 <malloc+0x70>
  if(nu < 4096)
 80e:	8a4e                	mv	s4,s3
 810:	0009871b          	sext.w	a4,s3
 814:	6685                	lui	a3,0x1
 816:	00d77363          	bgeu	a4,a3,81c <malloc+0x44>
 81a:	6a05                	lui	s4,0x1
 81c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 820:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 824:	00000917          	auipc	s2,0x0
 828:	7dc90913          	add	s2,s2,2012 # 1000 <freep>
  if(p == (char*)-1)
 82c:	5afd                	li	s5,-1
 82e:	a895                	j	8a2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 830:	00000797          	auipc	a5,0x0
 834:	7e078793          	add	a5,a5,2016 # 1010 <base>
 838:	00000717          	auipc	a4,0x0
 83c:	7cf73423          	sd	a5,1992(a4) # 1000 <freep>
 840:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 842:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 846:	b7e1                	j	80e <malloc+0x36>
      if(p->s.size == nunits)
 848:	02e48c63          	beq	s1,a4,880 <malloc+0xa8>
        p->s.size -= nunits;
 84c:	4137073b          	subw	a4,a4,s3
 850:	c798                	sw	a4,8(a5)
        p += p->s.size;
 852:	02071693          	sll	a3,a4,0x20
 856:	01c6d713          	srl	a4,a3,0x1c
 85a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 85c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 860:	00000717          	auipc	a4,0x0
 864:	7aa73023          	sd	a0,1952(a4) # 1000 <freep>
      return (void*)(p + 1);
 868:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 86c:	70e2                	ld	ra,56(sp)
 86e:	7442                	ld	s0,48(sp)
 870:	74a2                	ld	s1,40(sp)
 872:	7902                	ld	s2,32(sp)
 874:	69e2                	ld	s3,24(sp)
 876:	6a42                	ld	s4,16(sp)
 878:	6aa2                	ld	s5,8(sp)
 87a:	6b02                	ld	s6,0(sp)
 87c:	6121                	add	sp,sp,64
 87e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 880:	6398                	ld	a4,0(a5)
 882:	e118                	sd	a4,0(a0)
 884:	bff1                	j	860 <malloc+0x88>
  hp->s.size = nu;
 886:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88a:	0541                	add	a0,a0,16
 88c:	00000097          	auipc	ra,0x0
 890:	eca080e7          	jalr	-310(ra) # 756 <free>
  return freep;
 894:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 898:	d971                	beqz	a0,86c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89c:	4798                	lw	a4,8(a5)
 89e:	fa9775e3          	bgeu	a4,s1,848 <malloc+0x70>
    if(p == freep)
 8a2:	00093703          	ld	a4,0(s2)
 8a6:	853e                	mv	a0,a5
 8a8:	fef719e3          	bne	a4,a5,89a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8ac:	8552                	mv	a0,s4
 8ae:	00000097          	auipc	ra,0x0
 8b2:	b82080e7          	jalr	-1150(ra) # 430 <sbrk>
  if(p == (char*)-1)
 8b6:	fd5518e3          	bne	a0,s5,886 <malloc+0xae>
        return 0;
 8ba:	4501                	li	a0,0
 8bc:	bf45                	j	86c <malloc+0x94>
