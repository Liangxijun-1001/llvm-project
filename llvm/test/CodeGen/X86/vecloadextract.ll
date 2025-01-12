; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;RUN: llc < %s -mtriple=i686 -mattr=sse4.1 -stop-after=finalize-isel 2>&1 | FileCheck %s

; This test makes sure we discard pointer info when we combine a vector load
; and a variable extractelement into a scalar load using an index. There's also
; a test to ensure we don't discard it for the constant index case.

; CHECK: name: const_index
; CHECK:  bb.0 (%ir-block.0):
; CHECK:    [[POINTER:%[0-9]+]]:gr32 = MOV32rm %fixed-stack.0, 1, $noreg, 0, $noreg :: (load (s32) from %fixed-stack.0)
; CHECK:    [[LOAD:%[0-9]+]]:gr32 = MOV32rm killed [[POINTER]], 1, $noreg, 4, $noreg :: (load (s32) from %ir.v + 4)
; CHECK:    $eax = COPY [[LOAD]]
; CHECK:    RET 0, $eax
define i32 @const_index(<8 x i32>* %v) {
  %a = load <8 x i32>, <8 x i32>* %v
  %b = extractelement <8 x i32> %a, i32 1
  ret i32 %b
}

; CHECK: name: variable_index
; CHECK:  bb.0 (%ir-block.0):
; CHECK:    [[INDEX:%[0-9]+]]:gr32 = MOV32rm %fixed-stack.0, 1, $noreg, 0, $noreg :: (load (s32) from %fixed-stack.0)
; CHECK:    [[MASKED_INDEX:%[0-9]+]]:gr32_nosp = AND32ri [[INDEX]], 7, implicit-def dead $eflags
; CHECK:    [[POINTER:%[0-9]+]]:gr32 = MOV32rm %fixed-stack.1, 1, $noreg, 0, $noreg :: (load (s32) from %fixed-stack.1)
; CHECK:    [[LOAD:%[0-9]+]]:gr32 = MOV32rm killed [[POINTER]], 4, killed [[MASKED_INDEX]], 0, $noreg :: (load (s32))
; CHECK:    $eax = COPY [[LOAD]]
; CHECK:    RET 0, $eax
define i32 @variable_index(<8 x i32>* %v, i32 %i) {
  %a = load <8 x i32>, <8 x i32>* %v
  %b = extractelement <8 x i32> %a, i32 %i
  ret i32 %b
}

; CHECK: name: variable_index_with_addrspace
; CHECK:  bb.0 (%ir-block.0):
; CHECK:    [[INDEX:%[0-9]+]]:gr32 = MOV32rm %fixed-stack.0, 1, $noreg, 0, $noreg :: (load (s32) from %fixed-stack.0)
; CHECK:    [[MASKED_INDEX:%[0-9]+]]:gr32_nosp = AND32ri [[INDEX]], 7, implicit-def dead $eflags
; CHECK:    [[POINTER:%[0-9]+]]:gr32 = MOV32rm %fixed-stack.1, 1, $noreg, 0, $noreg :: (load (s32) from %fixed-stack.1)
; CHECK:    [[LOAD:%[0-9]+]]:gr32 = MOV32rm killed [[POINTER]], 4, killed [[MASKED_INDEX]], 0, $noreg :: (load (s32), addrspace 1)
; CHECK:    $eax = COPY [[LOAD]]
; CHECK:    RET 0, $eax
define i32 @variable_index_with_addrspace(<8 x i32> addrspace(1)* %v, i32 %i) {
  %a = load <8 x i32>, <8 x i32> addrspace(1)* %v
  %b = extractelement <8 x i32> %a, i32 %i
  ret i32 %b
}
