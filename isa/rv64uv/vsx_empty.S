# See LICENSE for license details.

#*****************************************************************************
# vsx_empty.S
#-----------------------------------------------------------------------------
#
# Test empty vsx* instructions in a vf block.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UV
RVTEST_CODE_BEGIN

  vsetcfg 5,3
  li a4,512
  vsetvl a4,a4

  la a5,src
  la a6,dest
  vmca va1, a5
  vmca va2, a6
  vmcs vs1, a6
1:auipc a0,%pcrel_hi(vtcode)
  vf %pcrel_lo(1b)(a0)
  fence

  li a2,0
loop:
  ld a0,0(a6)
  ld a1,0(a5)
  addi TESTNUM,a2,2
  bne a0,a1,fail
  addi a6,a6,8
  addi a5,a5,8
  addi a2,a2,1
  bne a2,a4,loop
  j pass

.align 3
vtcode:
     vpset vp0
     vadd.ss vv2,vs0,vs0
     vld vv1, va1
     vsd vv1, va2
     vpclear vp1
     veidx vv3
     vaddi vs3,vs0,3
     vsll.vs vv3,vv3,vs3
@vp1 vsxd vv2, vs1, vv3
@vp1 vsxw vv2, vs1, vv3
@vp1 vsxh vv2, vs1, vv3
@vp1 vsxb vv2, vs1, vv3
     vstop

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

src:
#include "data_d.h"

dest:
  .skip 16384

RVTEST_DATA_END
