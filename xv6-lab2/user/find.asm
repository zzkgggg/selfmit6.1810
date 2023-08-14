
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"
#include <stddef.h>

// fmtname照搬ls
char* fmtname(char *path){
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	348080e7          	jalr	840(ra) # 358 <strlen>
  18:	02051793          	sll	a5,a0,0x20
  1c:	9381                	srl	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	add	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	add	s1,a5,1

  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	31c080e7          	jalr	796(ra) # 358 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  // Return blank-padded name.
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p)); //空格补全
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	add	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2fa080e7          	jalr	762(ra) # 358 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	faa98993          	add	s3,s3,-86 # 1010 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	454080e7          	jalr	1108(ra) # 4ca <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p)); //空格补全
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2d8080e7          	jalr	728(ra) # 358 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2ca080e7          	jalr	714(ra) # 358 <strlen>
  96:	1902                	sll	s2,s2,0x20
  98:	02095913          	srl	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2da080e7          	jalr	730(ra) # 382 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <find>:


void find(char *path, char *target){
  b4:	d9010113          	add	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	add	s0,sp,624
  d6:	8a2a                	mv	s4,a0
  d8:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if((fd = open(path, 0)) < 0){
  da:	4581                	li	a1,0
  dc:	00000097          	auipc	ra,0x0
  e0:	4e0080e7          	jalr	1248(ra) # 5bc <open>
  e4:	08054e63          	bltz	a0,180 <find+0xcc>
  e8:	84aa                	mv	s1,a0
        printf("find: cannot open %s\n", path);
        return;
    }
    
    if(fstat(fd, &st) < 0){
  ea:	d9840593          	add	a1,s0,-616
  ee:	00000097          	auipc	ra,0x0
  f2:	4e6080e7          	jalr	1254(ra) # 5d4 <fstat>
  f6:	08054f63          	bltz	a0,194 <find+0xe0>
        close(fd);
        return;
    }

    //printf("path: %s\n",path);
    switch(st.type){
  fa:	da041783          	lh	a5,-608(s0)
  fe:	4705                	li	a4,1
 100:	0ce78363          	beq	a5,a4,1c6 <find+0x112>
 104:	37f9                	addw	a5,a5,-2
 106:	17c2                	sll	a5,a5,0x30
 108:	93c1                	srl	a5,a5,0x30
 10a:	04f76563          	bltu	a4,a5,154 <find+0xa0>
        case T_DEVICE:
        case T_FILE:
            // target补全至fmtname格式
            memset(target+strlen(target),' ', DIRSIZ-strlen(target));
 10e:	854e                	mv	a0,s3
 110:	00000097          	auipc	ra,0x0
 114:	248080e7          	jalr	584(ra) # 358 <strlen>
 118:	02051913          	sll	s2,a0,0x20
 11c:	02095913          	srl	s2,s2,0x20
 120:	994e                	add	s2,s2,s3
 122:	854e                	mv	a0,s3
 124:	00000097          	auipc	ra,0x0
 128:	234080e7          	jalr	564(ra) # 358 <strlen>
 12c:	4639                	li	a2,14
 12e:	9e09                	subw	a2,a2,a0
 130:	02000593          	li	a1,32
 134:	854a                	mv	a0,s2
 136:	00000097          	auipc	ra,0x0
 13a:	24c080e7          	jalr	588(ra) # 382 <memset>
            if(strcmp(fmtname(path), target) == 0){
 13e:	8552                	mv	a0,s4
 140:	00000097          	auipc	ra,0x0
 144:	ec0080e7          	jalr	-320(ra) # 0 <fmtname>
 148:	85ce                	mv	a1,s3
 14a:	00000097          	auipc	ra,0x0
 14e:	1e2080e7          	jalr	482(ra) # 32c <strcmp>
 152:	c125                	beqz	a0,1b2 <find+0xfe>
    }

    // 一定要记住关fd
    // 经测试，xv6最多允许同时存在14个fd
    // 如果不关的话，资源会很快超限
    close(fd);
 154:	8526                	mv	a0,s1
 156:	00000097          	auipc	ra,0x0
 15a:	44e080e7          	jalr	1102(ra) # 5a4 <close>
}
 15e:	26813083          	ld	ra,616(sp)
 162:	26013403          	ld	s0,608(sp)
 166:	25813483          	ld	s1,600(sp)
 16a:	25013903          	ld	s2,592(sp)
 16e:	24813983          	ld	s3,584(sp)
 172:	24013a03          	ld	s4,576(sp)
 176:	23813a83          	ld	s5,568(sp)
 17a:	27010113          	add	sp,sp,624
 17e:	8082                	ret
        printf("find: cannot open %s\n", path);
 180:	85d2                	mv	a1,s4
 182:	00001517          	auipc	a0,0x1
 186:	91e50513          	add	a0,a0,-1762 # aa0 <malloc+0xf4>
 18a:	00000097          	auipc	ra,0x0
 18e:	76a080e7          	jalr	1898(ra) # 8f4 <printf>
        return;
 192:	b7f1                	j	15e <find+0xaa>
        printf("find: cannot stat %s\n", path);
 194:	85d2                	mv	a1,s4
 196:	00001517          	auipc	a0,0x1
 19a:	92250513          	add	a0,a0,-1758 # ab8 <malloc+0x10c>
 19e:	00000097          	auipc	ra,0x0
 1a2:	756080e7          	jalr	1878(ra) # 8f4 <printf>
        close(fd);
 1a6:	8526                	mv	a0,s1
 1a8:	00000097          	auipc	ra,0x0
 1ac:	3fc080e7          	jalr	1020(ra) # 5a4 <close>
        return;
 1b0:	b77d                	j	15e <find+0xaa>
                printf("%s\n",path);
 1b2:	85d2                	mv	a1,s4
 1b4:	00001517          	auipc	a0,0x1
 1b8:	91c50513          	add	a0,a0,-1764 # ad0 <malloc+0x124>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	738080e7          	jalr	1848(ra) # 8f4 <printf>
 1c4:	bf41                	j	154 <find+0xa0>
            if(strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)){
 1c6:	8552                	mv	a0,s4
 1c8:	00000097          	auipc	ra,0x0
 1cc:	190080e7          	jalr	400(ra) # 358 <strlen>
 1d0:	2541                	addw	a0,a0,16
 1d2:	20000793          	li	a5,512
 1d6:	00a7fb63          	bgeu	a5,a0,1ec <find+0x138>
                printf("find: path too long \n");
 1da:	00001517          	auipc	a0,0x1
 1de:	8fe50513          	add	a0,a0,-1794 # ad8 <malloc+0x12c>
 1e2:	00000097          	auipc	ra,0x0
 1e6:	712080e7          	jalr	1810(ra) # 8f4 <printf>
                break;
 1ea:	b7ad                	j	154 <find+0xa0>
            strcpy(buf, path);
 1ec:	85d2                	mv	a1,s4
 1ee:	dc040513          	add	a0,s0,-576
 1f2:	00000097          	auipc	ra,0x0
 1f6:	11e080e7          	jalr	286(ra) # 310 <strcpy>
            p = buf + strlen(buf);
 1fa:	dc040513          	add	a0,s0,-576
 1fe:	00000097          	auipc	ra,0x0
 202:	15a080e7          	jalr	346(ra) # 358 <strlen>
 206:	1502                	sll	a0,a0,0x20
 208:	9101                	srl	a0,a0,0x20
 20a:	dc040793          	add	a5,s0,-576
 20e:	00a78933          	add	s2,a5,a0
            *p++ = '/';
 212:	00190a93          	add	s5,s2,1
 216:	02f00793          	li	a5,47
 21a:	00f90023          	sb	a5,0(s2)
                if(strcmp(de.name,".") != 0 && strcmp(de.name,"..") != 0){
 21e:	00001a17          	auipc	s4,0x1
 222:	8d2a0a13          	add	s4,s4,-1838 # af0 <malloc+0x144>
            while(read(fd, &de, sizeof(de)) == sizeof(de)){
 226:	4641                	li	a2,16
 228:	db040593          	add	a1,s0,-592
 22c:	8526                	mv	a0,s1
 22e:	00000097          	auipc	ra,0x0
 232:	366080e7          	jalr	870(ra) # 594 <read>
 236:	47c1                	li	a5,16
 238:	f0f51ee3          	bne	a0,a5,154 <find+0xa0>
                if(de.inum == 0) continue;
 23c:	db045783          	lhu	a5,-592(s0)
 240:	d3fd                	beqz	a5,226 <find+0x172>
                memmove(p,de.name,DIRSIZ);
 242:	4639                	li	a2,14
 244:	db240593          	add	a1,s0,-590
 248:	8556                	mv	a0,s5
 24a:	00000097          	auipc	ra,0x0
 24e:	280080e7          	jalr	640(ra) # 4ca <memmove>
                p[DIRSIZ] = 0;
 252:	000907a3          	sb	zero,15(s2)
                if(strcmp(de.name,".") != 0 && strcmp(de.name,"..") != 0){
 256:	85d2                	mv	a1,s4
 258:	db240513          	add	a0,s0,-590
 25c:	00000097          	auipc	ra,0x0
 260:	0d0080e7          	jalr	208(ra) # 32c <strcmp>
 264:	d169                	beqz	a0,226 <find+0x172>
 266:	00001597          	auipc	a1,0x1
 26a:	89258593          	add	a1,a1,-1902 # af8 <malloc+0x14c>
 26e:	db240513          	add	a0,s0,-590
 272:	00000097          	auipc	ra,0x0
 276:	0ba080e7          	jalr	186(ra) # 32c <strcmp>
 27a:	d555                	beqz	a0,226 <find+0x172>
                    find(buf, target);
 27c:	85ce                	mv	a1,s3
 27e:	dc040513          	add	a0,s0,-576
 282:	00000097          	auipc	ra,0x0
 286:	e32080e7          	jalr	-462(ra) # b4 <find>
 28a:	bf71                	j	226 <find+0x172>

000000000000028c <main>:


int main(int argc, char *argv[]){
 28c:	7179                	add	sp,sp,-48
 28e:	f406                	sd	ra,40(sp)
 290:	f022                	sd	s0,32(sp)
 292:	ec26                	sd	s1,24(sp)
 294:	e84a                	sd	s2,16(sp)
 296:	e44e                	sd	s3,8(sp)
 298:	1800                	add	s0,sp,48
 29a:	89ae                	mv	s3,a1
    int i;
    if(argc == 2){
 29c:	4789                	li	a5,2
 29e:	02f50e63          	beq	a0,a5,2da <main+0x4e>
        find(".", argv[1]);
        exit(0);
    }
    for(i=2; i<argc; i++)
 2a2:	02a7d763          	bge	a5,a0,2d0 <main+0x44>
 2a6:	01058493          	add	s1,a1,16
 2aa:	ffd5091b          	addw	s2,a0,-3
 2ae:	02091793          	sll	a5,s2,0x20
 2b2:	01d7d913          	srl	s2,a5,0x1d
 2b6:	01858793          	add	a5,a1,24
 2ba:	993e                	add	s2,s2,a5
    find(argv[1], argv[i]);
 2bc:	608c                	ld	a1,0(s1)
 2be:	0089b503          	ld	a0,8(s3)
 2c2:	00000097          	auipc	ra,0x0
 2c6:	df2080e7          	jalr	-526(ra) # b4 <find>
    for(i=2; i<argc; i++)
 2ca:	04a1                	add	s1,s1,8
 2cc:	ff2498e3          	bne	s1,s2,2bc <main+0x30>
    exit(0);
 2d0:	4501                	li	a0,0
 2d2:	00000097          	auipc	ra,0x0
 2d6:	2aa080e7          	jalr	682(ra) # 57c <exit>
        find(".", argv[1]);
 2da:	658c                	ld	a1,8(a1)
 2dc:	00001517          	auipc	a0,0x1
 2e0:	81450513          	add	a0,a0,-2028 # af0 <malloc+0x144>
 2e4:	00000097          	auipc	ra,0x0
 2e8:	dd0080e7          	jalr	-560(ra) # b4 <find>
        exit(0);
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	28e080e7          	jalr	654(ra) # 57c <exit>

00000000000002f6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2f6:	1141                	add	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	add	s0,sp,16
  extern int main();
  main();
 2fe:	00000097          	auipc	ra,0x0
 302:	f8e080e7          	jalr	-114(ra) # 28c <main>
  exit(0);
 306:	4501                	li	a0,0
 308:	00000097          	auipc	ra,0x0
 30c:	274080e7          	jalr	628(ra) # 57c <exit>

0000000000000310 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 310:	1141                	add	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 316:	87aa                	mv	a5,a0
 318:	0585                	add	a1,a1,1
 31a:	0785                	add	a5,a5,1
 31c:	fff5c703          	lbu	a4,-1(a1)
 320:	fee78fa3          	sb	a4,-1(a5)
 324:	fb75                	bnez	a4,318 <strcpy+0x8>
    ;
  return os;
}
 326:	6422                	ld	s0,8(sp)
 328:	0141                	add	sp,sp,16
 32a:	8082                	ret

000000000000032c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 32c:	1141                	add	sp,sp,-16
 32e:	e422                	sd	s0,8(sp)
 330:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 332:	00054783          	lbu	a5,0(a0)
 336:	cb91                	beqz	a5,34a <strcmp+0x1e>
 338:	0005c703          	lbu	a4,0(a1)
 33c:	00f71763          	bne	a4,a5,34a <strcmp+0x1e>
    p++, q++;
 340:	0505                	add	a0,a0,1
 342:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 344:	00054783          	lbu	a5,0(a0)
 348:	fbe5                	bnez	a5,338 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 34a:	0005c503          	lbu	a0,0(a1)
}
 34e:	40a7853b          	subw	a0,a5,a0
 352:	6422                	ld	s0,8(sp)
 354:	0141                	add	sp,sp,16
 356:	8082                	ret

0000000000000358 <strlen>:

uint
strlen(const char *s)
{
 358:	1141                	add	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 35e:	00054783          	lbu	a5,0(a0)
 362:	cf91                	beqz	a5,37e <strlen+0x26>
 364:	0505                	add	a0,a0,1
 366:	87aa                	mv	a5,a0
 368:	86be                	mv	a3,a5
 36a:	0785                	add	a5,a5,1
 36c:	fff7c703          	lbu	a4,-1(a5)
 370:	ff65                	bnez	a4,368 <strlen+0x10>
 372:	40a6853b          	subw	a0,a3,a0
 376:	2505                	addw	a0,a0,1
    ;
  return n;
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	add	sp,sp,16
 37c:	8082                	ret
  for(n = 0; s[n]; n++)
 37e:	4501                	li	a0,0
 380:	bfe5                	j	378 <strlen+0x20>

0000000000000382 <memset>:

void*
memset(void *dst, int c, uint n)
{
 382:	1141                	add	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 388:	ca19                	beqz	a2,39e <memset+0x1c>
 38a:	87aa                	mv	a5,a0
 38c:	1602                	sll	a2,a2,0x20
 38e:	9201                	srl	a2,a2,0x20
 390:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 394:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 398:	0785                	add	a5,a5,1
 39a:	fee79de3          	bne	a5,a4,394 <memset+0x12>
  }
  return dst;
}
 39e:	6422                	ld	s0,8(sp)
 3a0:	0141                	add	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <strchr>:

char*
strchr(const char *s, char c)
{
 3a4:	1141                	add	sp,sp,-16
 3a6:	e422                	sd	s0,8(sp)
 3a8:	0800                	add	s0,sp,16
  for(; *s; s++)
 3aa:	00054783          	lbu	a5,0(a0)
 3ae:	cb99                	beqz	a5,3c4 <strchr+0x20>
    if(*s == c)
 3b0:	00f58763          	beq	a1,a5,3be <strchr+0x1a>
  for(; *s; s++)
 3b4:	0505                	add	a0,a0,1
 3b6:	00054783          	lbu	a5,0(a0)
 3ba:	fbfd                	bnez	a5,3b0 <strchr+0xc>
      return (char*)s;
  return 0;
 3bc:	4501                	li	a0,0
}
 3be:	6422                	ld	s0,8(sp)
 3c0:	0141                	add	sp,sp,16
 3c2:	8082                	ret
  return 0;
 3c4:	4501                	li	a0,0
 3c6:	bfe5                	j	3be <strchr+0x1a>

00000000000003c8 <gets>:

char*
gets(char *buf, int max)
{
 3c8:	711d                	add	sp,sp,-96
 3ca:	ec86                	sd	ra,88(sp)
 3cc:	e8a2                	sd	s0,80(sp)
 3ce:	e4a6                	sd	s1,72(sp)
 3d0:	e0ca                	sd	s2,64(sp)
 3d2:	fc4e                	sd	s3,56(sp)
 3d4:	f852                	sd	s4,48(sp)
 3d6:	f456                	sd	s5,40(sp)
 3d8:	f05a                	sd	s6,32(sp)
 3da:	ec5e                	sd	s7,24(sp)
 3dc:	1080                	add	s0,sp,96
 3de:	8baa                	mv	s7,a0
 3e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e2:	892a                	mv	s2,a0
 3e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3e6:	4aa9                	li	s5,10
 3e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3ea:	89a6                	mv	s3,s1
 3ec:	2485                	addw	s1,s1,1
 3ee:	0344d863          	bge	s1,s4,41e <gets+0x56>
    cc = read(0, &c, 1);
 3f2:	4605                	li	a2,1
 3f4:	faf40593          	add	a1,s0,-81
 3f8:	4501                	li	a0,0
 3fa:	00000097          	auipc	ra,0x0
 3fe:	19a080e7          	jalr	410(ra) # 594 <read>
    if(cc < 1)
 402:	00a05e63          	blez	a0,41e <gets+0x56>
    buf[i++] = c;
 406:	faf44783          	lbu	a5,-81(s0)
 40a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 40e:	01578763          	beq	a5,s5,41c <gets+0x54>
 412:	0905                	add	s2,s2,1
 414:	fd679be3          	bne	a5,s6,3ea <gets+0x22>
  for(i=0; i+1 < max; ){
 418:	89a6                	mv	s3,s1
 41a:	a011                	j	41e <gets+0x56>
 41c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 41e:	99de                	add	s3,s3,s7
 420:	00098023          	sb	zero,0(s3)
  return buf;
}
 424:	855e                	mv	a0,s7
 426:	60e6                	ld	ra,88(sp)
 428:	6446                	ld	s0,80(sp)
 42a:	64a6                	ld	s1,72(sp)
 42c:	6906                	ld	s2,64(sp)
 42e:	79e2                	ld	s3,56(sp)
 430:	7a42                	ld	s4,48(sp)
 432:	7aa2                	ld	s5,40(sp)
 434:	7b02                	ld	s6,32(sp)
 436:	6be2                	ld	s7,24(sp)
 438:	6125                	add	sp,sp,96
 43a:	8082                	ret

000000000000043c <stat>:

int
stat(const char *n, struct stat *st)
{
 43c:	1101                	add	sp,sp,-32
 43e:	ec06                	sd	ra,24(sp)
 440:	e822                	sd	s0,16(sp)
 442:	e426                	sd	s1,8(sp)
 444:	e04a                	sd	s2,0(sp)
 446:	1000                	add	s0,sp,32
 448:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 44a:	4581                	li	a1,0
 44c:	00000097          	auipc	ra,0x0
 450:	170080e7          	jalr	368(ra) # 5bc <open>
  if(fd < 0)
 454:	02054563          	bltz	a0,47e <stat+0x42>
 458:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 45a:	85ca                	mv	a1,s2
 45c:	00000097          	auipc	ra,0x0
 460:	178080e7          	jalr	376(ra) # 5d4 <fstat>
 464:	892a                	mv	s2,a0
  close(fd);
 466:	8526                	mv	a0,s1
 468:	00000097          	auipc	ra,0x0
 46c:	13c080e7          	jalr	316(ra) # 5a4 <close>
  return r;
}
 470:	854a                	mv	a0,s2
 472:	60e2                	ld	ra,24(sp)
 474:	6442                	ld	s0,16(sp)
 476:	64a2                	ld	s1,8(sp)
 478:	6902                	ld	s2,0(sp)
 47a:	6105                	add	sp,sp,32
 47c:	8082                	ret
    return -1;
 47e:	597d                	li	s2,-1
 480:	bfc5                	j	470 <stat+0x34>

0000000000000482 <atoi>:

int
atoi(const char *s)
{
 482:	1141                	add	sp,sp,-16
 484:	e422                	sd	s0,8(sp)
 486:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 488:	00054683          	lbu	a3,0(a0)
 48c:	fd06879b          	addw	a5,a3,-48
 490:	0ff7f793          	zext.b	a5,a5
 494:	4625                	li	a2,9
 496:	02f66863          	bltu	a2,a5,4c6 <atoi+0x44>
 49a:	872a                	mv	a4,a0
  n = 0;
 49c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 49e:	0705                	add	a4,a4,1
 4a0:	0025179b          	sllw	a5,a0,0x2
 4a4:	9fa9                	addw	a5,a5,a0
 4a6:	0017979b          	sllw	a5,a5,0x1
 4aa:	9fb5                	addw	a5,a5,a3
 4ac:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4b0:	00074683          	lbu	a3,0(a4)
 4b4:	fd06879b          	addw	a5,a3,-48
 4b8:	0ff7f793          	zext.b	a5,a5
 4bc:	fef671e3          	bgeu	a2,a5,49e <atoi+0x1c>
  return n;
}
 4c0:	6422                	ld	s0,8(sp)
 4c2:	0141                	add	sp,sp,16
 4c4:	8082                	ret
  n = 0;
 4c6:	4501                	li	a0,0
 4c8:	bfe5                	j	4c0 <atoi+0x3e>

00000000000004ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4ca:	1141                	add	sp,sp,-16
 4cc:	e422                	sd	s0,8(sp)
 4ce:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4d0:	02b57463          	bgeu	a0,a1,4f8 <memmove+0x2e>
    while(n-- > 0)
 4d4:	00c05f63          	blez	a2,4f2 <memmove+0x28>
 4d8:	1602                	sll	a2,a2,0x20
 4da:	9201                	srl	a2,a2,0x20
 4dc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4e0:	872a                	mv	a4,a0
      *dst++ = *src++;
 4e2:	0585                	add	a1,a1,1
 4e4:	0705                	add	a4,a4,1
 4e6:	fff5c683          	lbu	a3,-1(a1)
 4ea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ee:	fee79ae3          	bne	a5,a4,4e2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4f2:	6422                	ld	s0,8(sp)
 4f4:	0141                	add	sp,sp,16
 4f6:	8082                	ret
    dst += n;
 4f8:	00c50733          	add	a4,a0,a2
    src += n;
 4fc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4fe:	fec05ae3          	blez	a2,4f2 <memmove+0x28>
 502:	fff6079b          	addw	a5,a2,-1
 506:	1782                	sll	a5,a5,0x20
 508:	9381                	srl	a5,a5,0x20
 50a:	fff7c793          	not	a5,a5
 50e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 510:	15fd                	add	a1,a1,-1
 512:	177d                	add	a4,a4,-1
 514:	0005c683          	lbu	a3,0(a1)
 518:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 51c:	fee79ae3          	bne	a5,a4,510 <memmove+0x46>
 520:	bfc9                	j	4f2 <memmove+0x28>

0000000000000522 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 522:	1141                	add	sp,sp,-16
 524:	e422                	sd	s0,8(sp)
 526:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 528:	ca05                	beqz	a2,558 <memcmp+0x36>
 52a:	fff6069b          	addw	a3,a2,-1
 52e:	1682                	sll	a3,a3,0x20
 530:	9281                	srl	a3,a3,0x20
 532:	0685                	add	a3,a3,1
 534:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 536:	00054783          	lbu	a5,0(a0)
 53a:	0005c703          	lbu	a4,0(a1)
 53e:	00e79863          	bne	a5,a4,54e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 542:	0505                	add	a0,a0,1
    p2++;
 544:	0585                	add	a1,a1,1
  while (n-- > 0) {
 546:	fed518e3          	bne	a0,a3,536 <memcmp+0x14>
  }
  return 0;
 54a:	4501                	li	a0,0
 54c:	a019                	j	552 <memcmp+0x30>
      return *p1 - *p2;
 54e:	40e7853b          	subw	a0,a5,a4
}
 552:	6422                	ld	s0,8(sp)
 554:	0141                	add	sp,sp,16
 556:	8082                	ret
  return 0;
 558:	4501                	li	a0,0
 55a:	bfe5                	j	552 <memcmp+0x30>

000000000000055c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 55c:	1141                	add	sp,sp,-16
 55e:	e406                	sd	ra,8(sp)
 560:	e022                	sd	s0,0(sp)
 562:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 564:	00000097          	auipc	ra,0x0
 568:	f66080e7          	jalr	-154(ra) # 4ca <memmove>
}
 56c:	60a2                	ld	ra,8(sp)
 56e:	6402                	ld	s0,0(sp)
 570:	0141                	add	sp,sp,16
 572:	8082                	ret

0000000000000574 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 574:	4885                	li	a7,1
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <exit>:
.global exit
exit:
 li a7, SYS_exit
 57c:	4889                	li	a7,2
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <wait>:
.global wait
wait:
 li a7, SYS_wait
 584:	488d                	li	a7,3
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 58c:	4891                	li	a7,4
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <read>:
.global read
read:
 li a7, SYS_read
 594:	4895                	li	a7,5
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <write>:
.global write
write:
 li a7, SYS_write
 59c:	48c1                	li	a7,16
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <close>:
.global close
close:
 li a7, SYS_close
 5a4:	48d5                	li	a7,21
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <kill>:
.global kill
kill:
 li a7, SYS_kill
 5ac:	4899                	li	a7,6
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b4:	489d                	li	a7,7
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <open>:
.global open
open:
 li a7, SYS_open
 5bc:	48bd                	li	a7,15
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c4:	48c5                	li	a7,17
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5cc:	48c9                	li	a7,18
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d4:	48a1                	li	a7,8
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <link>:
.global link
link:
 li a7, SYS_link
 5dc:	48cd                	li	a7,19
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e4:	48d1                	li	a7,20
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ec:	48a5                	li	a7,9
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f4:	48a9                	li	a7,10
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5fc:	48ad                	li	a7,11
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 604:	48b1                	li	a7,12
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 60c:	48b5                	li	a7,13
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 614:	48b9                	li	a7,14
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <trace>:
.global trace
trace:
 li a7, SYS_trace
 61c:	48d9                	li	a7,22
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 624:	48dd                	li	a7,23
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 62c:	1101                	add	sp,sp,-32
 62e:	ec06                	sd	ra,24(sp)
 630:	e822                	sd	s0,16(sp)
 632:	1000                	add	s0,sp,32
 634:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 638:	4605                	li	a2,1
 63a:	fef40593          	add	a1,s0,-17
 63e:	00000097          	auipc	ra,0x0
 642:	f5e080e7          	jalr	-162(ra) # 59c <write>
}
 646:	60e2                	ld	ra,24(sp)
 648:	6442                	ld	s0,16(sp)
 64a:	6105                	add	sp,sp,32
 64c:	8082                	ret

000000000000064e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 64e:	7139                	add	sp,sp,-64
 650:	fc06                	sd	ra,56(sp)
 652:	f822                	sd	s0,48(sp)
 654:	f426                	sd	s1,40(sp)
 656:	f04a                	sd	s2,32(sp)
 658:	ec4e                	sd	s3,24(sp)
 65a:	0080                	add	s0,sp,64
 65c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 65e:	c299                	beqz	a3,664 <printint+0x16>
 660:	0805c963          	bltz	a1,6f2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 664:	2581                	sext.w	a1,a1
  neg = 0;
 666:	4881                	li	a7,0
 668:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 66c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 66e:	2601                	sext.w	a2,a2
 670:	00000517          	auipc	a0,0x0
 674:	4f050513          	add	a0,a0,1264 # b60 <digits>
 678:	883a                	mv	a6,a4
 67a:	2705                	addw	a4,a4,1
 67c:	02c5f7bb          	remuw	a5,a1,a2
 680:	1782                	sll	a5,a5,0x20
 682:	9381                	srl	a5,a5,0x20
 684:	97aa                	add	a5,a5,a0
 686:	0007c783          	lbu	a5,0(a5)
 68a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 68e:	0005879b          	sext.w	a5,a1
 692:	02c5d5bb          	divuw	a1,a1,a2
 696:	0685                	add	a3,a3,1
 698:	fec7f0e3          	bgeu	a5,a2,678 <printint+0x2a>
  if(neg)
 69c:	00088c63          	beqz	a7,6b4 <printint+0x66>
    buf[i++] = '-';
 6a0:	fd070793          	add	a5,a4,-48
 6a4:	00878733          	add	a4,a5,s0
 6a8:	02d00793          	li	a5,45
 6ac:	fef70823          	sb	a5,-16(a4)
 6b0:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 6b4:	02e05863          	blez	a4,6e4 <printint+0x96>
 6b8:	fc040793          	add	a5,s0,-64
 6bc:	00e78933          	add	s2,a5,a4
 6c0:	fff78993          	add	s3,a5,-1
 6c4:	99ba                	add	s3,s3,a4
 6c6:	377d                	addw	a4,a4,-1
 6c8:	1702                	sll	a4,a4,0x20
 6ca:	9301                	srl	a4,a4,0x20
 6cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d0:	fff94583          	lbu	a1,-1(s2)
 6d4:	8526                	mv	a0,s1
 6d6:	00000097          	auipc	ra,0x0
 6da:	f56080e7          	jalr	-170(ra) # 62c <putc>
  while(--i >= 0)
 6de:	197d                	add	s2,s2,-1
 6e0:	ff3918e3          	bne	s2,s3,6d0 <printint+0x82>
}
 6e4:	70e2                	ld	ra,56(sp)
 6e6:	7442                	ld	s0,48(sp)
 6e8:	74a2                	ld	s1,40(sp)
 6ea:	7902                	ld	s2,32(sp)
 6ec:	69e2                	ld	s3,24(sp)
 6ee:	6121                	add	sp,sp,64
 6f0:	8082                	ret
    x = -xx;
 6f2:	40b005bb          	negw	a1,a1
    neg = 1;
 6f6:	4885                	li	a7,1
    x = -xx;
 6f8:	bf85                	j	668 <printint+0x1a>

