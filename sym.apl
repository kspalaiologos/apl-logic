 sim←{
     eunderspec←'Underspecified system. Missing the definition of nodes: '
     enoint←'Failed to ensure integrity of the system'
     epref←'Invalid prefix in specifier '
     ea←' requires no arguments.' ' requires one argument.' ' requires two arguments.'

     ⍺←0.5
     code←{
         (2⊃¨v/⍨x)@(⍸x←∊⊃¨v←⎕VFI¨⍵)⊢⍵
     }¨' '(≠⊆⊢)¨⊃⎕NGET ⍵ 1
     ind←⊃¨srt←code[⍋⊃¨code]
     sys←∪{⍵/⍨(2|⎕DR)¨⍵}↑,/2↓¨srt
     vrf←sys∊⍥∊ind
     0=∧/vrf:(∊eunderspec(⍕sys/⍨~vrf))⎕SIGNAL 8
     (≢≠⊃∘⌽)ind:enoint ⎕SIGNAL 8
     leds←⍸(⊂'LED')≡¨2⊃¨srt
     unpref←{'x'≠1↑⍵:(epref ⍵)⎕SIGNAL 8 ⋄ 1↓⍵}
     load←{∊'v[',(⍕⍵),']'}
     fmt←{{⍵/⍨(∨\∧∘⌽∨\∘⌽)' '≠⍵}∊('⍝'(≠⊆⊢)∊' '⍺' '),¨⍵,⊂⍬}
     state←⎕NS ⍬ ⋄ state.v←0⍴⍨≢srt ⋄ state.t←0
     arity←⊂'HIGH' 'LOW'
     arity,←⊂'NOT' 'LED' 'BUTTON' 'CLOCK'
     arity,←⊂'AND' 'OR' 'XOR' 'XNOR'
     chka←{
         0=∨/ind←(⊂⍺)∘∊¨arity:0
         ⍵≠¯1+⍸ind:(∊⍺,ea[⍸ind])⎕SIGNAL 8 ⋄ 1
     }
     src←∊'⋄'(1↓∘,,⍤0)(⊂'t+←1⋄⍬'),⍨{
         var op args←2(↑,⊂⍤↓)⍵ ⋄ _←op chka≢args
         av←load¨var,args
         op≡'AND':'⍝←⍝∧⍝'fmt av⋄op≡'OR':'⍝←⍝∨⍝'fmt av
         op≡'XOR':'⍝←⍝≠⍝'fmt av⋄op≡'XNOR':'⍝←⍝=⍝'fmt av
         op≡'NOT':'⍝←~⍝'fmt av⋄op≡'HIGH':'⍝←1'fmt⊂av
         op≡'LOW':'⍝←0'fmt⊂av⋄op≡'LED':''
         op≡'BUTTON':'⍝←0≠⍝ t'fmt(⊂load var),args
         op≡'CLOCK':'⍝←0=⍝|t'fmt(⊂load var),⊂unpref⊃args
         (∊'unrecognised op 'op)⎕SIGNAL 8
     }¨srt
     ⍺∘{
         _←'state'⍎src
         ⎕←∊'Time: '(⍕state.t)' LEDs: '(⍕leds,¨state.v[3⊃¨srt[leds]])
         ⎕DL ⍺
     }⍣{0}⊢⍬
 }
