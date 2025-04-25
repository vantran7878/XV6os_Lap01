
user/_sysinfotest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "../kernel/riscv.h"
//#include "../kernel/sysinfo.h"
#include "user.h"


int main() {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  struct sysinfo info;
  if (sysinfo(&info) < 0) {
   8:	fe040513          	addi	a0,s0,-32
   c:	39e000ef          	jal	3aa <sysinfo>
  10:	02054f63          	bltz	a0,4e <main+0x4e>
    printf("sysinfo syscall failed\n");
    return 0;
  }
  printf("Free memory: %d bytes\n", info.freemem);
  14:	fe042583          	lw	a1,-32(s0)
  18:	00001517          	auipc	a0,0x1
  1c:	8c050513          	addi	a0,a0,-1856 # 8d8 <malloc+0x10c>
  20:	6f4000ef          	jal	714 <printf>
  printf("Number of processes: %d\n", info.nproc);
  24:	fe442583          	lw	a1,-28(s0)
  28:	00001517          	auipc	a0,0x1
  2c:	8d050513          	addi	a0,a0,-1840 # 8f8 <malloc+0x12c>
  30:	6e4000ef          	jal	714 <printf>
  printf("Number of openfile: %d\n", info.nopenfile);
  34:	fe842583          	lw	a1,-24(s0)
  38:	00001517          	auipc	a0,0x1
  3c:	8e050513          	addi	a0,a0,-1824 # 918 <malloc+0x14c>
  40:	6d4000ef          	jal	714 <printf>
  return 0;
}
  44:	4501                	li	a0,0
  46:	60e2                	ld	ra,24(sp)
  48:	6442                	ld	s0,16(sp)
  4a:	6105                	addi	sp,sp,32
  4c:	8082                	ret
    printf("sysinfo syscall failed\n");
  4e:	00001517          	auipc	a0,0x1
  52:	87250513          	addi	a0,a0,-1934 # 8c0 <malloc+0xf4>
  56:	6be000ef          	jal	714 <printf>
    return 0;
  5a:	b7ed                	j	44 <main+0x44>

000000000000005c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  5c:	1141                	addi	sp,sp,-16
  5e:	e406                	sd	ra,8(sp)
  60:	e022                	sd	s0,0(sp)
  62:	0800                	addi	s0,sp,16
  extern int main();
  main();
  64:	f9dff0ef          	jal	0 <main>
  exit(0);
  68:	4501                	li	a0,0
  6a:	290000ef          	jal	2fa <exit>

000000000000006e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6e:	1141                	addi	sp,sp,-16
  70:	e406                	sd	ra,8(sp)
  72:	e022                	sd	s0,0(sp)
  74:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  76:	87aa                	mv	a5,a0
  78:	0585                	addi	a1,a1,1
  7a:	0785                	addi	a5,a5,1
  7c:	fff5c703          	lbu	a4,-1(a1)
  80:	fee78fa3          	sb	a4,-1(a5)
  84:	fb75                	bnez	a4,78 <strcpy+0xa>
    ;
  return os;
}
  86:	60a2                	ld	ra,8(sp)
  88:	6402                	ld	s0,0(sp)
  8a:	0141                	addi	sp,sp,16
  8c:	8082                	ret

