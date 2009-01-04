------------------------------------------------------------------------
-- Coprimality
------------------------------------------------------------------------

module Data.Nat.Coprimality where

open import Data.Nat
open import Data.Nat.Divisibility
open import Data.Nat.GCD
open import Data.Product
open import Data.Function
open import Data.Empty
open import Relation.Binary.PropositionalEquality

-- Coprime m n is inhabited iff m and n are coprime (relatively
-- prime), i.e. if their only common divisor is 1.

Coprime : (m n : ℕ) → Set
Coprime m n = ∀ {i} → i Divides m And n → i ≡ 1

-- Coprime numbers have 1 as their gcd.

coprime-gcd : ∀ {m n} → Coprime m n → GCD m n 1
coprime-gcd {m} {n} c = isGCD (1-divides m , 1-divides n) (div _)
  where
  div : ∀ d → d Divides m And n → d Divides 1
  div  d cd with c cd
  div .1 cd | ≡-refl = 1-divides 1

-- If two numbers have 1 as their gcd, then they are coprime.

gcd-coprime : ∀ {m n} → GCD m n 1 → Coprime m n
gcd-coprime g  {i} cd with gcd-largest g cd
gcd-coprime g .{1} cd | s≤s z≤n = ≡-refl
gcd-coprime g .{0} cd | z≤n     =
  ⊥-elim {0 ≡ 1} $ 0-doesNotDivide (proj₁ cd)

-- The coprimality relation is symmetric.

coprime-sym : ∀ {m n} → Coprime m n → Coprime n m
coprime-sym c = c ∘ swap

-- Everything is coprime to 1.

1-coprimeTo : ∀ m → Coprime 1 m
1-coprimeTo m = c _ ∘ proj₁
  where
  c : ∀ i → i Divides 1 → i ≡ 1
  c 0             ()
  c 1             _                    = ≡-refl
  c (suc (suc _)) (divides 0       ())
  c (suc (suc _)) (divides (suc _) ())

-- Nothing is coprime to 0, except for 1.

0-coprimeTo-1 : ∀ {m} → Coprime 0 m → m ≡ 1
0-coprimeTo-1 {1}           _ = ≡-refl
0-coprimeTo-1 {zero}        c with c (1 +1-divides-0 , 1 +1-divides-0)
... | ()
0-coprimeTo-1 {suc (suc m)} c with c ( (1 + m) +1-divides-0
                                     , divides-refl (1 + m) )
... | ()

-- If m and n are coprime, then n + m and n are also coprime.

coprime-+ : ∀ {m n} → Coprime m n → Coprime (n + m) n
coprime-+ {m = zero} {n}           c with 0-coprimeTo-1 c
coprime-+ {m = zero} {1}           c | ≡-refl = 1-coprimeTo 1
coprime-+ {m = zero} {zero}        c | ()
coprime-+ {m = zero} {suc (suc _)} c | ()
coprime-+ {m = suc _}              c =
  λ d → c (divides-∸ (proj₁ d) (proj₂ d) , proj₂ d)