00000000000006fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6fa:	715d                	add	sp,sp,-80
 6fc:	e486                	sd	ra,72(sp)
 6fe:	e0a2                	sd	s0,64(sp)
 700:	fc26                	sd	s1,56(sp)
 702:	f84a                	sd	s2,48(sp)
 704:	f44e                	sd	s3,40(sp)
 706:	f052                	sd	s4,32(sp)
 708:	ec56                	sd	s5,24(sp)
 70a:	e85a                	sd	s6,16(sp)
 70c:	e45e                	sd	s7,8(sp)
 70e:	e062                	sd	s8,0(sp)
 710:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 712:	0005c903          	lbu	s2,0(a1)
 716:	18090c63          	beqz	s2,8ae <vprintf+0x1b4>
 71a:	8aaa                	mv	s5,a0
 71c:	8bb2                	mv	s7,a2
 71e:	00158493          	add	s1,a1,1
  state = 0;
 722:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 724:	02500a13          	li	s4,37
 728:	4b55                	li	s6,21
 72a:	a839                	j	748 <vprintf+0x4e>
        putc(fd, c);
 72c:	85ca                	mv	a1,s2
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	efc080e7          	jalr	-260(ra) # 62c <putc>
 738:	a019                	j	73e <vprintf+0x44>
    } else if(state == '%'){
 73a:	01498d63          	beq	s3,s4,754 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 73e:	0485                	add	s1,s1,1
 740:	fff4c903          	lbu	s2,-1(s1)
 744:	16090563          	beqz	s2,8ae <vprintf+0x1b4>
    if(state == 0){
 748:	fe0999e3          	bnez	s3,73a <vprintf+0x40>
      if(c == '%'){
 74c:	ff4910e3          	bne	s2,s4,72c <vprintf+0x32>
        state = '%';
 750:	89d2                	mv	s3,s4
 752:	b7f5                	j	73e <vprintf+0x44>
      if(c == 'd'){
 754:	13490263          	beq	s2,s4,878 <vprintf+0x17e>
 758:	f9d9079b          	addw	a5,s2,-99
 75c:	0ff7f793          	zext.b	a5,a5
 760:	12fb6563          	bltu	s6,a5,88a <vprintf+0x190>
 764:	f9d9079b          	addw	a5,s2,-99
 768:	0ff7f713          	zext.b	a4,a5
 76c:	10eb6f63          	bltu	s6,a4,88a <vprintf+0x190>
 770:	00271793          	sll	a5,a4,0x2
 774:	00000717          	auipc	a4,0x0
 778:	39470713          	add	a4,a4,916 # b08 <malloc+0x15c>
 77c:	97ba                	add	a5,a5,a4
 77e:	439c                	lw	a5,0(a5)
 780:	97ba                	add	a5,a5,a4
 782:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 784:	008b8913          	add	s2,s7,8
 788:	4685                	li	a3,1
 78a:	4629                	li	a2,10
 78c:	000ba583          	lw	a1,0(s7)
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	ebc080e7          	jalr	-324(ra) # 64e <printint>
 79a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b745                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a0:	008b8913          	add	s2,s7,8
 7a4:	4681                	li	a3,0
 7a6:	4629                	li	a2,10
 7a8:	000ba583          	lw	a1,0(s7)
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	ea0080e7          	jalr	-352(ra) # 64e <printint>
 7b6:	8bca                	mv	s7,s2
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	b751                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 7bc:	008b8913          	add	s2,s7,8
 7c0:	4681                	li	a3,0
 7c2:	4641                	li	a2,16
 7c4:	000ba583          	lw	a1,0(s7)
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e84080e7          	jalr	-380(ra) # 64e <printint>
 7d2:	8bca                	mv	s7,s2
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b7a5                	j	73e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 7d8:	008b8c13          	add	s8,s7,8
 7dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e0:	03000593          	li	a1,48
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e46080e7          	jalr	-442(ra) # 62c <putc>
  putc(fd, 'x');
 7ee:	07800593          	li	a1,120
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e38080e7          	jalr	-456(ra) # 62c <putc>
 7fc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fe:	00000b97          	auipc	s7,0x0
 802:	362b8b93          	add	s7,s7,866 # b60 <digits>
 806:	03c9d793          	srl	a5,s3,0x3c
 80a:	97de                	add	a5,a5,s7
 80c:	0007c583          	lbu	a1,0(a5)
 810:	8556                	mv	a0,s5
 812:	00000097          	auipc	ra,0x0
 816:	e1a080e7          	jalr	-486(ra) # 62c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 81a:	0992                	sll	s3,s3,0x4
 81c:	397d                	addw	s2,s2,-1
 81e:	fe0914e3          	bnez	s2,806 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 822:	8be2                	mv	s7,s8
      state = 0;
 824:	4981                	li	s3,0
 826:	bf21                	j	73e <vprintf+0x44>
        s = va_arg(ap, char*);
 828:	008b8993          	add	s3,s7,8
 82c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 830:	02090163          	beqz	s2,852 <vprintf+0x158>
        while(*s != 0){
 834:	00094583          	lbu	a1,0(s2)
 838:	c9a5                	beqz	a1,8a8 <vprintf+0x1ae>
          putc(fd, *s);
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	df0080e7          	jalr	-528(ra) # 62c <putc>
          s++;
 844:	0905                	add	s2,s2,1
        while(*s != 0){
 846:	00094583          	lbu	a1,0(s2)
 84a:	f9e5                	bnez	a1,83a <vprintf+0x140>
        s = va_arg(ap, char*);
 84c:	8bce                	mv	s7,s3
      state = 0;
 84e:	4981                	li	s3,0
 850:	b5fd                	j	73e <vprintf+0x44>
          s = "(null)";
 852:	00000917          	auipc	s2,0x0
 856:	2ae90913          	add	s2,s2,686 # b00 <malloc+0x154>
        while(*s != 0){
 85a:	02800593          	li	a1,40
 85e:	bff1                	j	83a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 860:	008b8913          	add	s2,s7,8
 864:	000bc583          	lbu	a1,0(s7)
 868:	8556                	mv	a0,s5
 86a:	00000097          	auipc	ra,0x0
 86e:	dc2080e7          	jalr	-574(ra) # 62c <putc>
 872:	8bca                	mv	s7,s2
      state = 0;
 874:	4981                	li	s3,0
 876:	b5e1                	j	73e <vprintf+0x44>
        putc(fd, c);
 878:	02500593          	li	a1,37
 87c:	8556                	mv	a0,s5
 87e:	00000097          	auipc	ra,0x0
 882:	dae080e7          	jalr	-594(ra) # 62c <putc>
      state = 0;
 886:	4981                	li	s3,0
 888:	bd5d                	j	73e <vprintf+0x44>
        putc(fd, '%');
 88a:	02500593          	li	a1,37
 88e:	8556                	mv	a0,s5
 890:	00000097          	auipc	ra,0x0
 894:	d9c080e7          	jalr	-612(ra) # 62c <putc>
        putc(fd, c);
 898:	85ca                	mv	a1,s2
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	d90080e7          	jalr	-624(ra) # 62c <putc>
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	bd61                	j	73e <vprintf+0x44>
        s = va_arg(ap, char*);
 8a8:	8bce                	mv	s7,s3
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	bd49                	j	73e <vprintf+0x44>
    }
  }
}
 8ae:	60a6                	ld	ra,72(sp)
 8b0:	6406                	ld	s0,64(sp)
 8b2:	74e2                	ld	s1,56(sp)
 8b4:	7942                	ld	s2,48(sp)
 8b6:	79a2                	ld	s3,40(sp)
 8b8:	7a02                	ld	s4,32(sp)
 8ba:	6ae2                	ld	s5,24(sp)
 8bc:	6b42                	ld	s6,16(sp)
 8be:	6ba2                	ld	s7,8(sp)
 8c0:	6c02                	ld	s8,0(sp)
 8c2:	6161                	add	sp,sp,80
 8c4:	8082                	ret

00000000000008c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8c6:	715d                	add	sp,sp,-80
 8c8:	ec06                	sd	ra,24(sp)
 8ca:	e822                	sd	s0,16(sp)
 8cc:	1000                	add	s0,sp,32
 8ce:	e010                	sd	a2,0(s0)
 8d0:	e414                	sd	a3,8(s0)
 8d2:	e818                	sd	a4,16(s0)
 8d4:	ec1c                	sd	a5,24(s0)
 8d6:	03043023          	sd	a6,32(s0)
 8da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e2:	8622                	mv	a2,s0
 8e4:	00000097          	auipc	ra,0x0
 8e8:	e16080e7          	jalr	-490(ra) # 6fa <vprintf>
}
 8ec:	60e2                	ld	ra,24(sp)
 8ee:	6442                	ld	s0,16(sp)
 8f0:	6161                	add	sp,sp,80
 8f2:	8082                	ret

00000000000008f4 <printf>:

void
printf(const char *fmt, ...)
{
 8f4:	711d                	add	sp,sp,-96
 8f6:	ec06                	sd	ra,24(sp)
 8f8:	e822                	sd	s0,16(sp)
 8fa:	1000                	add	s0,sp,32
 8fc:	e40c                	sd	a1,8(s0)
 8fe:	e810                	sd	a2,16(s0)
 900:	ec14                	sd	a3,24(s0)
 902:	f018                	sd	a4,32(s0)
 904:	f41c                	sd	a5,40(s0)
 906:	03043823          	sd	a6,48(s0)
 90a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 90e:	00840613          	add	a2,s0,8
 912:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 916:	85aa                	mv	a1,a0
 918:	4505                	li	a0,1
 91a:	00000097          	auipc	ra,0x0
 91e:	de0080e7          	jalr	-544(ra) # 6fa <vprintf>
}
 922:	60e2                	ld	ra,24(sp)
 924:	6442                	ld	s0,16(sp)
 926:	6125                	add	sp,sp,96
 928:	8082                	ret

000000000000092a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 92a:	1141                	add	sp,sp,-16
 92c:	e422                	sd	s0,8(sp)
 92e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 930:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 934:	00000797          	auipc	a5,0x0
 938:	6cc7b783          	ld	a5,1740(a5) # 1000 <freep>
 93c:	a02d                	j	966 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 93e:	4618                	lw	a4,8(a2)
 940:	9f2d                	addw	a4,a4,a1
 942:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	6310                	ld	a2,0(a4)
 94a:	a83d                	j	988 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 94c:	ff852703          	lw	a4,-8(a0)
 950:	9f31                	addw	a4,a4,a2
 952:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 954:	ff053683          	ld	a3,-16(a0)
 958:	a091                	j	99c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95a:	6398                	ld	a4,0(a5)
 95c:	00e7e463          	bltu	a5,a4,964 <free+0x3a>
 960:	00e6ea63          	bltu	a3,a4,974 <free+0x4a>
{
 964:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 966:	fed7fae3          	bgeu	a5,a3,95a <free+0x30>
 96a:	6398                	ld	a4,0(a5)
 96c:	00e6e463          	bltu	a3,a4,974 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 970:	fee7eae3          	bltu	a5,a4,964 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 974:	ff852583          	lw	a1,-8(a0)
 978:	6390                	ld	a2,0(a5)
 97a:	02059813          	sll	a6,a1,0x20
 97e:	01c85713          	srl	a4,a6,0x1c
 982:	9736                	add	a4,a4,a3
 984:	fae60de3          	beq	a2,a4,93e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 988:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 98c:	4790                	lw	a2,8(a5)
 98e:	02061593          	sll	a1,a2,0x20
 992:	01c5d713          	srl	a4,a1,0x1c
 996:	973e                	add	a4,a4,a5
 998:	fae68ae3          	beq	a3,a4,94c <free+0x22>
    p->s.ptr = bp->s.ptr;
 99c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 99e:	00000717          	auipc	a4,0x0
 9a2:	66f73123          	sd	a5,1634(a4) # 1000 <freep>
}
 9a6:	6422                	ld	s0,8(sp)
 9a8:	0141                	add	sp,sp,16
 9aa:	8082                	ret

00000000000009ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ac:	7139                	add	sp,sp,-64
 9ae:	fc06                	sd	ra,56(sp)
 9b0:	f822                	sd	s0,48(sp)
 9b2:	f426                	sd	s1,40(sp)
 9b4:	f04a                	sd	s2,32(sp)
 9b6:	ec4e                	sd	s3,24(sp)
 9b8:	e852                	sd	s4,16(sp)
 9ba:	e456                	sd	s5,8(sp)
 9bc:	e05a                	sd	s6,0(sp)
 9be:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c0:	02051493          	sll	s1,a0,0x20
 9c4:	9081                	srl	s1,s1,0x20
 9c6:	04bd                	add	s1,s1,15
 9c8:	8091                	srl	s1,s1,0x4
 9ca:	0014899b          	addw	s3,s1,1
 9ce:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 9d0:	00000517          	auipc	a0,0x0
 9d4:	63053503          	ld	a0,1584(a0) # 1000 <freep>
 9d8:	c515                	beqz	a0,a04 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9dc:	4798                	lw	a4,8(a5)
 9de:	02977f63          	bgeu	a4,s1,a1c <malloc+0x70>
  if(nu < 4096)
 9e2:	8a4e                	mv	s4,s3
 9e4:	0009871b          	sext.w	a4,s3
 9e8:	6685                	lui	a3,0x1
 9ea:	00d77363          	bgeu	a4,a3,9f0 <malloc+0x44>
 9ee:	6a05                	lui	s4,0x1
 9f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f8:	00000917          	auipc	s2,0x0
 9fc:	60890913          	add	s2,s2,1544 # 1000 <freep>
  if(p == (char*)-1)
 a00:	5afd                	li	s5,-1
 a02:	a895                	j	a76 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a04:	00000797          	auipc	a5,0x0
 a08:	61c78793          	add	a5,a5,1564 # 1020 <base>
 a0c:	00000717          	auipc	a4,0x0
 a10:	5ef73a23          	sd	a5,1524(a4) # 1000 <freep>
 a14:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a16:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a1a:	b7e1                	j	9e2 <malloc+0x36>
      if(p->s.size == nunits)
 a1c:	02e48c63          	beq	s1,a4,a54 <malloc+0xa8>
        p->s.size -= nunits;
 a20:	4137073b          	subw	a4,a4,s3
 a24:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a26:	02071693          	sll	a3,a4,0x20
 a2a:	01c6d713          	srl	a4,a3,0x1c
 a2e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a30:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a34:	00000717          	auipc	a4,0x0
 a38:	5ca73623          	sd	a0,1484(a4) # 1000 <freep>
      return (void*)(p + 1);
 a3c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a40:	70e2                	ld	ra,56(sp)
 a42:	7442                	ld	s0,48(sp)
 a44:	74a2                	ld	s1,40(sp)
 a46:	7902                	ld	s2,32(sp)
 a48:	69e2                	ld	s3,24(sp)
 a4a:	6a42                	ld	s4,16(sp)
 a4c:	6aa2                	ld	s5,8(sp)
 a4e:	6b02                	ld	s6,0(sp)
 a50:	6121                	add	sp,sp,64
 a52:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a54:	6398                	ld	a4,0(a5)
 a56:	e118                	sd	a4,0(a0)
 a58:	bff1                	j	a34 <malloc+0x88>
  hp->s.size = nu;
 a5a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a5e:	0541                	add	a0,a0,16
 a60:	00000097          	auipc	ra,0x0
 a64:	eca080e7          	jalr	-310(ra) # 92a <free>
  return freep;
 a68:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a6c:	d971                	beqz	a0,a40 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a70:	4798                	lw	a4,8(a5)
 a72:	fa9775e3          	bgeu	a4,s1,a1c <malloc+0x70>
    if(p == freep)
 a76:	00093703          	ld	a4,0(s2)
 a7a:	853e                	mv	a0,a5
 a7c:	fef719e3          	bne	a4,a5,a6e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a80:	8552                	mv	a0,s4
 a82:	00000097          	auipc	ra,0x0
 a86:	b82080e7          	jalr	-1150(ra) # 604 <sbrk>
  if(p == (char*)-1)
 a8a:	fd5518e3          	bne	a0,s5,a5a <malloc+0xae>
        return 0;
 a8e:	4501                	li	a0,0
 a90:	bf45                	j	a40 <malloc+0x94>