000000000000008e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	cb91                	beqz	a5,ae <strcmp+0x20>
  9c:	0005c703          	lbu	a4,0(a1)
  a0:	00f71763          	bne	a4,a5,ae <strcmp+0x20>
    p++, q++;
  a4:	0505                	addi	a0,a0,1
  a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	fbe5                	bnez	a5,9c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ae:	0005c503          	lbu	a0,0(a1)
}
  b2:	40a7853b          	subw	a0,a5,a0
  b6:	60a2                	ld	ra,8(sp)
  b8:	6402                	ld	s0,0(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strlen>:

uint
strlen(const char *s)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e406                	sd	ra,8(sp)
  c2:	e022                	sd	s0,0(sp)
  c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf99                	beqz	a5,e8 <strlen+0x2a>
  cc:	0505                	addi	a0,a0,1
  ce:	87aa                	mv	a5,a0
  d0:	86be                	mv	a3,a5
  d2:	0785                	addi	a5,a5,1
  d4:	fff7c703          	lbu	a4,-1(a5)
  d8:	ff65                	bnez	a4,d0 <strlen+0x12>
  da:	40a6853b          	subw	a0,a3,a0
  de:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e0:	60a2                	ld	ra,8(sp)
  e2:	6402                	ld	s0,0(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret
  for(n = 0; s[n]; n++)
  e8:	4501                	li	a0,0
  ea:	bfdd                	j	e0 <strlen+0x22>

00000000000000ec <memset>:

void*
memset(void *dst, int c, uint n)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f4:	ca19                	beqz	a2,10a <memset+0x1e>
  f6:	87aa                	mv	a5,a0
  f8:	1602                	slli	a2,a2,0x20
  fa:	9201                	srli	a2,a2,0x20
  fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 100:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 104:	0785                	addi	a5,a5,1
 106:	fee79de3          	bne	a5,a4,100 <memset+0x14>
  }
  return dst;
}
 10a:	60a2                	ld	ra,8(sp)
 10c:	6402                	ld	s0,0(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strchr>:

char*
strchr(const char *s, char c)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cf81                	beqz	a5,136 <strchr+0x24>
    if(*s == c)
 120:	00f58763          	beq	a1,a5,12e <strchr+0x1c>
  for(; *s; s++)
 124:	0505                	addi	a0,a0,1
 126:	00054783          	lbu	a5,0(a0)
 12a:	fbfd                	bnez	a5,120 <strchr+0xe>
      return (char*)s;
  return 0;
 12c:	4501                	li	a0,0
}
 12e:	60a2                	ld	ra,8(sp)
 130:	6402                	ld	s0,0(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret
  return 0;
 136:	4501                	li	a0,0
 138:	bfdd                	j	12e <strchr+0x1c>

000000000000013a <gets>:

char*
gets(char *buf, int max)
{
 13a:	7159                	addi	sp,sp,-112
 13c:	f486                	sd	ra,104(sp)
 13e:	f0a2                	sd	s0,96(sp)
 140:	eca6                	sd	s1,88(sp)
 142:	e8ca                	sd	s2,80(sp)
 144:	e4ce                	sd	s3,72(sp)
 146:	e0d2                	sd	s4,64(sp)
 148:	fc56                	sd	s5,56(sp)
 14a:	f85a                	sd	s6,48(sp)
 14c:	f45e                	sd	s7,40(sp)
 14e:	f062                	sd	s8,32(sp)
 150:	ec66                	sd	s9,24(sp)
 152:	e86a                	sd	s10,16(sp)
 154:	1880                	addi	s0,sp,112
 156:	8caa                	mv	s9,a0
 158:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15a:	892a                	mv	s2,a0
 15c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 15e:	f9f40b13          	addi	s6,s0,-97
 162:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 164:	4ba9                	li	s7,10
 166:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 168:	8d26                	mv	s10,s1
 16a:	0014899b          	addiw	s3,s1,1
 16e:	84ce                	mv	s1,s3
 170:	0349d563          	bge	s3,s4,19a <gets+0x60>
    cc = read(0, &c, 1);
 174:	8656                	mv	a2,s5
 176:	85da                	mv	a1,s6
 178:	4501                	li	a0,0
 17a:	198000ef          	jal	312 <read>
    if(cc < 1)
 17e:	00a05e63          	blez	a0,19a <gets+0x60>
    buf[i++] = c;
 182:	f9f44783          	lbu	a5,-97(s0)
 186:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 18a:	01778763          	beq	a5,s7,198 <gets+0x5e>
 18e:	0905                	addi	s2,s2,1
 190:	fd879ce3          	bne	a5,s8,168 <gets+0x2e>
    buf[i++] = c;
 194:	8d4e                	mv	s10,s3
 196:	a011                	j	19a <gets+0x60>
 198:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 19a:	9d66                	add	s10,s10,s9
 19c:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1a0:	8566                	mv	a0,s9
 1a2:	70a6                	ld	ra,104(sp)
 1a4:	7406                	ld	s0,96(sp)
 1a6:	64e6                	ld	s1,88(sp)
 1a8:	6946                	ld	s2,80(sp)
 1aa:	69a6                	ld	s3,72(sp)
 1ac:	6a06                	ld	s4,64(sp)
 1ae:	7ae2                	ld	s5,56(sp)
 1b0:	7b42                	ld	s6,48(sp)
 1b2:	7ba2                	ld	s7,40(sp)
 1b4:	7c02                	ld	s8,32(sp)
 1b6:	6ce2                	ld	s9,24(sp)
 1b8:	6d42                	ld	s10,16(sp)
 1ba:	6165                	addi	sp,sp,112
 1bc:	8082                	ret

00000000000001be <stat>:

int
stat(const char *n, struct stat *st)
{
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec06                	sd	ra,24(sp)
 1c2:	e822                	sd	s0,16(sp)
 1c4:	e04a                	sd	s2,0(sp)
 1c6:	1000                	addi	s0,sp,32
 1c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ca:	4581                	li	a1,0
 1cc:	16e000ef          	jal	33a <open>
  if(fd < 0)
 1d0:	02054263          	bltz	a0,1f4 <stat+0x36>
 1d4:	e426                	sd	s1,8(sp)
 1d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d8:	85ca                	mv	a1,s2
 1da:	178000ef          	jal	352 <fstat>
 1de:	892a                	mv	s2,a0
  close(fd);
 1e0:	8526                	mv	a0,s1
 1e2:	140000ef          	jal	322 <close>
  return r;
 1e6:	64a2                	ld	s1,8(sp)
}
 1e8:	854a                	mv	a0,s2
 1ea:	60e2                	ld	ra,24(sp)
 1ec:	6442                	ld	s0,16(sp)
 1ee:	6902                	ld	s2,0(sp)
 1f0:	6105                	addi	sp,sp,32
 1f2:	8082                	ret
    return -1;
 1f4:	597d                	li	s2,-1
 1f6:	bfcd                	j	1e8 <stat+0x2a>

00000000000001f8 <atoi>:

int
atoi(const char *s)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e406                	sd	ra,8(sp)
 1fc:	e022                	sd	s0,0(sp)
 1fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 200:	00054683          	lbu	a3,0(a0)
 204:	fd06879b          	addiw	a5,a3,-48
 208:	0ff7f793          	zext.b	a5,a5
 20c:	4625                	li	a2,9
 20e:	02f66963          	bltu	a2,a5,240 <atoi+0x48>
 212:	872a                	mv	a4,a0
  n = 0;
 214:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 216:	0705                	addi	a4,a4,1
 218:	0025179b          	slliw	a5,a0,0x2
 21c:	9fa9                	addw	a5,a5,a0
 21e:	0017979b          	slliw	a5,a5,0x1
 222:	9fb5                	addw	a5,a5,a3
 224:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 228:	00074683          	lbu	a3,0(a4)
 22c:	fd06879b          	addiw	a5,a3,-48
 230:	0ff7f793          	zext.b	a5,a5
 234:	fef671e3          	bgeu	a2,a5,216 <atoi+0x1e>
  return n;
}
 238:	60a2                	ld	ra,8(sp)
 23a:	6402                	ld	s0,0(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  n = 0;
 240:	4501                	li	a0,0
 242:	bfdd                	j	238 <atoi+0x40>

0000000000000244 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57563          	bgeu	a0,a1,276 <memmove+0x32>
    while(n-- > 0)
 250:	00c05f63          	blez	a2,26e <memmove+0x2a>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25c:	872a                	mv	a4,a0
      *dst++ = *src++;
 25e:	0585                	addi	a1,a1,1
 260:	0705                	addi	a4,a4,1
 262:	fff5c683          	lbu	a3,-1(a1)
 266:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26a:	fee79ae3          	bne	a5,a4,25e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26e:	60a2                	ld	ra,8(sp)
 270:	6402                	ld	s0,0(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
    dst += n;
 276:	00c50733          	add	a4,a0,a2
    src += n;
 27a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27c:	fec059e3          	blez	a2,26e <memmove+0x2a>
 280:	fff6079b          	addiw	a5,a2,-1
 284:	1782                	slli	a5,a5,0x20
 286:	9381                	srli	a5,a5,0x20
 288:	fff7c793          	not	a5,a5
 28c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28e:	15fd                	addi	a1,a1,-1
 290:	177d                	addi	a4,a4,-1
 292:	0005c683          	lbu	a3,0(a1)
 296:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 29a:	fef71ae3          	bne	a4,a5,28e <memmove+0x4a>
 29e:	bfc1                	j	26e <memmove+0x2a>

00000000000002a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a8:	ca0d                	beqz	a2,2da <memcmp+0x3a>
 2aa:	fff6069b          	addiw	a3,a2,-1
 2ae:	1682                	slli	a3,a3,0x20
 2b0:	9281                	srli	a3,a3,0x20
 2b2:	0685                	addi	a3,a3,1
 2b4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b6:	00054783          	lbu	a5,0(a0)
 2ba:	0005c703          	lbu	a4,0(a1)
 2be:	00e79863          	bne	a5,a4,2ce <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2c2:	0505                	addi	a0,a0,1
    p2++;
 2c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c6:	fed518e3          	bne	a0,a3,2b6 <memcmp+0x16>
  }
  return 0;
 2ca:	4501                	li	a0,0
 2cc:	a019                	j	2d2 <memcmp+0x32>
      return *p1 - *p2;
 2ce:	40e7853b          	subw	a0,a5,a4
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  return 0;
 2da:	4501                	li	a0,0
 2dc:	bfdd                	j	2d2 <memcmp+0x32>

00000000000002de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e6:	f5fff0ef          	jal	244 <memmove>
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f2:	4885                	li	a7,1
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fa:	4889                	li	a7,2
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <wait>:
.global wait
wait:
 li a7, SYS_wait
 302:	488d                	li	a7,3
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30a:	4891                	li	a7,4
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <read>:
.global read
read:
 li a7, SYS_read
 312:	4895                	li	a7,5
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <write>:
.global write
write:
 li a7, SYS_write
 31a:	48c1                	li	a7,16
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <close>:
.global close
close:
 li a7, SYS_close
 322:	48d5                	li	a7,21
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <kill>:
.global kill
kill:
 li a7, SYS_kill
 32a:	4899                	li	a7,6
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <exec>:
.global exec
exec:
 li a7, SYS_exec
 332:	489d                	li	a7,7
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <open>:
.global open
open:
 li a7, SYS_open
 33a:	48bd                	li	a7,15
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 342:	48c5                	li	a7,17
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34a:	48c9                	li	a7,18
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 352:	48a1                	li	a7,8
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <link>:
.global link
link:
 li a7, SYS_link
 35a:	48cd                	li	a7,19
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 362:	48d1                	li	a7,20
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36a:	48a5                	li	a7,9
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <dup>:
.global dup
dup:
 li a7, SYS_dup
 372:	48a9                	li	a7,10
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37a:	48ad                	li	a7,11
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 382:	48b1                	li	a7,12
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38a:	48b5                	li	a7,13
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 392:	48b9                	li	a7,14
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <hello>:
.global hello
hello:
 li a7, SYS_hello
 39a:	48d9                	li	a7,22
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3a2:	48dd                	li	a7,23
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3aa:	48e1                	li	a7,24
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b2:	1101                	addi	sp,sp,-32
 3b4:	ec06                	sd	ra,24(sp)
 3b6:	e822                	sd	s0,16(sp)
 3b8:	1000                	addi	s0,sp,32
 3ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3be:	4605                	li	a2,1
 3c0:	fef40593          	addi	a1,s0,-17
 3c4:	f57ff0ef          	jal	31a <write>
}
 3c8:	60e2                	ld	ra,24(sp)
 3ca:	6442                	ld	s0,16(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret

00000000000003d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	7139                	addi	sp,sp,-64
 3d2:	fc06                	sd	ra,56(sp)
 3d4:	f822                	sd	s0,48(sp)
 3d6:	f426                	sd	s1,40(sp)
 3d8:	f04a                	sd	s2,32(sp)
 3da:	ec4e                	sd	s3,24(sp)
 3dc:	0080                	addi	s0,sp,64
 3de:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e0:	c299                	beqz	a3,3e6 <printint+0x16>
 3e2:	0605ce63          	bltz	a1,45e <printint+0x8e>
  neg = 0;
 3e6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3e8:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3ec:	869a                	mv	a3,t1
  i = 0;
 3ee:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3f0:	00000817          	auipc	a6,0x0
 3f4:	54880813          	addi	a6,a6,1352 # 938 <digits>
 3f8:	88be                	mv	a7,a5
 3fa:	0017851b          	addiw	a0,a5,1
 3fe:	87aa                	mv	a5,a0
 400:	02c5f73b          	remuw	a4,a1,a2
 404:	1702                	slli	a4,a4,0x20
 406:	9301                	srli	a4,a4,0x20
 408:	9742                	add	a4,a4,a6
 40a:	00074703          	lbu	a4,0(a4)
 40e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 412:	872e                	mv	a4,a1
 414:	02c5d5bb          	divuw	a1,a1,a2
 418:	0685                	addi	a3,a3,1
 41a:	fcc77fe3          	bgeu	a4,a2,3f8 <printint+0x28>
  if(neg)
 41e:	000e0c63          	beqz	t3,436 <printint+0x66>
    buf[i++] = '-';
 422:	fd050793          	addi	a5,a0,-48
 426:	00878533          	add	a0,a5,s0
 42a:	02d00793          	li	a5,45
 42e:	fef50823          	sb	a5,-16(a0)
 432:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 436:	fff7899b          	addiw	s3,a5,-1
 43a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 43e:	fff4c583          	lbu	a1,-1(s1)
 442:	854a                	mv	a0,s2
 444:	f6fff0ef          	jal	3b2 <putc>
  while(--i >= 0)
 448:	39fd                	addiw	s3,s3,-1
 44a:	14fd                	addi	s1,s1,-1
 44c:	fe09d9e3          	bgez	s3,43e <printint+0x6e>
}
 450:	70e2                	ld	ra,56(sp)
 452:	7442                	ld	s0,48(sp)
 454:	74a2                	ld	s1,40(sp)
 456:	7902                	ld	s2,32(sp)
 458:	69e2                	ld	s3,24(sp)
 45a:	6121                	addi	sp,sp,64
 45c:	8082                	ret
    x = -xx;
 45e:	40b005bb          	negw	a1,a1
    neg = 1;
 462:	4e05                	li	t3,1
    x = -xx;
 464:	b751                	j	3e8 <printint+0x18>

0000000000000466 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 466:	711d                	addi	sp,sp,-96
 468:	ec86                	sd	ra,88(sp)
 46a:	e8a2                	sd	s0,80(sp)
 46c:	e4a6                	sd	s1,72(sp)
 46e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 470:	0005c483          	lbu	s1,0(a1)
 474:	26048663          	beqz	s1,6e0 <vprintf+0x27a>
 478:	e0ca                	sd	s2,64(sp)
 47a:	fc4e                	sd	s3,56(sp)
 47c:	f852                	sd	s4,48(sp)
 47e:	f456                	sd	s5,40(sp)
 480:	f05a                	sd	s6,32(sp)
 482:	ec5e                	sd	s7,24(sp)
 484:	e862                	sd	s8,16(sp)
 486:	e466                	sd	s9,8(sp)
 488:	8b2a                	mv	s6,a0
 48a:	8a2e                	mv	s4,a1
 48c:	8bb2                	mv	s7,a2
  state = 0;
 48e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 490:	4901                	li	s2,0
 492:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 494:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 498:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 49c:	06c00c93          	li	s9,108
 4a0:	a00d                	j	4c2 <vprintf+0x5c>
        putc(fd, c0);
 4a2:	85a6                	mv	a1,s1
 4a4:	855a                	mv	a0,s6
 4a6:	f0dff0ef          	jal	3b2 <putc>
 4aa:	a019                	j	4b0 <vprintf+0x4a>
    } else if(state == '%'){
 4ac:	03598363          	beq	s3,s5,4d2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4b0:	0019079b          	addiw	a5,s2,1
 4b4:	893e                	mv	s2,a5
 4b6:	873e                	mv	a4,a5
 4b8:	97d2                	add	a5,a5,s4
 4ba:	0007c483          	lbu	s1,0(a5)
 4be:	20048963          	beqz	s1,6d0 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4c2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4c6:	fe0993e3          	bnez	s3,4ac <vprintf+0x46>
      if(c0 == '%'){
 4ca:	fd579ce3          	bne	a5,s5,4a2 <vprintf+0x3c>
        state = '%';
 4ce:	89be                	mv	s3,a5
 4d0:	b7c5                	j	4b0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4d2:	00ea06b3          	add	a3,s4,a4
 4d6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4da:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4dc:	c681                	beqz	a3,4e4 <vprintf+0x7e>
 4de:	9752                	add	a4,a4,s4
 4e0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4e4:	03878e63          	beq	a5,s8,520 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4e8:	05978863          	beq	a5,s9,538 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ec:	07500713          	li	a4,117
 4f0:	0ee78263          	beq	a5,a4,5d4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4f4:	07800713          	li	a4,120
 4f8:	12e78463          	beq	a5,a4,620 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4fc:	07000713          	li	a4,112
 500:	14e78963          	beq	a5,a4,652 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 504:	07300713          	li	a4,115
 508:	18e78863          	beq	a5,a4,698 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 50c:	02500713          	li	a4,37
 510:	04e79463          	bne	a5,a4,558 <vprintf+0xf2>
        putc(fd, '%');
 514:	85ba                	mv	a1,a4
 516:	855a                	mv	a0,s6
 518:	e9bff0ef          	jal	3b2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 51c:	4981                	li	s3,0
 51e:	bf49                	j	4b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 520:	008b8493          	addi	s1,s7,8
 524:	4685                	li	a3,1
 526:	4629                	li	a2,10
 528:	000ba583          	lw	a1,0(s7)
 52c:	855a                	mv	a0,s6
 52e:	ea3ff0ef          	jal	3d0 <printint>
 532:	8ba6                	mv	s7,s1
      state = 0;
 534:	4981                	li	s3,0
 536:	bfad                	j	4b0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 538:	06400793          	li	a5,100
 53c:	02f68963          	beq	a3,a5,56e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 540:	06c00793          	li	a5,108
 544:	04f68263          	beq	a3,a5,588 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 548:	07500793          	li	a5,117
 54c:	0af68063          	beq	a3,a5,5ec <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 550:	07800793          	li	a5,120
 554:	0ef68263          	beq	a3,a5,638 <vprintf+0x1d2>
        putc(fd, '%');
 558:	02500593          	li	a1,37
 55c:	855a                	mv	a0,s6
 55e:	e55ff0ef          	jal	3b2 <putc>
        putc(fd, c0);
 562:	85a6                	mv	a1,s1
 564:	855a                	mv	a0,s6
 566:	e4dff0ef          	jal	3b2 <putc>
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b791                	j	4b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	008b8493          	addi	s1,s7,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000ba583          	lw	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	e55ff0ef          	jal	3d0 <printint>
        i += 1;
 580:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 582:	8ba6                	mv	s7,s1
      state = 0;
 584:	4981                	li	s3,0
        i += 1;
 586:	b72d                	j	4b0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 588:	06400793          	li	a5,100
 58c:	02f60763          	beq	a2,a5,5ba <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 590:	07500793          	li	a5,117
 594:	06f60963          	beq	a2,a5,606 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 598:	07800793          	li	a5,120
 59c:	faf61ee3          	bne	a2,a5,558 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a0:	008b8493          	addi	s1,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4641                	li	a2,16
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	e23ff0ef          	jal	3d0 <printint>
        i += 2;
 5b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b4:	8ba6                	mv	s7,s1
      state = 0;
 5b6:	4981                	li	s3,0
        i += 2;
 5b8:	bde5                	j	4b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4685                	li	a3,1
 5c0:	4629                	li	a2,10
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e09ff0ef          	jal	3d0 <printint>
        i += 2;
 5cc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
        i += 2;
 5d2:	bdf9                	j	4b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5d4:	008b8493          	addi	s1,s7,8
 5d8:	4681                	li	a3,0
 5da:	4629                	li	a2,10
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	defff0ef          	jal	3d0 <printint>
 5e6:	8ba6                	mv	s7,s1
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b5d9                	j	4b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ec:	008b8493          	addi	s1,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4629                	li	a2,10
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	dd7ff0ef          	jal	3d0 <printint>
        i += 1;
 5fe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
        i += 1;
 604:	b575                	j	4b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 606:	008b8493          	addi	s1,s7,8
 60a:	4681                	li	a3,0
 60c:	4629                	li	a2,10
 60e:	000ba583          	lw	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	dbdff0ef          	jal	3d0 <printint>
        i += 2;
 618:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
        i += 2;
 61e:	bd49                	j	4b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 620:	008b8493          	addi	s1,s7,8
 624:	4681                	li	a3,0
 626:	4641                	li	a2,16
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	da3ff0ef          	jal	3d0 <printint>
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
 636:	bdad                	j	4b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 638:	008b8493          	addi	s1,s7,8
 63c:	4681                	li	a3,0
 63e:	4641                	li	a2,16
 640:	000ba583          	lw	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	d8bff0ef          	jal	3d0 <printint>
        i += 1;
 64a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
        i += 1;
 650:	b585                	j	4b0 <vprintf+0x4a>
 652:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 654:	008b8d13          	addi	s10,s7,8
 658:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 65c:	03000593          	li	a1,48
 660:	855a                	mv	a0,s6
 662:	d51ff0ef          	jal	3b2 <putc>
  putc(fd, 'x');
 666:	07800593          	li	a1,120
 66a:	855a                	mv	a0,s6
 66c:	d47ff0ef          	jal	3b2 <putc>
 670:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 672:	00000b97          	auipc	s7,0x0
 676:	2c6b8b93          	addi	s7,s7,710 # 938 <digits>
 67a:	03c9d793          	srli	a5,s3,0x3c
 67e:	97de                	add	a5,a5,s7
 680:	0007c583          	lbu	a1,0(a5)
 684:	855a                	mv	a0,s6
 686:	d2dff0ef          	jal	3b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68a:	0992                	slli	s3,s3,0x4
 68c:	34fd                	addiw	s1,s1,-1
 68e:	f4f5                	bnez	s1,67a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 690:	8bea                	mv	s7,s10
      state = 0;
 692:	4981                	li	s3,0
 694:	6d02                	ld	s10,0(sp)
 696:	bd29                	j	4b0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 698:	008b8993          	addi	s3,s7,8
 69c:	000bb483          	ld	s1,0(s7)
 6a0:	cc91                	beqz	s1,6bc <vprintf+0x256>
        for(; *s; s++)
 6a2:	0004c583          	lbu	a1,0(s1)
 6a6:	c195                	beqz	a1,6ca <vprintf+0x264>
          putc(fd, *s);
 6a8:	855a                	mv	a0,s6
 6aa:	d09ff0ef          	jal	3b2 <putc>
        for(; *s; s++)
 6ae:	0485                	addi	s1,s1,1
 6b0:	0004c583          	lbu	a1,0(s1)
 6b4:	f9f5                	bnez	a1,6a8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bbdd                	j	4b0 <vprintf+0x4a>
          s = "(null)";
 6bc:	00000497          	auipc	s1,0x0
 6c0:	27448493          	addi	s1,s1,628 # 930 <malloc+0x164>
        for(; *s; s++)
 6c4:	02800593          	li	a1,40
 6c8:	b7c5                	j	6a8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6ca:	8bce                	mv	s7,s3
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b3cd                	j	4b0 <vprintf+0x4a>
 6d0:	6906                	ld	s2,64(sp)
 6d2:	79e2                	ld	s3,56(sp)
 6d4:	7a42                	ld	s4,48(sp)
 6d6:	7aa2                	ld	s5,40(sp)
 6d8:	7b02                	ld	s6,32(sp)
 6da:	6be2                	ld	s7,24(sp)
 6dc:	6c42                	ld	s8,16(sp)
 6de:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6e0:	60e6                	ld	ra,88(sp)
 6e2:	6446                	ld	s0,80(sp)
 6e4:	64a6                	ld	s1,72(sp)
 6e6:	6125                	addi	sp,sp,96
 6e8:	8082                	ret

00000000000006ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ea:	715d                	addi	sp,sp,-80
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	addi	s0,sp,32
 6f2:	e010                	sd	a2,0(s0)
 6f4:	e414                	sd	a3,8(s0)
 6f6:	e818                	sd	a4,16(s0)
 6f8:	ec1c                	sd	a5,24(s0)
 6fa:	03043023          	sd	a6,32(s0)
 6fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	8622                	mv	a2,s0
 704:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 708:	d5fff0ef          	jal	466 <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6161                	addi	sp,sp,80
 712:	8082                	ret

0000000000000714 <printf>:

void
printf(const char *fmt, ...)
{
 714:	711d                	addi	sp,sp,-96
 716:	ec06                	sd	ra,24(sp)
 718:	e822                	sd	s0,16(sp)
 71a:	1000                	addi	s0,sp,32
 71c:	e40c                	sd	a1,8(s0)
 71e:	e810                	sd	a2,16(s0)
 720:	ec14                	sd	a3,24(s0)
 722:	f018                	sd	a4,32(s0)
 724:	f41c                	sd	a5,40(s0)
 726:	03043823          	sd	a6,48(s0)
 72a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 72e:	00840613          	addi	a2,s0,8
 732:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 736:	85aa                	mv	a1,a0
 738:	4505                	li	a0,1
 73a:	d2dff0ef          	jal	466 <vprintf>
}
 73e:	60e2                	ld	ra,24(sp)
 740:	6442                	ld	s0,16(sp)
 742:	6125                	addi	sp,sp,96
 744:	8082                	ret

0000000000000746 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 746:	1141                	addi	sp,sp,-16
 748:	e406                	sd	ra,8(sp)
 74a:	e022                	sd	s0,0(sp)
 74c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 752:	00001797          	auipc	a5,0x1
 756:	8ae7b783          	ld	a5,-1874(a5) # 1000 <freep>
 75a:	a02d                	j	784 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 75c:	4618                	lw	a4,8(a2)
 75e:	9f2d                	addw	a4,a4,a1
 760:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 764:	6398                	ld	a4,0(a5)
 766:	6310                	ld	a2,0(a4)
 768:	a83d                	j	7a6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 76a:	ff852703          	lw	a4,-8(a0)
 76e:	9f31                	addw	a4,a4,a2
 770:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 772:	ff053683          	ld	a3,-16(a0)
 776:	a091                	j	7ba <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 778:	6398                	ld	a4,0(a5)
 77a:	00e7e463          	bltu	a5,a4,782 <free+0x3c>
 77e:	00e6ea63          	bltu	a3,a4,792 <free+0x4c>
{
 782:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 784:	fed7fae3          	bgeu	a5,a3,778 <free+0x32>
 788:	6398                	ld	a4,0(a5)
 78a:	00e6e463          	bltu	a3,a4,792 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78e:	fee7eae3          	bltu	a5,a4,782 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 792:	ff852583          	lw	a1,-8(a0)
 796:	6390                	ld	a2,0(a5)
 798:	02059813          	slli	a6,a1,0x20
 79c:	01c85713          	srli	a4,a6,0x1c
 7a0:	9736                	add	a4,a4,a3
 7a2:	fae60de3          	beq	a2,a4,75c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7a6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7aa:	4790                	lw	a2,8(a5)
 7ac:	02061593          	slli	a1,a2,0x20
 7b0:	01c5d713          	srli	a4,a1,0x1c
 7b4:	973e                	add	a4,a4,a5
 7b6:	fae68ae3          	beq	a3,a4,76a <free+0x24>
    p->s.ptr = bp->s.ptr;
 7ba:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7bc:	00001717          	auipc	a4,0x1
 7c0:	84f73223          	sd	a5,-1980(a4) # 1000 <freep>
}
 7c4:	60a2                	ld	ra,8(sp)
 7c6:	6402                	ld	s0,0(sp)
 7c8:	0141                	addi	sp,sp,16
 7ca:	8082                	ret

00000000000007cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7cc:	7139                	addi	sp,sp,-64
 7ce:	fc06                	sd	ra,56(sp)
 7d0:	f822                	sd	s0,48(sp)
 7d2:	f04a                	sd	s2,32(sp)
 7d4:	ec4e                	sd	s3,24(sp)
 7d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d8:	02051993          	slli	s3,a0,0x20
 7dc:	0209d993          	srli	s3,s3,0x20
 7e0:	09bd                	addi	s3,s3,15
 7e2:	0049d993          	srli	s3,s3,0x4
 7e6:	2985                	addiw	s3,s3,1
 7e8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7ea:	00001517          	auipc	a0,0x1
 7ee:	81653503          	ld	a0,-2026(a0) # 1000 <freep>
 7f2:	c905                	beqz	a0,822 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f6:	4798                	lw	a4,8(a5)
 7f8:	09377663          	bgeu	a4,s3,884 <malloc+0xb8>
 7fc:	f426                	sd	s1,40(sp)
 7fe:	e852                	sd	s4,16(sp)
 800:	e456                	sd	s5,8(sp)
 802:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 804:	8a4e                	mv	s4,s3
 806:	6705                	lui	a4,0x1
 808:	00e9f363          	bgeu	s3,a4,80e <malloc+0x42>
 80c:	6a05                	lui	s4,0x1
 80e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 812:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 816:	00000497          	auipc	s1,0x0
 81a:	7ea48493          	addi	s1,s1,2026 # 1000 <freep>
  if(p == (char*)-1)
 81e:	5afd                	li	s5,-1
 820:	a83d                	j	85e <malloc+0x92>
 822:	f426                	sd	s1,40(sp)
 824:	e852                	sd	s4,16(sp)
 826:	e456                	sd	s5,8(sp)
 828:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 82a:	00000797          	auipc	a5,0x0
 82e:	7e678793          	addi	a5,a5,2022 # 1010 <base>
 832:	00000717          	auipc	a4,0x0
 836:	7cf73723          	sd	a5,1998(a4) # 1000 <freep>
 83a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 840:	b7d1                	j	804 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 842:	6398                	ld	a4,0(a5)
 844:	e118                	sd	a4,0(a0)
 846:	a899                	j	89c <malloc+0xd0>
  hp->s.size = nu;
 848:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 84c:	0541                	addi	a0,a0,16
 84e:	ef9ff0ef          	jal	746 <free>
  return freep;
 852:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 854:	c125                	beqz	a0,8b4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 856:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 858:	4798                	lw	a4,8(a5)
 85a:	03277163          	bgeu	a4,s2,87c <malloc+0xb0>
    if(p == freep)
 85e:	6098                	ld	a4,0(s1)
 860:	853e                	mv	a0,a5
 862:	fef71ae3          	bne	a4,a5,856 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 866:	8552                	mv	a0,s4
 868:	b1bff0ef          	jal	382 <sbrk>
  if(p == (char*)-1)
 86c:	fd551ee3          	bne	a0,s5,848 <malloc+0x7c>
        return 0;
 870:	4501                	li	a0,0
 872:	74a2                	ld	s1,40(sp)
 874:	6a42                	ld	s4,16(sp)
 876:	6aa2                	ld	s5,8(sp)
 878:	6b02                	ld	s6,0(sp)
 87a:	a03d                	j	8a8 <malloc+0xdc>
 87c:	74a2                	ld	s1,40(sp)
 87e:	6a42                	ld	s4,16(sp)
 880:	6aa2                	ld	s5,8(sp)
 882:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 884:	fae90fe3          	beq	s2,a4,842 <malloc+0x76>
        p->s.size -= nunits;
 888:	4137073b          	subw	a4,a4,s3
 88c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 88e:	02071693          	slli	a3,a4,0x20
 892:	01c6d713          	srli	a4,a3,0x1c
 896:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 898:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 89c:	00000717          	auipc	a4,0x0
 8a0:	76a73223          	sd	a0,1892(a4) # 1000 <freep>
      return (void*)(p + 1);
 8a4:	01078513          	addi	a0,a5,16
  }
}
 8a8:	70e2                	ld	ra,56(sp)
 8aa:	7442                	ld	s0,48(sp)
 8ac:	7902                	ld	s2,32(sp)
 8ae:	69e2                	ld	s3,24(sp)
 8b0:	6121                	addi	sp,sp,64
 8b2:	8082                	ret
 8b4:	74a2                	ld	s1,40(sp)
 8b6:	6a42                	ld	s4,16(sp)
 8b8:	6aa2                	ld	s5,8(sp)
 8ba:	6b02                	ld	s6,0(sp)
 8bc:	b7f5                	j	8a8 <malloc+0xdc>
