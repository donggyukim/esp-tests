# See LICENSE for license details.

#*****************************************************************************
# vvadd_fd.S
#-----------------------------------------------------------------------------
#
# Test vvadd fd.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 32,1
  li a3,4
  vsetvl a3,a3

  la a3,src1
  vmca va2,a3
  la a4,src2
  vmca va3,a4
  la a5,dest
  vmca va1,a5
1:auipc a0,%pcrel_hi(vtcode)
  vf %pcrel_lo(1b)(a0)
  fence
  la a6,result
  ld a1,0(a5)
  ld a2,0(a6)
  li TESTNUM,2
  bne a1,a2,fail
  ld a1,8(a5)
  li TESTNUM,3
  bne a1,a2,fail
  ld a1,16(a5)
  li TESTNUM,4
  bne a1,a2,fail
  ld a1,24(a5)
  li TESTNUM,5
  bne a1,a2,fail
  j pass

.align 3
vtcode:
  vpset vp0
  vld vv2,va2
  vld vv3,va3
  vfadd.d.vv vv2,vv2,vv3
  vsd vv2,va1
  vstop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src1:
  .double 0.1
  .double 0.2
  .double 0.3
  .double 0.4
src2:
  .double 0.4
  .double 0.3
  .double 0.2
  .double 0.1
dest:
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
  .dword 0xdeadbeefcafebabe
result:
  .double 0.5
  .double 0.5
  .double 0.5
  .double 0.5

RVTEST_DATA_END
