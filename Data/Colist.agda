------------------------------------------------------------------------
-- Coinductive lists
------------------------------------------------------------------------

module Data.Colist where

open import Data.Nat
open import Data.List using (List; []; _∷_)

------------------------------------------------------------------------
-- The type

infixr 5 _∷_

codata Colist (a : Set) : Set where
  []  : Colist a
  _∷_ : (x : a) (xs : Colist a) → Colist a

{-# COMPILED_DATA Colist [] [] (:) #-}

------------------------------------------------------------------------
-- Some operations

fromList : {a : Set} → List a → Colist a
fromList []       = []
fromList (x ∷ xs) = x ∷ fromList xs

take : {a : Set} → ℕ → Colist a → List a
take zero    xs       = []
take (suc n) []       = []
take (suc n) (x ∷ xs) = take n xs

infixr 5 _++_

_++_ : ∀ {a} → Colist a → Colist a → Colist a
[]       ++ ys ~ ys
(x ∷ xs) ++ ys ~ x ∷ (xs ++ ys)
