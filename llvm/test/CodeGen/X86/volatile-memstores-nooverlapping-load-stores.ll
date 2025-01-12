; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s


declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg) #1
define dso_local void @copy_7_bytes(i8* noalias nocapture, i8* noalias nocapture readonly) nounwind #0 {
; CHECK-LABEL: copy_7_bytes:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl (%rsi), %eax
; CHECK-NEXT:    movl 3(%rsi), %ecx
; CHECK-NEXT:    movl %ecx, 3(%rdi)
; CHECK-NEXT:    movl %eax, (%rdi)
; CHECK-NEXT:    retq
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %0, i8* align 1 %1, i64 7, i1 false)
  ret void
}
define dso_local void @copy_7_bytes_volatile(i8* noalias nocapture, i8* noalias nocapture readonly) nounwind #0 {
; CHECK-LABEL: copy_7_bytes_volatile:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl 6(%rsi), %eax
; CHECK-NEXT:    movb %al, 6(%rdi)
; CHECK-NEXT:    movzwl 4(%rsi), %eax
; CHECK-NEXT:    movw %ax, 4(%rdi)
; CHECK-NEXT:    movl (%rsi), %eax
; CHECK-NEXT:    movl %eax, (%rdi)
; CHECK-NEXT:    retq
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %0, i8* align 1 %1, i64 7, i1 true)
  ret void
}


declare void @llvm.memmove.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i1 immarg) #1
define dso_local void @move_7_bytes(i8* nocapture, i8* nocapture readonly) nounwind #0 {
; CHECK-LABEL: move_7_bytes:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl (%rsi), %eax
; CHECK-NEXT:    movzwl 4(%rsi), %ecx
; CHECK-NEXT:    movzbl 6(%rsi), %edx
; CHECK-NEXT:    movb %dl, 6(%rdi)
; CHECK-NEXT:    movw %cx, 4(%rdi)
; CHECK-NEXT:    movl %eax, (%rdi)
; CHECK-NEXT:    retq
  tail call void @llvm.memmove.p0i8.p0i8.i64(i8* align 1 %0, i8* align 1 %1, i64 7, i1 false)
  ret void
}
define dso_local void @move_7_bytes_volatile(i8* nocapture, i8* nocapture readonly) nounwind #0 {
; CHECK-LABEL: move_7_bytes_volatile:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl (%rsi), %eax
; CHECK-NEXT:    movzwl 4(%rsi), %ecx
; CHECK-NEXT:    movzbl 6(%rsi), %edx
; CHECK-NEXT:    movb %dl, 6(%rdi)
; CHECK-NEXT:    movw %cx, 4(%rdi)
; CHECK-NEXT:    movl %eax, (%rdi)
; CHECK-NEXT:    retq
  tail call void @llvm.memmove.p0i8.p0i8.i64(i8* align 1 %0, i8* align 1 %1, i64 7, i1 true)
  ret void
}


declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8 , i64, i1 immarg) #1
define dso_local void @set_7_bytes(i8* noalias nocapture) nounwind #0 {
; CHECK-LABEL: set_7_bytes:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $16843009, 3(%rdi) # imm = 0x1010101
; CHECK-NEXT:    movl $16843009, (%rdi) # imm = 0x1010101
; CHECK-NEXT:    retq
  tail call void @llvm.memset.p0i8.i64(i8* align 1 %0, i8 1, i64 7, i1 false)
  ret void
}
define dso_local void @set_7_bytes_volatile(i8* noalias nocapture) nounwind #0 {
; CHECK-LABEL: set_7_bytes_volatile:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movb $1, 6(%rdi)
; CHECK-NEXT:    movw $257, 4(%rdi) # imm = 0x101
; CHECK-NEXT:    movl $16843009, (%rdi) # imm = 0x1010101
; CHECK-NEXT:    retq
  tail call void @llvm.memset.p0i8.i64(i8* align 1 %0, i8 1, i64 7, i1 true)
  ret void
}

attributes #0 = { noreturn nounwind uwtable "target-cpu"="x86-64" }
attributes #1 = { argmemonly nounwind }
